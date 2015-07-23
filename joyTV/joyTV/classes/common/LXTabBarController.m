//
//  LXTabBarController.m
//  joyTV
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXTabBarController.h"
#import "LXNavigationController.h"

#import "LXOwnerViewController.h"
#import "LXIndexViewController.h"
#import "LXHotViewController.h"

#define LXColor(r, g, b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]
@interface LXTabBarController () <UITabBarControllerDelegate>


@property (nonatomic, strong) UITabBar *myTabBar;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LXHotViewController *hotVc = [[LXHotViewController alloc] init];
    [self addChildVc:hotVc title:@"精 选" image:nil selectedImage:nil];
    
    LXOwnerViewController *ownerVc = [[LXOwnerViewController alloc] init];
    [self addChildVc:ownerVc title:@"我 的" image:nil selectedImage:nil];
    
    LXIndexViewController *indexVc = [[LXIndexViewController alloc] init];
    [self addChildVc:indexVc title:@"首  页" image:nil selectedImage:nil];
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title;
    
    // 设置子控制器的图片
    if (image != nil) {
        childVc.tabBarItem.image = [UIImage imageNamed:image];
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    LXNavigationController *nav = [[LXNavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBarHidden = YES;
    // 添加为子控制器
    [self addChildViewController:nav];

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
