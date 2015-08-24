//
//  NENNewsGroupTitleLabel.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupTitleLabel.h"

@implementation NENNewsGroupTitleLabel

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.font = KNENNewsTitleFont;
        self.textAlignment = NSTextAlignmentCenter;
        self.scale = 0.0;
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 实例化方法
+ (instancetype)titleLabel
{
    return [[self alloc] init];
}

#pragma mark - 属性方法
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    CGFloat minScale = 0.7;
    [self setTextColor:[UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1.0]];
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.text = title;
}

#pragma mark - 监听方法
- (void)titleClick
{
    if (self.onClick) {
        self.onClick();
    }
}

@end
