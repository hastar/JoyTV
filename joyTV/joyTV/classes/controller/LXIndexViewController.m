//
//  LXIndexViewController.m
//  joyTV
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXIndexViewController.h"
#import "LXSegmentControl.h"
#import "LXHotCollectView.h"
#import "LXDtViewController.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LXColor(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]

@interface LXIndexViewController () <LXSegmentControlDelegate, LXHotCollectViewDelegate>

//分类名称数组
@property (nonatomic, strong) NSArray *cateArray;
//分类连接数组
@property (nonatomic, strong) NSArray *cateLinkArray;
@property (nonatomic, strong) LXSegmentControl *segment;
@property (nonatomic, strong) NSMutableArray *collectArray;

@end

@implementation LXIndexViewController

- (NSArray *)cateLinkArray
{
    if (!_cateLinkArray) {
        _cateLinkArray = [[NSArray alloc] initWithObjects:@"https://newapi.meipai.com/medias/topics_timeline.json?id=13&type=1&feature=new&locale=1",
                          @"https://newapi.meipai.com/medias/topics_timeline.json?id=5872239354896137479&type=2&feature=hot&locale=1",
                          @"https://newapi.meipai.com/medias/topics_timeline.json?id=18&type=1&feature=new&locale=1",
                          @"https://newapi.meipai.com/medias/topics_timeline.json?id=5&type=1&feature=new&locale=1",nil];
    }
    
    return _cateLinkArray;
}

- (NSArray*)cateArray
{
    if (!_cateArray) {
        _cateArray = [[NSArray alloc] initWithObjects:@"搞笑", @"舞蹈", @"宝宝", @"涨姿势", nil];
    }
    
    return _cateArray;
}

- (NSMutableArray *)collectArray
{
    if (!_collectArray)
    {
        //循环创建瀑布流界面
        _collectArray = [[NSMutableArray alloc] initWithCapacity:2];
        for (int i = 0; i < self.cateArray.count; i++)
        {
            LXHotCollectView *collectView = [[LXHotCollectView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - 70 - 40)];
            collectView.delegate = self;
            collectView.name = self.cateArray[i];
            collectView.dataUrl = self.cateLinkArray[i];
            
            [_collectArray addObject:collectView];
        }
        
    }
    
    return _collectArray;
}


#pragma mark segment切换时响应的方法
-(void)LXSegmentControl:(LXSegmentControl *)segment didSelectItemAtIndex:(NSInteger)index
{
   for (int i = 0;  i < self.collectArray.count; i++)
    {
        LXHotCollectView *collectView = self.collectArray[i];
        if (index == i)
        {
            collectView.hidden = NO;
        }
        else
        {
            collectView.hidden = YES;
        }
    }
}

-(LXSegmentControl *)segment
{
    if (!_segment) {
        _segment = [[LXSegmentControl alloc] initWithFrame:CGRectMake(25, 30, [UIScreen mainScreen].bounds.size.width-50, 30)];
        
        _segment.delegate = self;
        _segment.buttons = self.cateArray;
        [_segment setSliderColor:LXColor(253.0/255, 189.0/255, 10.0/255)];
        [_segment setFont:[UIFont systemFontOfSize:15]];
        [_segment setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
        [_segment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_segment setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
    }
    
    return _segment;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    
    for (int i = 0; i < self.collectArray.count; i ++) {
        LXHotCollectView *collectView = self.collectArray[i];
        [self.view addSubview:collectView];
        [collectView refresh];
        collectView.hidden = YES;
    }
    
    self.segment.selected = 0;
    LXHotCollectView *collectView = self.collectArray[0];
    collectView.hidden = NO;
    
}

#pragma mark 瀑布流点击方法
-(void)LXHotCollectView:(LXHotCollectView *)collectView didSelectIndexPath:(NSIndexPath *)indexPath movieModel:(LXMovieModel *)movieModel
{
    //推到详情页面
    LXDtViewController *dtVc = [[LXDtViewController alloc] init];
    dtVc.model = movieModel;
    
    [self.navigationController pushViewController:dtVc animated:YES];

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
