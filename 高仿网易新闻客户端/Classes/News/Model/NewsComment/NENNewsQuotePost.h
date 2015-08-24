//
//  NENNewsQuotePost.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NENNewsQuotePost : NSObject
// 评论所处楼层
@property (nonatomic, copy) NSString *floor;
// 来源（用户名+用户来源）
@property (nonatomic, copy) NSString *from;
// 格式：用户名[用户来源]
@property (nonatomic, copy) NSString *name;
// 内容
@property (nonatomic, copy) NSString *body;
// 带属性的内容
@property (nonatomic, copy) NSAttributedString *attributeBody;
// 点赞数
@property (nonatomic, copy) NSString *vote;
// 时间
@property (nonatomic, copy) NSString *time;
// 是否为隐藏内容
@property (nonatomic, assign, getter=isHidden) BOOL hidden;
@end
