//
//  NENNewsNormalComment.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsNormalComment.h"
#import "NENNewsPost.h"
#import "MJExtension.h"

@implementation NENNewsNormalComment
#pragma mark - MJExtension
+ (NSArray *)ignoredPropertyNames
{
    // 数组属性自己转换
    return @[@"newsPosts"];
}

#pragma mark - 实例化方法
+ (instancetype)normalCommentWithDict:(NSDictionary *)dict
{
    NENNewsNormalComment *normalComment = [self objectWithKeyValues:dict];
    
    NSMutableArray *newsPostsM = [NSMutableArray array];
    NSArray *newPosts = dict[@"newPosts"];
    [newPosts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        NENNewsPost *newPost = [NENNewsPost newsPostWithListDict:dict];
        [newsPostsM addObject:newPost];
    }];
    normalComment.newsPosts = newsPostsM;
    
    return normalComment;
}

@end
