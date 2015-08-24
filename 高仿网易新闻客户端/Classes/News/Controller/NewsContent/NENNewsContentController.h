//
//  NENNewsContentController.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NENNewsGroup;
@class NENNewsViewController;

@interface NENNewsContentController : UITableViewController
@property (nonatomic, strong) NENNewsGroup *newsGroup;
@property (nonatomic, weak) NENNewsViewController *newsVC;
@end

