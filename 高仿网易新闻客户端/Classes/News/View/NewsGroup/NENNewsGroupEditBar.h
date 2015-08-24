//
//  NENNewsGroupEditBar.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组编辑栏

#import <UIKit/UIKit.h>

@interface NENNewsGroupEditBar : UIView

+ (instancetype)bar;

@property (nonatomic, assign, getter=isEditing) BOOL editing;

@end
