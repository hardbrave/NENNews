//
//  NENNewsGroupDropdownButton.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupDropdownButton.h"
#import "NENNewsConst.h"
#import "CommonDef.h"

@implementation NENNewsGroupDropdownButton

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"channel_nav_arrow"] forState:UIControlStateNormal];
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        self.backgroundColor = [UIColor whiteColor];
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [NENNotificationCenter addObserver:self selector:@selector(btnClick) name:kNENNewsGroupListItemDidSelectNotification object:nil];
    }
    return self;
}

#pragma mark - 系统方法
- (void)dealloc
{
    [NENNotificationCenter removeObserver:self];
}

#pragma mark - 实例化方法
+ (instancetype)button
{
    return [[self alloc] init];
}

#pragma mark - 监听方法
- (void)btnClick
{
    // 旋转箭头方向
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
    }];
    
    if (self.onClick) {
        self.onClick();
    }
}

@end
