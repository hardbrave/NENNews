//
//  NSAttributedString+paragraph.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/21.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (paragraph)
+ (instancetype)attributedStringWithString:(NSString *)string LineSpacing:(CGFloat)lineSpacing font:(UIFont *)font;
+ (instancetype)attributedStringWithString:(NSString *)string LineSpacing:(CGFloat)lineSpacing;

- (CGSize)sizeWithMaxSize:(CGSize)maxSize;
- (CGSize)sizeWithMaxW:(CGFloat)maxW;
@end
