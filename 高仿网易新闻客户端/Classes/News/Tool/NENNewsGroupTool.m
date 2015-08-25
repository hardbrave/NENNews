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

#define kNENNewsGroupPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"newsGroups.data"]

+ (NSMutableArray *)newsGroups
{
    // 先从沙盒中读取，如果没有，再从NSBundle中读
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:kNENNewsGroupPath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NewsGroup.plist" ofType:nil];
        NSMutableArray *newsGroups = [NENNewsGroup objectArrayWithFile:path];
        return newsGroups;
    } else {
        NSMutableArray *newsGroups = [NSKeyedUnarchiver unarchiveObjectWithFile:kNENNewsGroupPath];
        return newsGroups;
    }
}

+ (void)saveNewsGroups:(NSMutableArray *)newsGroups
{
    // 将新闻分组模型数组异步写入沙盒
    dispatch_queue_t queue = dispatch_queue_create("com.NewsGroup", nil);
    dispatch_async(queue, ^{
        [NSKeyedArchiver archiveRootObject:newsGroups toFile:kNENNewsGroupPath];
        NSLog(@"%@", [NSThread currentThread]);
    });
}
@end
