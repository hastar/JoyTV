//
//  LXHotCollectView.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXHotCollectView.h"
#import "LXHotCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#import "LXUser.h"
#import "LXMovieModel.h"

#define kSpacing 2
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXHotCollectView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger page;

@end

@implementation LXHotCollectView

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
    if (self) {
        self.page = 2;
        self.isUpLoading = NO;
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
        [self addSubview:_collectView];
        
        UINib *nib = [UINib nibWithNibName:@"LXHotCollectionViewCell" bundle:nil];
        [_collectView registerNib:nib forCellWithReuseIdentifier:@"hotcell"];
    }
    
    return self;
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
    
    
    return CGSizeMake(itemWidt, itemWidt + 35 + 30);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isUpLoading && indexPath.row >= self.modelArray.count-5) {
        
        NSLog(@"-----------------------------------正在更新数据,当前总共有%ld--%ld", self.modelArray.count, indexPath.row);
        self.isUpLoading = YES;
        [self reloadMoreData];
    }
}

- (void)reloadMoreData
{
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%ld", self.dataUrl, (long)self.page];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    
    __block typeof(self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:requset queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil || data.length == 0) {
            return ;
        }
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@", array);
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
        
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
