//
//  NENNewsPhotosetController.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/17.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NENNewsViewController;
@class NENNewsContent;

@interface NENNewsPhotosetController : UIViewController
@property (nonatomic, copy) NSString *url;
@property (nonatomic, weak) NENNewsViewController *newsVC;
@end
