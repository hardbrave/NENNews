//
//  NENNewsGroupTool.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/15.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NENNewsGroup;

@interface NENNewsGroupTool : NSObject
+ (NSMutableArray *)newsGroups;
+ (void)saveNewsGroups:(NSMutableArray *)newsGroups;
@end
