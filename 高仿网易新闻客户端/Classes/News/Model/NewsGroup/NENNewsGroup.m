//
//  NENNewsGroup.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroup.h"

@implementation NENNewsGroup
#pragma mark - 属性方法
- (NSString *)url
{
    if (self.isHeadLine) {
        return [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/%@", self.tid];
    } else {
        return [NSString stringWithFormat:@"http://c.m.163.com//nc/article/list/%@", self.tid];
    }
}

- (NSString *)adUrl
{
    if (self.isHeadLine) {
        return @"http://c.m.163.com/nc/ad/headline";
    }
    return nil;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tid forKey:@"tid"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [encoder encodeObject:[NSNumber numberWithBool:self.headLine] forKey:@"headLine"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.tid = [decoder decodeObjectForKey:@"tid"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.type = [[decoder decodeObjectForKey:@"type"] integerValue];
        self.headLine = [[decoder decodeObjectForKey:@"headLine"] boolValue];
    }
    return self;
}

@end
