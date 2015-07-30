//
//  AppDelegate.m
//  joyTV
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "AppDelegate.h"
#import "LXTabBarController.h"

#import "MobClick.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "AFNetworking.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LXColor(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LXTabBarController *myTabBar = [[LXTabBarController alloc] init];
    self.window.rootViewController = myTabBar;
    
    //更改TabBar的高度
    ;
    myTabBar.tabBar.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
    for (UIView *transitionView in myTabBar.view.subviews) {
        CGRect frame = transitionView.frame;
        frame.size.height = kScreenHeight - 40;
        transitionView.frame = frame;
    }
    
    //更改tabbar字体样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    selectTextAttrs[NSForegroundColorAttributeName] = LXColor(253.0/255, 189.0/255, 10.0/255, 1.0);
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -15.0)];
    
    [self.window makeKeyAndVisible];
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [MobClick setEncryptEnabled:YES];
    [MobClick startWithAppkey:@"55b6157ee0f55a8006000d14" reportPolicy:BATCH   channelId:nil];
    [UMSocialData setAppKey:@"55b6157ee0f55a8006000d14"];
    
    
    [NSThread sleepForTimeInterval:1.0];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
