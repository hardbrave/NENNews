//
//  NENNavigationController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNavigationController.h"

@implementation NENNavigationController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor redColor]];
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttributes];
}

@end
