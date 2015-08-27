//
//  LXDataBaseHandle.m
//  joyTV
//
//  Created by lanou on 15/7/28.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "FMDB.h"
#import "LXDataBaseHandle.h"

#import "LXMovieModel.h"

@implementation LXDataBaseHandle

+ (FMDatabase *)openDB
{
    static FMDatabase *myDB = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [dirPath stringByAppendingPathComponent:@"data.sqlite"];
        LXLog(@"sqlPath = %@", dirPath);
        NSLog(@"%@ ", dirPath);
        myDB = [FMDatabase databaseWithPath:filePath];
        
        [myDB open];
        NSString *createTableSql = @"create table if not exists collectTable(videoId text primary key,data BLOB);";
        NSString *createLocalSql = @"create table if not exists localTable(videoId text primary key,category text,data BLOB);";
        
        [myDB executeUpdate:createTableSql];
        [myDB executeUpdate:createLocalSql];
    });
    return myDB;
}

/************************************** 收 藏 ***********************************/
#pragma mark 收藏数据
+ (BOOL) collectWithMovieModel:(LXMovieModel *)model
{
    if ([self isCollectWithModel:model]) {
        return YES;
    }
    
    @try
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:model forKey:@"movieModel"];
        [archiver finishEncoding];
        
        BOOL result = [[self openDB] executeUpdate:@"insert into collectTable(videoId, data) values(?,?);", model.ID, data];
        if (!result)
        {
            LXLog(@"数据插入错误");
            
            return NO;
        }
        
    }
    @catch (NSException *exception) {
        LXLog(@"执行错误");
    }
    
    
    return YES;
}

/**
 *  删除收藏
 *
 *  @param model 需要删除的model
 *
 *  @return 返回删除结果
 */
#pragma mark 删除收藏
+ (BOOL) deleteWithMovieModel:(LXMovieModel *)model
{
    @try
    {
        
        BOOL result = [[self openDB] executeUpdate:@"delete from collectTable where videoId = ?;", model.ID];
        if (!result)
        {
            LXLog(@"数据删除错误");
            
            return NO;
        }
        
    }
    @catch (NSException *exception) {
        LXLog(@"执行错误");
    }

    return YES;
}

/**
 *  获取所有收藏的model
 *
 *  @return 返回所有model的数组
 */
#pragma mark 获取所有收藏的model
+ (NSArray *) arrayWithAllModel
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    FMResultSet *resultSet = [[self openDB] executeQuery:@"select videoId, data from collectTable;"];
    if (resultSet == nil) {
        return  nil;
    }
    
    while ([resultSet next]) {
        NSData *data = [resultSet dataForColumn:@"data"];
        
        @try {
            if (data == nil) {
                continue;
            }
            
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            LXMovieModel *model = [unArchiver decodeObjectForKey:@"movieModel"];
            [unArchiver finishDecoding];
            
            if (model != nil) {
                [array addObject:model];
            }
        }
        @catch (NSException *exception) {
            LXLog(@"读取收藏数据错误");
        }
        
    }
    
    
    return array;
}

/**
 *  返回当前model 是否已经被收藏
 *
 *  @param model 需要被判断的model
 *
 *  @return 返回判断结果,YES为已经收藏，NO为未被收藏
 */
#pragma mark 返回当前model 是否已经被收藏
+ (BOOL) isCollectWithModel:(LXMovieModel *)model
{
    
    FMResultSet *resultSet = [[self openDB] executeQuery:@"select * from collectTable where videoId = ?;", model.ID];
    if (resultSet == nil) {
        return  NO;
    }
    
    while ([resultSet next]) {
        return YES;
    }
    
    return NO;
}

/************************************** 本地化 ***********************************/
/**
 *  数据本地化
 *
 *  @param modelArray 要保存的数组
 *  @param category   所属类目
 */
#pragma mark 数据本地化
+ (void) localModeWithArray:(NSArray *)modelArray category:(NSString *)category
{
    if (category.length <= 0) return;
    
    if (modelArray.count <= 0) return;
    
    int i = 0;
    for (LXMovieModel *model in modelArray)
    {
        @try
        {
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:model forKey:@"movieModel"];
            [archiver finishEncoding];
            
            NSString *sql = [NSString stringWithFormat:@"insert into localTable(videoId,category,data) values('%@', '%@', '%@');", model.ID,category, data];
            BOOL result = [[self openDB] executeUpdate:sql];
            if (!result)
            {
                LXLog(@"数据插入错误");
                
                return ;
            }
            
            i++;
        }
        @catch (NSException *exception) {
            LXLog(@"执行错误");
        }
        
        if (i >= 50) {
            break;
        }
    }
}

/**
 *  获取对应类目的本地化数据
 *
 *  @param category 需要获取的类目名称
 *
 *  @return 类目对应的本地化数据
 */
#pragma mark 获取本地化数据
+ (NSArray *)arrayLocalModelWithCategory:(NSString *)category
{
    NSLog(@"%@", category);
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    FMResultSet *resultSet = [[self openDB] executeQuery:@"select videoId, data from localTable where category = ?;", category];
    if (resultSet == nil) {
        return  nil;
    }
    
    while ([resultSet next]) {
        NSData *data = [resultSet dataForColumn:@"data"];
        
        @try
        {
            if (data == nil)
            {
                continue;
            }
            
            NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            LXMovieModel *model = [unArchiver decodeObjectForKey:@"movieModel"];
            [unArchiver finishDecoding];
            
            if (model != nil)
            {
                [modelArray addObject:model];
            }
            
        }
        @catch (NSException *exception) {
            LXLog(@"读取收藏数据错误");
        }
        
    }
    
    return [modelArray copy];
    
}

/**
 *  清除所有本地化数据
 */
#pragma mark 清除所有本地化数据
+ (void) clearAllLocalModel
{
    @try
    {
        BOOL result = [[self openDB] executeUpdate:@"delete from localTable;"];
        if (!result)
        {
            LXLog(@"数据删除错误");
            
            return ;
        }
        
    }
    @catch (NSException *exception)
    {
        LXLog(@"执行错误");
    }

}

@end
