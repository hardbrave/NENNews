//
//  NENNewsContentTool.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/25.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsContentTool.h"
#import "FMDB.h"

@implementation NENNewsContentTool
static FMDatabase *_db;
#pragma mark - 系统方法
+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"newsContents.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_news_contents (id integer PRIMARY KEY, content blob NOT NULL, tid text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_news_ads (id integer PRIMARY KEY, ad blob NOT NULL);"];
}

#pragma mark - 公开方法
+ (NSMutableArray *)newsContentsWithTid:(NSString *)tid
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_news_contents WHERE tid = ?", tid];
    NSMutableArray *newsContents = [NSMutableArray array];
    while (set.next) {
        NSData *newsContentData = [set objectForColumnName:@"content"];
        NSDictionary *newsContent = [NSKeyedUnarchiver unarchiveObjectWithData:newsContentData];
        [newsContents addObject:newsContent];
    }
    return newsContents;
}

+ (void)resetNewsContents:(NSArray *)newsContents tid:(NSString *)tid
{
    [_db beginTransaction];
    [_db executeUpdate:@"DELETE FROM t_news_contents WHERE tid = ?", tid];
    [newsContents enumerateObjectsUsingBlock:^(NSDictionary *newsContent, NSUInteger idx, BOOL *stop) {
        NSData *newsContentData = [NSKeyedArchiver archivedDataWithRootObject:newsContent];
        [_db executeUpdate:@"INSERT INTO t_news_contents(content, tid) VALUES (?, ?)", newsContentData, tid];
    }];
    [_db commit];
}

+ (void)saveNewsContents:(NSArray *)newsContents tid:(NSString *)tid number:(NSUInteger)num
{
    [_db beginTransaction];
    [newsContents enumerateObjectsUsingBlock:^(NSDictionary *newsContent, NSUInteger idx, BOOL *stop) {
        if (idx < num) {
            NSData *newsContentData = [NSKeyedArchiver archivedDataWithRootObject:newsContent];
            [_db executeUpdate:@"INSERT INTO t_news_contents(content, tid) VALUES (?, ?)", newsContentData, tid];
        } else {
            *stop = YES;
        }
        
    }];
    [_db commit];
}

+ (NSMutableArray *)newsADs
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_news_ads"];
    NSMutableArray *newsADs = [NSMutableArray array];
    while (set.next) {
        NSData *newsADData = [set objectForColumnName:@"ad"];
        NSDictionary *newsAD = [NSKeyedUnarchiver unarchiveObjectWithData:newsADData];
        [newsADs addObject:newsAD];
    }
    return newsADs;

}

+ (void)resetNewsADs:(NSMutableArray *)newsADs
{
    [_db beginTransaction];
    [_db executeUpdate:@"DELETE FROM t_news_ads"];
    [newsADs enumerateObjectsUsingBlock:^(NSDictionary *newsAD, NSUInteger idx, BOOL *stop) {
        NSData *newsADData = [NSKeyedArchiver archivedDataWithRootObject:newsAD];
        [_db executeUpdate:@"INSERT INTO t_news_ads(ad) VALUES (?)", newsADData];
    }];
    [_db commit];
}

+ (void)saveNewsADs:(NSMutableArray *)newsADs
{
    [_db beginTransaction];
    [newsADs enumerateObjectsUsingBlock:^(NSDictionary *newsAD, NSUInteger idx, BOOL *stop) {
        NSData *newsADData = [NSKeyedArchiver archivedDataWithRootObject:newsAD];
        [_db executeUpdate:@"INSERT INTO t_news_ads(ad) VALUES (?)", newsADData];
    }];
    [_db commit];
}
@end
