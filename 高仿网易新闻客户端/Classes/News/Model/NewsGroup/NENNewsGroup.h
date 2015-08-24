//
//  NENNewsGroup.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组模型

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NENNewsGroupType) {
    NENNewsGroupTypeTop,
    NENNewsGroupTypeBottom,
};

@interface NENNewsGroup : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *adUrl;
@property (nonatomic, assign) NENNewsGroupType type;
@end
