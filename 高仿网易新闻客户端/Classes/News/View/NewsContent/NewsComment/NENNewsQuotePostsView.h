//
//  NENNewsQuotePostsView.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NENNewsQuotePostsView : UIView
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, copy) void(^showAllFloorBlock)();
+ (CGFloat)heightWithPosts:(NSArray *)posts width:(CGFloat)width;
@end
