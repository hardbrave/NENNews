//
//  NENNewsHotComment.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsHotComment.h"
#import "NENNewsPost.h"
#import "MJExtension.h"

@implementation NENNewsHotComment
+ (NSArray *)ignoredPropertyNames
{
    // 数组属性自己转换
    return @[@"hotPosts"];
}

+ (instancetype)hotCommentWithDict:(NSDictionary *)dict
{
    NENNewsHotComment *hotComment = [self objectWithKeyValues:dict];
    
    NSMutableArray *newsPostsM = [NSMutableArray array];
    NSArray *hotPosts = dict[@"hotPosts"];
    [hotPosts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        NENNewsPost *newPost = [NENNewsPost newsPostWithListDict:dict];
        [newsPostsM addObject:newPost];
    }];
    hotComment.hotPosts = newsPostsM;
    
    return hotComment;
}
@end
