//
//  NSAttributedString+paragraph.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/21.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NSAttributedString+paragraph.h"

@implementation NSAttributedString (paragraph)
+ (instancetype)attributedStringWithString:(NSString *)string LineSpacing:(CGFloat)lineSpacing font:(UIFont *)font
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}

+ (instancetype)attributedStringWithString:(NSString *)string LineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}

#warning 此法太过tricky，后续寻求更好的方法替代
- (CGSize)sizeWithMaxSize:(CGSize)maxSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){{0, 0}, maxSize}];
    [label setNumberOfLines:0];
    label.attributedText = self;
    [label sizeToFit];
    return label.bounds.size;
}

- (CGSize)sizeWithMaxW:(CGFloat)maxW
{
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self sizeWithMaxSize:maxSize];
}

@end
