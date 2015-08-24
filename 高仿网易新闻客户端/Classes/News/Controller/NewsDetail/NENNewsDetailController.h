//
//  NENNewsDetailController.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/17.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻详情页

#import <UIKit/UIKit.h>

@class NENNewsViewController;
@class NENNewsContent;

@interface NENNewsDetailController : UIViewController
@property (nonatomic, strong) NENNewsContent *newsContent;
@property (nonatomic, weak) NENNewsViewController *newsVC;
@end
