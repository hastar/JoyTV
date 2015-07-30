//
//  LXUser.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXUser.h"

@implementation LXUser


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.be_liked_count = [aDecoder decodeObjectForKey:@"be_liked_count"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.screen_name forKey:@"screen_name"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.be_liked_count forKey:@"be_liked_count"];
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"be_liked_count"]) {
        self.be_liked_count = [NSString stringWithFormat:@"%@", value];
    }
    
    
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@", value];
    }
}

@end
