//
//  NENNewsPostFrame.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NENNewsPost;

#define kNENPostNameFont        [UIFont systemFontOfSize:13]
#define kNENPostVoteCountFont   [UIFont systemFontOfSize:11]
#define kNENPostSourceFont      [UIFont systemFontOfSize:11]
#define kNENPostTimeFont        [UIFont systemFontOfSize:11]

#define kNENPostIconWH      30
#define kNENPostContentMaxH 120

// 距离外边框的水平间距
#define kNENPostPaddingH    8
// 距离外边框的垂直间距
#define kNENPostPaddingV    10
// 内部的水平间距
#define kNENPostMarginH     8
// 内部的垂直间距
#define kNENPostMarginV     8

@interface NENNewsPostFrame : NSObject
@property (nonatomic, strong) NENNewsPost *post;

@property (nonatomic, assign) CGRect iconViewF;
@property (nonatomic, assign) CGRect nameLabelF;
@property (nonatomic, assign) CGRect voteCountLabelF;
@property (nonatomic, assign) CGRect voteViewF;
@property (nonatomic, assign) CGRect sourceLabelF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect contentLabelF;
@property (nonatomic, assign) CGRect showAllBtnF;
@property (nonatomic, assign) CGRect quotePostsViewF;

@property (nonatomic, assign) CGFloat cellH;
@end
