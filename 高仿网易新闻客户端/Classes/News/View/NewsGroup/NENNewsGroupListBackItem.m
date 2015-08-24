//
//  NENNewsGroupListBackItem.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/11.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupListBackItem.h"

@interface NENNewsGroupListBackItem ()
@property (nonatomic, strong) CAShapeLayer *borderLayer;
@end

@implementation NENNewsGroupListBackItem

#pragma mark - 懒加载方法
- (CAShapeLayer *)borderLayer
{
    if (!_borderLayer) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        [self.layer addSublayer:borderLayer];
        self.borderLayer = borderLayer;
    }
    return _borderLayer;
}

#pragma mark - 实例化方法
+ (instancetype)item
{
    return [[self alloc] init];
}

#pragma mark - 系统方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置虚线边框
    self.borderLayer.bounds = self.bounds;
    self.borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.borderLayer.bounds cornerRadius:6].CGPath;
    self.borderLayer.lineWidth = 1.0 / [[UIScreen mainScreen] scale];
    self.borderLayer.lineDashPattern = @[@2, @2];
    self.borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.borderLayer.strokeColor = [UIColor grayColor].CGColor;
}

@end
