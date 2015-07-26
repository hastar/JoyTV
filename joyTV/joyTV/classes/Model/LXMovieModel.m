//
//  LXMovieModel.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXUser.h"
#import "LXMovieModel.h"
#import <UIKit/UIKit.h>
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
    
    if ([key isEqualToString:@"comments_count"]) {
        self.comments_count = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"created_at"]) {
        NSNumber *number = (NSNumber *)value;
        self.created_at = [self convertTime:[number floatValue]];
    }
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@", value];
    }
}

- (NSString *)convertTime:(CGFloat )second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"MM-dd"];
    
    NSString *showtimeNew = [dateFomatter stringFromDate:d];
    return showtimeNew;
}




@end
