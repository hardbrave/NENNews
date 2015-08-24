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
    }
    return self;
}

#pragma mark - 属性方法
- (void)setPostFrame:(NENNewsQuotePostFrame *)postFrame
{
    _postFrame = postFrame;
    
    NENNewsQuotePost *post = postFrame.post;
    
    // 名字
    self.nameLabel.text = post.name;
    self.nameLabel.frame = postFrame.nameLabelF;
    
    // 楼层数
    self.floorLabel.text = post.floor;
    self.floorLabel.frame = postFrame.floorLabelF;
    
    // 内容
    self.contentLabel.text = post.body;
    self.contentLabel.frame = postFrame.contentLabelF;
    
    // 尺寸
    self.frame = postFrame.PostViewF;
    
}

@end
