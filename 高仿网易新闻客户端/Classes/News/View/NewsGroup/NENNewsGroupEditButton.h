//
//  NENNewsGroupEditButton.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组编辑栏右侧编辑按钮

#import <UIKit/UIKit.h>

@interface NENNewsGroupEditButton : UIButton
+ (instancetype)button;
+ (instancetype)buttonWithTitle:(NSString *)title;

@property (nonatomic, copy) NSString *title;
@end
