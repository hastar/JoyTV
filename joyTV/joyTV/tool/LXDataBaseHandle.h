//
//  LXDataBaseHandle.h
//  joyTV
//
//  Created by lanou on 15/7/28.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXMovieModel;
@interface LXDataBaseHandle : NSObject

/**
 *  收藏数据
 *
 *  @param model 需要收藏的model
 *
 *  @return 返回收藏结果
 */
+ (BOOL) collectWithMovieModel:(LXMovieModel *)model;

/**
 *  删除收藏
 *
 *  @param model 需要删除的model
 *
 *  @return 返回删除结果
 */
+ (BOOL) deleteWithMovieModel:(LXMovieModel *)model;

/**
 *  获取所有收藏的model
 *
 *  @return 返回所有model的数组
 */
+ (NSArray *) arrayWithAllModel;

/**
 *  返回当前model 是否已经被收藏
 *
 *  @param model 需要被判断的model
 *
 *  @return 返回判断结果,YES为已经收藏，NO为未被收藏
 */
+ (BOOL) isCollectWithModel:(LXMovieModel *)model;



@end
