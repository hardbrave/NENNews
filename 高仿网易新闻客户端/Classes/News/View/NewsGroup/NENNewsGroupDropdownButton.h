//
//  NENNewsGroupDropdownButton.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组栏右侧下拉按钮

#import <UIKit/UIKit.h>

@interface NENNewsGroupDropdownButton : UIButton
+ (instancetype)button;

@property (nonatomic, strong) void(^onClick)();
@end
