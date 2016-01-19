//
//  LXDtViewController.h
//  joyTV
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LXUser;
@class LXMovieModel;
@interface LXDtViewController : UIViewController

//需要展示的model
@property (nonatomic, strong) LXMovieModel *model;

@end
