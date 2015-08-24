//
//  NENContentHeader.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NENNewsContentController.h"

@class NENContentHeader;

@protocol NENContentHeaderDelegate <NSObject>
@optional
- (void)contentHeader:(NENContentHeader *)contentHeader didClick:(NSUInteger)index;
@end

@interface NENContentHeader : UIView
+ (instancetype)header;

@property (nonatomic, copy) NSArray *newsADs;
@property (nonatomic, weak) id<NENContentHeaderDelegate> delegate;
@end
