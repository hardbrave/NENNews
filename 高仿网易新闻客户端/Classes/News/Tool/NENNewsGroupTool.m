//
//  NENNewsGroupTool.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/15.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupTool.h"
#import "NENNewsGroup.h"
#import "MJExtension.h"

@implementation NENNewsGroupTool

+ (NSMutableArray *)newsGroups
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsGroup.plist" ofType:nil];
    NSMutableArray *newsGroups = [NENNewsGroup objectArrayWithFile:path];
    return newsGroups;
}

+ (void)saveNewsGroups:(NSMutableArray *)newsGroups
{
    // 将新闻分组模型数组异步写入沙盒
    dispatch_queue_t queue = dispatch_queue_create("com.NewsGroup", nil);
    dispatch_async(queue, ^{
        NSArray *newsGroupDicts = [NENNewsGroup keyValuesArrayWithObjectArray:newsGroups];
        [newsGroupDicts writeToFile:@"/Users/qianli/Desktop/NewsGroup.plist" atomically:YES];
        NSLog(@"%@", [NSThread currentThread]);
    });
}
@end
