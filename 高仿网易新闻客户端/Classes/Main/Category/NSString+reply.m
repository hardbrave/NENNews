//
//  NSString+reply.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/21.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NSString+reply.h"

@implementation NSString (reply)
+ (instancetype)replyString:(CGFloat)replyCount
{
    NSString *replyStr = nil;
    if (replyCount > 10000) {
        replyStr = [NSString stringWithFormat:@"%.1f万跟帖", replyCount/10000];
    } else if (replyCount > 0) {
        replyStr = [NSString stringWithFormat:@"%.0f跟帖", replyCount];
    }
    return replyStr;
}
@end
