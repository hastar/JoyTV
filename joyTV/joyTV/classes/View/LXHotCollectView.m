//
//  LXHotCollectView.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXHotCollectView.h"
#import "LXHotCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#import "LXUser.h"
#import "LXMovieModel.h"
#import "LXDataBaseHandle.h"

#import "AFNetworking.h"

#define kSpacing 2
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXHotCollectView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger page;       //当前加载第多少页数据
@property (nonatomic, assign) BOOL isUpLoading;     //是否正在加载网络数据
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@property (nonatomic, assign) BOOL hasLoaded;

@end

@implementation LXHotCollectView


//更新数据
-(void)refresh
{
    [self reloadMoreData];
}

-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _modelArray;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.page = 2;
        self.isUpLoading = NO;
        self.hasLoaded = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(150, 150);
        flowLayout.minimumInteritemSpacing = kSpacing;
        flowLayout.minimumLineSpacing = kSpacing + 3;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectView];
        
        UINib *nib = [UINib nibWithNibName:@"LXHotCollectionViewCell" bundle:nil];
        [_collectView registerNib:nib forCellWithReuseIdentifier:@"hotcell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginLoad:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localData:) name:@"localData" object:nil];
    }
    
    return self;
}

#pragma mark 来网之后加载数据
-(void)beginLoad:(id)sender
{
    if (!self.hasLoaded && [[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self refresh];
    }  
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXHotCollectionViewCell *collectCell = (LXHotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"hotcell" forIndexPath:indexPath];
    
    LXMovieModel *model = self.modelArray[indexPath.row];
    [collectCell.movieImage sd_setImageWithURL:[NSURL URLWithString:model.cover_pic] placeholderImage:[UIImage new]];
    collectCell.movieDesc.text = model.recommend_caption;
    
    collectCell.userNameLabel.text = model.user.screen_name;
    [collectCell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage new]];
    [collectCell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar]];

    
    return collectCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidt;
    if (kScreenWidth > kScreenHeight) {
        itemWidt = kScreenWidth / 4 - kSpacing;
    }
    else
    {
        itemWidt = kScreenWidth / 2 - kSpacing;
    }
    
    
    return CGSizeMake(itemWidt, itemWidt + 35 + 25);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //滚到最后5个时，开始加载下一页
    if (!self.isUpLoading && indexPath.row >= self.modelArray.count-5)
    {
        LXLog(@"---------正在更新数据,当前总共有%ld--%ld", self.modelArray.count, indexPath.row);
        self.isUpLoading = YES;
        [self reloadMoreData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXMovieModel *model = self.modelArray[indexPath.row];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(LXHotCollectView:didSelectIndexPath:movieModel:)]) {
        [self.delegate LXHotCollectView:self didSelectIndexPath:indexPath movieModel:model];
    }
    
    
    
    
    
    LXLog(@"%@", model.recommend_caption);
}


#pragma mark 刷新数据
- (void)reloadMoreData
{
    
    self.httpManager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%ld", self.dataUrl, (long)self.page];
    
    __block typeof(self) weakSelf = self;
    self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.httpManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        LXLog(@"数据请求成功");
        
        if (!weakSelf.hasLoaded)
        {
            //如果是第一次加载网络数据，则删除原有数据
            [weakSelf.modelArray removeAllObjects];
        }
        weakSelf.hasLoaded = YES;
        
        NSData *data = responseObject;
        if (data == nil || data.length == 0) {
            return ;
        }
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *dict in array) {
            LXMovieModel *model = [[LXMovieModel alloc] init];
            model.recommend_caption = dict[@"recommend_caption"];
            NSDictionary *mediaDict = dict[@"media"];
            [model setValuesForKeysWithDictionary:mediaDict];
            
            [weakSelf.modelArray addObject:model];
            
        }
        
        weakSelf.page += 1;
        [weakSelf.collectView reloadData];
        weakSelf.isUpLoading = NO;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weakSelf.isUpLoading = NO;
        
        if (!self.hasLoaded)
        {
            //当前没有网络，且是第一次加载，则加载数据库内容
            [weakSelf loadLocalData];
            //            [weakSelf.modelArray removeAllObjects];
//            
//            NSArray *array = [LXDataBaseHandle arrayLocalModelWithCategory:[weakSelf.name copy]];
//            
//            if (array == nil) {
//                return ;
//            }
//            
//            [weakSelf.modelArray addObjectsFromArray:array];
//            [weakSelf.collectView reloadData];
        }
        
        
        LXLog(@"数据请求失败");
    } ];
}

-(void)loadLocalData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array = [[LXDataBaseHandle shareInstance] arrayLocalModelWithCategory:_name];
        
        if (array == nil) {
            return ;
        }
        
        [self.modelArray removeAllObjects];
        [self.modelArray addObjectsFromArray:array];
        [self.collectView reloadData];
    });
    
}


-(void)dealloc
{
    //关闭所有网络请求
    [self.httpManager.operationQueue cancelAllOperations];
}


- (void) localData:(id)sender
{
    NSArray *array = [NSArray arrayWithArray:self.modelArray];
    NSString *tempName = [NSString stringWithFormat:@"%@", self.name];
    
//    NSLog(@"%ld",[NSThread isMainThread ]);
//    [[LXDataBaseHandle shareInstance] testData:tempName];
    [[LXDataBaseHandle shareInstance] testData:array andCategory:tempName];
    [[LXDataBaseHandle shareInstance] saveModeWithArray:array andCategory:tempName];
    [[LXDataBaseHandle shareInstance] localModeWithArray:array andCategory:tempName];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
