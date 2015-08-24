//
//  NENNewsGroupTitleLabel.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组栏标签

#import <UIKit/UIKit.h>

@class NENNewsGroup;

#define KNENNewsTitleFont   [UIFont systemFontOfSize:19]

@interface NENNewsGroupTitleLabel : UILabel
+ (instancetype)titleLabel;

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^onClick)();
@end
