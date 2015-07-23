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

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LXColor(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]

@interface LXIndexViewController () <LXSegmentControlDelegate>

@property (nonatomic, strong) LXSegmentControl *segment;
@property (nonatomic, strong) NSMutableArray *collectArray;

@end

@implementation LXIndexViewController

-(void)LXSegmentControl:(LXSegmentControl *)segment didSelectItemAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            break;
        }
            
        default:
            break;
    }
}

-(LXSegmentControl *)segment
{
    if (!_segment) {
        _segment = [[LXSegmentControl alloc] initWithFrame:CGRectMake(25, 20, [UIScreen mainScreen].bounds.size.width-50, 30)];
        
        _segment.delegate = self;
        _segment.buttons = @[@"搞笑", @"逗比", @"舞蹈", @"宝宝", @"涨姿势"];
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
