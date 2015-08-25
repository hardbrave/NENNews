//
//  NENNewsCommentMaskView.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/24.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsCommentMaskView.h"

@interface NENNewsCommentMaskView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation NENNewsCommentMaskView
#pragma mark - 实例化方法
+ (instancetype)maskView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NENNewsCommentMaskView" owner:nil options:nil] lastObject];
}

#pragma mark - 属性方法
- (void)setType:(NENNewsCommentLoadingType)type
{
    switch (type) {
        case NENNewsCommentLoadingTypeLoading:
        {
            self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];
            self.titleLabel.text = @"跟帖正在加载中";
            break;
        }
        case NENNewsCommentLoadingTypeFailed:
        {
            self.indicatorView.hidden = YES;
            self.titleLabel.text = @"跟帖加载失败";
            break;
        }
        default:
            break;
    }
}
@end
