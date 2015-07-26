//
//  LXMovieModel.h
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXUser;
@interface LXMovieModel : NSObject

@property (nonatomic, strong) NSString *recommend_caption;
@property (nonatomic, strong) NSString *cover_pic;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *likes_count;
@property (nonatomic, strong) NSString *comments_count;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) LXUser *user;

@end
