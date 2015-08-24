//
//  NENNewsCommentController.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/17.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NENNewsViewController;
@class NENNewsContent;

@interface NENNewsCommentController : UIViewController
@property (nonatomic, copy) NSString *normalUrl;
@property (nonatomic, copy) NSString *hotUrl;
#warning 此处newsContent仅仅用来获取boardid，且与photoset不兼容，得想办法去掉！！
@property (nonatomic, strong) NENNewsContent *newsContent;
@property (nonatomic, weak) NENNewsViewController *newsVC;
@end
