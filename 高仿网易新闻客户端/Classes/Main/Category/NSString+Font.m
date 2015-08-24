//
//  NSString+Font.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NSString+Font.h"

@implementation NSString (Font)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self sizeWithFont:font maxSize:maxSize];
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

@end
