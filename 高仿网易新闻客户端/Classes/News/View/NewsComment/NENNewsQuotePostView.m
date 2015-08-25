//
//  NENNewsQuotePostView.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsQuotePostView.h"
#import "NENNewsQuotePost.h"
#import "NENNewsQuotePostsView.h"
#import "UIView+Frame.h"
#import "NSString+Font.h"
#import "NENNewsQuotePostFrame.h"
#import "CommonDef.h"

@interface NENNewsQuotePostView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *showAllBtn;
@property (nonatomic, strong) UIButton *expandBtn;
@end

@implementation NENNewsQuotePostView
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景
        self.backgroundColor = NENColor(250, 250, 250);
        self.layer.borderWidth = 1;
        self.layer.borderColor = NENColor(197, 196, 196).CGColor;
        
        // 名字
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = kNENQuotePostNameFont;
        nameLabel.textColor = [UIColor blueColor];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 楼层数
        UILabel *floorLabel = [[UILabel alloc] init];
        floorLabel.font = kNENQuotePostFloorFont;
        floorLabel.textColor = [UIColor grayColor];
        floorLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:floorLabel];
        self.floorLabel = floorLabel;
        
        // 内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = kNENQuotePostContentFont;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 显示全部内容按钮
        UIButton *showAllBtn = [[UIButton alloc] init];
        [showAllBtn setImage:[UIImage imageNamed:@"comment_showall"] forState:UIControlStateNormal];
        [showAllBtn addTarget:self action:@selector(showAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showAllBtn];
        self.showAllBtn = showAllBtn;
        
        // 展开按钮
        UIButton *expandBtn = [[UIButton alloc] init];
        NSString *btnTitle = @"展开隐藏楼层";
        UIFont *btnFont = [UIFont systemFontOfSize:15];
        expandBtn.titleLabel.font = btnFont;
        [expandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [expandBtn setImage:[UIImage imageNamed:@"comment_arrow_down"] forState:UIControlStateNormal];
        [expandBtn setTitle:btnTitle forState:UIControlStateNormal];
        [expandBtn addTarget:self action:@selector(expandBtnClick) forControlEvents:UIControlEventTouchUpInside];
        CGFloat labelWidth = [btnTitle sizeWithFont:btnFont].width;
        CGFloat imageWidth = 12;
        expandBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        expandBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        [self addSubview:expandBtn];
        self.expandBtn = expandBtn;
    }
    return self;
}

#pragma mark - 监听方法
- (void)expandBtnClick
{
    if (self.showAllFloorBlock) {
        self.showAllFloorBlock();
    }
}

- (void)showAllBtnClick
{
    // 重算一遍frame
    NENNewsQuotePost *post = self.postFrame.post;
    post.showAll = YES;
    self.postFrame.post = post;
    
    if (self.showAllContentBlock) {
        self.showAllContentBlock();
    }
}

#pragma mark - 属性方法
- (void)setPostFrame:(NENNewsQuotePostFrame *)postFrame
{
    _postFrame = postFrame;
    
    NENNewsQuotePost *post = postFrame.post;
    
    if (post.isHidden) {
        // 名字
        self.nameLabel.hidden = YES;
        
        // 楼层数
        self.floorLabel.hidden = YES;
        
        // 内容
        self.contentLabel.hidden = YES;
        
        // 显示全部按钮
        self.showAllBtn.hidden = YES;
        
        // 展开按钮
        self.expandBtn.hidden = NO;
        self.expandBtn.frame = postFrame.expandBtnF;

    } else {
        // 名字
        self.nameLabel.hidden = NO;
        self.nameLabel.text = post.name;
        self.nameLabel.frame = postFrame.nameLabelF;
        
        // 楼层数
        self.floorLabel.hidden = NO;
        self.floorLabel.text = post.floor;
        self.floorLabel.frame = postFrame.floorLabelF;
        
        // 内容
        self.contentLabel.hidden = NO;
        self.contentLabel.attributedText = post.attributeBody;
        self.contentLabel.frame = postFrame.contentLabelF;
        
        // 显示全部按钮
        self.showAllBtn.hidden = NO;
        self.showAllBtn.frame = postFrame.showAllBtnF;
        
        // 展开按钮
        self.expandBtn.hidden = YES;
    }
    
    // 尺寸
    self.frame = postFrame.PostViewF;
    
    
}

@end
