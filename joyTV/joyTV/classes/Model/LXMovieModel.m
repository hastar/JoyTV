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



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.ID = [coder decodeObjectForKey:@"ID"];
        self.recommend_caption = [coder decodeObjectForKey:@"recommend_caption"];
        self.cover_pic = [coder decodeObjectForKey:@"cover_pic"];
        self.caption = [coder decodeObjectForKey:@"caption"];
        self.time = [coder decodeObjectForKey:@"time"];
        self.video = [coder decodeObjectForKey:@"video"];
        self.url = [coder decodeObjectForKey:@"url"];
        self.likes_count = [coder decodeObjectForKey:@"likes_count"];
        self.comments_count = [coder decodeObjectForKey:@"comments_count"];
        self.created_at = [coder decodeObjectForKey:@"created_at"];
        self.user = [coder decodeObjectForKey:@"user"];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.recommend_caption forKey:@"recommend_caption"];
    [aCoder encodeObject:self.cover_pic forKey:@"cover_pic"];
    [aCoder encodeObject:self.caption forKey:@"caption"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.video forKey:@"video"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.likes_count forKey:@"likes_count"];
    [aCoder encodeObject:self.comments_count forKey:@"comments_count"];
    [aCoder encodeObject:self.created_at forKey:@"created_at"];
    [aCoder encodeObject:self.user forKey:@"user"];
}





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
