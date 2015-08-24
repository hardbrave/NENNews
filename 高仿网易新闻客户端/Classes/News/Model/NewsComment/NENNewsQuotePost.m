
//
//  NENNewsQuotePost.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsQuotePost.h"
#import "MJExtension.h"
#import "RegexKitLite.h"
#import "NSAttributedString+paragraph.h"

#define kNENQuotePostContentFont            [UIFont systemFontOfSize:15]
#define kNENQuotePostContentLineSpacing     5

@implementation NENNewsQuotePost
#pragma mark - MJExtension
+ (NSArray *)ignoredPropertyNames
{
    return @[@"floor", @"name", @"source", @"hidden"];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"from": @"f",
             @"time": @"t",
             @"body": @"b",
             @"vote": @"v"};
}

#pragma mark - 属性方法
- (void)setFrom:(NSString *)from
{
    _from = [from copy];
    
    NSString *regexPattern = @"^(.*) \\[(.*)\\] 的原贴：$";
    NSArray *array = [from arrayOfCaptureComponentsMatchedByRegex:regexPattern];
    if (array.count) {
        NSArray *captureArray = array[0];
        if (captureArray.count == 3) {
            self.name = [NSString stringWithFormat:@"%@[%@]", captureArray[2], captureArray[1]];
        }
    } else {
        NSString *regexPattern = @"^(.*)\\((.*)\\)的原贴：$";
        NSArray *array = [from arrayOfCaptureComponentsMatchedByRegex:regexPattern];
        if (array.count) {
            NSArray *captureArray = array[0];
            if (captureArray.count == 3) {
                self.name = [NSString stringWithFormat:@"%@[%@]", captureArray[2], captureArray[1]];
            }
        }
    }
}

- (void)setBody:(NSString *)body
{
    self.attributeBody = [NSAttributedString attributedStringWithString:body LineSpacing:kNENQuotePostContentLineSpacing font:kNENQuotePostContentFont];
}

@end
