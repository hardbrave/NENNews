//
//  NENNewsGroupEditButton.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupEditButton.h"

@implementation NENNewsGroupEditButton

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    return self;
}

#pragma mark - 实例化方法
+ (instancetype)button
{
    return [self buttonWithTitle:nil];
}

+ (instancetype)buttonWithTitle:(NSString *)title
{
    NENNewsGroupEditButton *btn = [[self alloc] init];
    btn.title = title;
    return btn;
}

#pragma mark - 属性方法
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    
}

#pragma mark - 系统方法
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor redColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
