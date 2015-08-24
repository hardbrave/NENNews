//
//  NENNewsHotComment.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NENNewsHotComment : NSObject
@property (nonatomic, copy) NSString *audioLock;
@property (nonatomic, copy) NSArray *hotPosts;
@property (nonatomic, copy) NSString *docUrl;
@property (nonatomic, copy) NSString *isTagOff;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *againstLock;
+ (instancetype)hotCommentWithDict:(NSDictionary *)dict;
@end
