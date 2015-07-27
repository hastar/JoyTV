//
//  LXHotViewController.m
//  joyTV
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXHotViewController.h"
#import "LXSegmentControl.h"
#import "LXHotCollectView.h"
#import "LXDtViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LXColor(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
@interface LXHotViewController () <LXSegmentControlDelegate, LXHotCollectViewDelegate>

@property (nonatomic, strong) LXSegmentControl *segment;
@property (nonatomic, strong) LXHotCollectView *hotCollectView;
@property (nonatomic, strong) LXHotCollectView *newCollectView;

@end

@implementation LXHotViewController


-(LXSegmentControl *)segment
{
    if (!_segment) {
        _segment = [[LXSegmentControl alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50)];
        
        _segment.delegate = self;
        _segment.buttons = @[@"最  新", @"热  门"];
        [_segment setSliderColor:LXColor(253.0/255, 189.0/255, 10.0/255, 1.0)];
        [_segment setFont:[UIFont systemFontOfSize:20]];
        [_segment setBackgroundColor:LXColor(0.99, 0.99, 0.99, 1.0)];
        [_segment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_segment setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

    }
    
    return _segment;
}

- (LXHotCollectView *)hotCollectView
{
    if (!_hotCollectView) {
        _hotCollectView = [[LXHotCollectView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - 70 - 40)];
        _hotCollectView.delegate = self;
        _hotCollectView.dataUrl = @"https://newapi.meipai.com/hot/feed_timeline.json?locale=1&";
    }
    
    return  _hotCollectView;
}

- (LXHotCollectView *)newCollectView
{
    if (!_newCollectView) {
        _newCollectView = [[LXHotCollectView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - 70 - 40)];
        _newCollectView.delegate = self;
        _newCollectView.dataUrl = @"https://newapi.meipai.com/medias/topics_timeline.json?id=22&type=1&feature=new&locale=1";
    }
    
    return _newCollectView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.hotCollectView];
    [self.view addSubview:self.newCollectView];
    [self.view addSubview:self.segment];
    self.segment.selectedIndex = 0;
    self.hotCollectView.hidden = YES;
    [self.newCollectView refresh];
    [self.hotCollectView refresh];
}


-(void)LXSegmentControl:(LXSegmentControl *)segment didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"选中------%ld", index);
    switch (index)
    {
        case 0:
        {
            self.hotCollectView.hidden = YES;
            self.newCollectView.hidden = NO;
            break;
        }
        case 1:
        {
            self.hotCollectView.hidden = NO;
            self.newCollectView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

-(void)LXHotCollectView:(LXHotCollectView *)collectView didSelectIndexPath:(NSIndexPath *)indexPath movieModel:(LXMovieModel *)movieModel
{
    
    NSLog(@"video URL = %@, time = %@", movieModel.video, movieModel.created_at);
    
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
