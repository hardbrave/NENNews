//
//  NENNewsNormalComment.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NENNewsNormalComment : NSObject
@property (nonatomic, assign) NSUInteger tcountt;
@property (nonatomic, assign) NSUInteger prcount;
@property (nonatomic, assign) NSUInteger againstcount;
@property (nonatomic, assign) NSUInteger votecount;
@property (nonatomic, strong) NSArray *newsPosts;
@property (nonatomic, copy) NSString *docUrl;
@property (nonatomic, copy) NSString *isTagOff;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSUInteger ptcount;
@property (nonatomic, assign) NSUInteger tcountr;
@property (nonatomic, copy) NSString *againstLock;
+ (instancetype)normalCommentWithDict:(NSDictionary *)dict;
@end
