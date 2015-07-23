//
//  LXMovieModel.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXUser.h"
#import "LXMovieModel.h"

@implementation LXMovieModel

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"time"]) {
        self.time = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"likes_count"]) {
        self.likes_count = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"user"]) {
        self.user = [[LXUser alloc] init];
        [self.user setValuesForKeysWithDictionary:value];
    }
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@", value];
    }
    
    
}
@end
