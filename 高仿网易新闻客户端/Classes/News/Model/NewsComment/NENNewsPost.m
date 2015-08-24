//
//  NENNewsPost.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsPost.h"
#import "MJExtension.h"
#import "RegexKitLite.h"
#import "NSDate+time.h"
#import "NENNewsQuotePost.h"
#import "NSAttributedString+paragraph.h"

#define kNENPostContentFont         [UIFont systemFontOfSize:15]
#define kNENPostContentLineSpacing  5

@implementation NENNewsPost
#pragma mark - MJExtension
+ (NSArray *)ignoredPropertyNames
{
    return @[@"quotePosts", @"name", @"source"];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"from": @"f",
             @"time": @"t",
             @"body": @"b",
             @"vote": @"v"};
}

#pragma mark - 实例化方法
+ (instancetype)newsPostWithListDict:(NSDictionary *)dict
{
    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dict.keyEnumerator allObjects]];
    // 判断是否有隐藏楼层
    __block BOOL hasHiddenFloor = NO;
    [allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([key isEqualToString:@"NON"]) {
            [allKeys removeObject:key];
            hasHiddenFloor = YES;
            *stop = YES;
        }
    }];
    
    // 对key（楼层号）进行排序，小的楼层在前，大的楼层在后
    [allKeys sortUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        int k1 = [key1 intValue];
        int k2 = [key2 intValue];
        if (k1 < k2) {
            return NSOrderedAscending;
        } else if (k1 == k2) {
            return NSOrderedSame;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    __block NENNewsPost *newsPost = nil;
    __block NSMutableArray *quotePostsM = [NSMutableArray array];
    [allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (idx != allKeys.count-1) {
            NENNewsQuotePost *quotePost = [NENNewsQuotePost objectWithKeyValues:dict[key]];
            quotePost.floor = key;
            NSInteger floor = [quotePost.floor integerValue];
            // 插入隐藏内容
            if (hasHiddenFloor && idx != floor - 1) {
                NENNewsQuotePost *hiddenQuotePost = [[NENNewsQuotePost alloc] init];
                hiddenQuotePost.hidden = YES;
                [quotePostsM addObject:hiddenQuotePost];
                // 保证只插入一次
                hasHiddenFloor = NO;
            }
            [quotePostsM addObject:quotePost];
        } else {
            newsPost = [NENNewsPost objectWithKeyValues:dict[key]];
        }
    }];
    
    newsPost.quotePosts = quotePostsM;
    return newsPost;
}

#pragma mark - 属性方法
- (void)setFrom:(NSString *)from
{
    _from = [from copy];
    
    /** 将from字段进行正则解析，得到用户名和来源 */
    NSString *regexPattern = @"^(.*)&nbsp;(.*)： $";
    NSArray *array = [from arrayOfCaptureComponentsMatchedByRegex:regexPattern];
    if (array.count) {
        NSArray *captureArray = array[0];
        if (captureArray.count == 3) {
            self.source = captureArray[1];
            self.name = captureArray[2];
        }
    } else {
        regexPattern = @"^(.*)：$";
        array = [from arrayOfCaptureComponentsMatchedByRegex:regexPattern];
        if (array.count) {
            NSArray *captureArray = array[0];
            if (captureArray.count == 2) {
                self.source = captureArray[1];
                self.name = @"火星网友";
            }
        }
    }
}

- (NSString *)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:_time];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    if ([date isThisYear]) {
        if ([date isToday]) {
            if (cmps.hour > 0) {
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            } else {
                return @"刚刚";
            }
        } else if ([date isYesterday]) {
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:date];
        } else {
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:date];
        }
    } else {
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }
}

- (void)setBody:(NSString *)body
{
    self.attributeBody = [NSAttributedString attributedStringWithString:body LineSpacing:kNENPostContentLineSpacing font:kNENPostContentFont];
}

@end
