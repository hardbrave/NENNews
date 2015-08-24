//
//  NENPhotoSet.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/18.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENPhotoSet.h"
#import "NENPhotoDetail.h"
#import "MJExtension.h"

@implementation NENPhotoSet
+ (NSDictionary *)objectClassInArray
{
    return @{ @"photos" : [NENPhotoDetail class]};
}
@end
