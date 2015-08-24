//
//  NENNewsQuotePostFrame.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NENNewsQuotePost;

@interface NENNewsQuotePostFrame : NSObject

#define kNENQuotePostNameFont        [UIFont systemFontOfSize:13]
#define kNENQuotePostFloorFont       [UIFont systemFontOfSize:11]

// View之间的水平间距
#define kNENQuotePostPaddingH    3
// View之间的垂直间距
#define kNENQuotePostPaddingV    3
// 内部的垂直间距
#define kNENQuotePostMarginV     8
// 内部的垂直间距
#define kNENQuotePostMarginH     8
// 展开按钮的高度
#define kNENQuotePostShowBtnH    35

@property (nonatomic, strong) NENNewsQuotePost *post;

@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect floorLabelF;
@property (nonatomic, assign) CGRect contentLabelF;
@property (nonatomic, assign) CGRect expandBtnF;
@property (nonatomic, assign) CGRect showAllBtnF;
@property (nonatomic, assign) CGRect PostViewF;
@end
