//
//  LXUser.h
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXUser : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *be_liked_count;

@end
