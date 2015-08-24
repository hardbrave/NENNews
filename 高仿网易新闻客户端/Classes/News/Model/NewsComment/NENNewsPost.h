//
//  NENNewsPost.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NENNewsPost : NSObject
// 来源（用户名+用户来源）
@property (nonatomic, copy) NSString *from;
// 用户名
@property (nonatomic, copy) NSString *name;
// 用户来源
@property (nonatomic, copy) NSString *source;
// 内容
@property (nonatomic, copy) NSString *body;
// 带属性的内容
@property (nonatomic, copy) NSAttributedString *attributeBody;
// 是否显示了全部内容
@property (nonatomic, assign, getter=isShowAll) BOOL showAll;
// 点赞数
@property (nonatomic, copy) NSString *vote;
// 时间
@property (nonatomic, copy) NSString *time;
// 用户头像
@property (nonatomic ,copy) NSString *timg;
// 用来拼凑详细评论url
@property (nonatomic, copy) NSString *pi;
// 引用的评论（存储NENNewsQuotePost对象）
@property (nonatomic, copy) NSArray *quotePosts;

+ (instancetype)newsPostWithListDict:(NSDictionary *)dict;
@end
