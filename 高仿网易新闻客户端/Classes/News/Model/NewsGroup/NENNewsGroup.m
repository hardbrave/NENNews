//
//  NENNewsGroup.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroup.h"

@implementation NENNewsGroup

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@>",
            [self class],
            self,
            @{@"title": _title,
              @"url": _url,
              @"type": @(_type)}
            ];
}

@end
