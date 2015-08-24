//
//  NENNewsQuotePostView.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NENNewsQuotePost;
@class NENNewsQuotePostsView;
@class NENNewsQuotePostFrame;

#define kNENQuotePostNameFont        [UIFont systemFontOfSize:13]
#define kNENQuotePostFloorFont       [UIFont systemFontOfSize:11]
#define kNENQuotePostContentFont     [UIFont systemFontOfSize:15]

// View之间的水平间距
#define kNENQuotePostPaddingH    3
// View之间的垂直间距
#define kNENQuotePostPaddingV    3
// 内部的垂直间距
#define kNENQuotePostMarginV     8
// 内部的垂直间距
#define kNENQuotePostMarginH     8

@interface NENNewsQuotePostView : UIView
@property (nonatomic, copy) void(^showAllFloorBlock)();
@property (nonatomic, copy) void(^showAllContentBlock)();
@property (nonatomic, strong) NENNewsQuotePostFrame *postFrame;
@end
