//
//  NENNewsContentTool.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/25.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NENNewsContentTool : NSObject
+ (NSMutableArray *)newsContentsWithTid:(NSString *)tid;
+ (void)resetNewsContents:(NSArray *)newsContents tid:(NSString *)tid;
+ (void)saveNewsContents:(NSArray *)newsContents tid:(NSString *)tid number:(NSUInteger)num;

+ (NSMutableArray *)newsADs;
+ (void)resetNewsADs:(NSMutableArray *)newsADs;
+ (void)saveNewsADs:(NSMutableArray *)newsADs;
@end
