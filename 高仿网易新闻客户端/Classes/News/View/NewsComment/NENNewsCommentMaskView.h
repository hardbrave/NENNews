//
//  NENNewsCommentMaskView.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/24.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NENNewsCommentLoadingType) {
    NENNewsCommentLoadingTypeLoading,
    NENNewsCommentLoadingTypeFailed,
};

@interface NENNewsCommentMaskView : UIView
+ (instancetype)maskView;
@property (nonatomic, assign)NENNewsCommentLoadingType type;
@end
