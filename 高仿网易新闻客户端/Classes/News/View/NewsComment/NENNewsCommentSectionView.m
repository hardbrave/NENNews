//
//  NENNewsCommentSectionView.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/18.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsCommentSectionView.h"
#import "NSString+Font.h"
#import "UIView+Frame.h"

@interface NENNewsCommentSectionView ()
@property (nonatomic, strong) UIButton *button;
@end

#define kNENNewsNormalCommentFont   [UIFont systemFontOfSize:12]

@implementation NENNewsCommentSectionView
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"night_contentview_commentbacky"] forState:UIControlStateNormal];
        button.titleLabel.font = kNENNewsNormalCommentFont;
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:button];
        self.button = button;
    }
    return self;
}

#pragma mark - 属性方法
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self.button setTitle:title forState:UIControlStateNormal];
    CGSize titleSize = [title sizeWithFont:kNENNewsNormalCommentFont];
    self.button.width = titleSize.width + 30;
    self.button.height = self.button.currentBackgroundImage.size.height;
}
@end
