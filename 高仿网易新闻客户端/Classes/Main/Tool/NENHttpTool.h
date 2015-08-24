//
//  NENHttpTool.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/14.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  HTTP请求工具类

#import <Foundation/Foundation.h>

@interface NENHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;
@end
