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

+ (LXDataBaseHandle *)shareInstance;

/************************************** 收 藏 ***********************************/
/**
 *  收藏数据
 *
 *  @param model 需要收藏的model
 *
 *  @return 返回收藏结果
 */
- (BOOL) collectWithMovieModel:(LXMovieModel *)model;

/**
 *  删除收藏
 *
 *  @param model 需要删除的model
 *
 *  @return 返回删除结果
 */
- (BOOL) deleteWithMovieModel:(LXMovieModel *)model;

/**
 *  返回当前model 是否已经被收藏
 *
 *  @param model 需要被判断的model
 *
 *  @return 返回判断结果,YES为已经收藏，NO为未被收藏
 */
- (BOOL) isCollectWithModel:(LXMovieModel *)model;

/**
 *  获取所有收藏的model
 *
 *  @return 返回所有model的数组
 */
- (NSArray *) arrayWithAllModel;

- (void) testData:(NSArray *)modeArray andCategory:(NSString *)category;

/************************************** 本地化 ***********************************/
/**
 *  数据本地化
 *
 *  @param modelArray 要保存的数组
 *  @param category   所属类目
 */
- (void) localModeWithArray:(NSArray *)modelArray andCategory:(NSString *)category;
- (void) saveModeWithArray:(NSArray *)modelArray andCategory:(NSString *)category;
/**
 *  获取对应类目的本地化数据
 *
 *  @param category 需要获取的类目名称
 *
 *  @return 类目对应的本地化数据
 */

- (NSArray *)arrayLocalModelWithCategory:(NSString *)category;

/**
 *  清除所有本地化数据
 */
- (void) clearAllLocalModel;

@end
