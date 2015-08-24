//
//  NENNewsDetail.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/18.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsDetail.h"
#import "NENNewsDetail.h"
#import "MJExtension.h"
#import "NENNewsDetailImg.h"

@implementation NENNewsDetail
+ (NSDictionary *)objectClassInArray
{
    return @{@"img" : [NENNewsDetailImg class]};
}
@end
