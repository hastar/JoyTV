//
//  LXAboutViewController.m
//  joyTV
//
//  Created by lanou on 15/7/28.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXAboutViewController.h"

@interface LXAboutViewController ()

@end

@implementation LXAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headerImage.layer.cornerRadius = self.headerImage.bounds.size.width/8;
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.clipsToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
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
