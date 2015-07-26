//
//  LXUser.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXUser.h"

@implementation LXUser

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
