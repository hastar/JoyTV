//
//  LXCollectViewController.m
//  joyTV
//
//  Created by lanou on 15/7/28.
//  Copyright (c) 2015年 hastar. All rights reserved.
//


#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXCollectViewController.h"
#import "LXHotCollectView.h"
#import "LXHotCollectionViewCell.h"
#import "LXMovieModel.h"
#import "UIImageView+WebCache.h"
#import "LXDtViewController.h"
#import "LXUser.h"

#define kSpacing 2
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXCollectViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation LXCollectViewController



- (UICollectionView *)collectView
{
    if (!_collectView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(150, 150);
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.minimumLineSpacing = 2 + 3;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.showsHorizontalScrollIndicator = NO;
        _collectView.showsVerticalScrollIndicator = NO;
    }
    
    return _collectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectView];

    
    UINib *nib = [UINib nibWithNibName:@"LXHotCollectionViewCell" bundle:nil];
    [_collectView registerNib:nib forCellWithReuseIdentifier:@"hotcell"];
    
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
    
    
    return CGSizeMake(itemWidt, itemWidt + 35 + 25);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXMovieModel *model = self.modelArray[indexPath.row];
    LXDtViewController *dtVc = [[LXDtViewController alloc] init];
    dtVc.model = model;
    
    [self.navigationController pushViewController:dtVc animated:YES];
    
    LXLog(@"%@", model.recommend_caption);
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    self.tabBarController.tabBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
