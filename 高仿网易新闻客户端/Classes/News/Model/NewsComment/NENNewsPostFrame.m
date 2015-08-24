//
//  NENNewsPostFrame.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsPostFrame.h"
#import "NENNewsPost.h"
#import "NSString+Font.h"
#import "CommonDef.h"
#import "NENNewsQuotePostsView.h"
#import "UIView+Frame.h"
#import "NSAttributedString+paragraph.h"

@implementation NENNewsPostFrame
#pragma mark - 属性方法
- (void)setPost:(NENNewsPost *)post
{
    _post = post;
    
    CGFloat cellW = kNENScreenW;
    
    /**
     *  原始评论
     */
    
    // 头像
    CGFloat iconWH = kNENPostIconWH;
    CGFloat iconX = kNENPostPaddingH;
    CGFloat iconY = kNENPostPaddingV;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    // 名称
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + kNENPostMarginH;
    CGFloat nameY = kNENPostMarginV + 5;
    CGSize nameSize = [post.name sizeWithFont:kNENPostNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    // 点赞图标
    CGFloat voteViewWH = 17;
    CGFloat voteViewY = kNENPostPaddingV;
    CGFloat voteViewX = cellW - (kNENPostPaddingH + voteViewWH);
    self.voteViewF = CGRectMake(voteViewX, voteViewY, voteViewWH, voteViewWH);
    
    // 点赞数
    if ([post.vote integerValue]) {
        CGSize voteLabelSize = [post.vote sizeWithFont:kNENPostVoteCountFont];
        CGFloat voteLabelX = voteViewX - kNENPostMarginH - voteLabelSize.width;
        CGFloat voteLabelY = nameY;
        self.voteCountLabelF = (CGRect){{voteLabelX, voteLabelY}, voteLabelSize};
    }
    
    // 来源
    CGFloat sourceX = nameX;
    CGFloat sourceY = CGRectGetMaxY(self.nameLabelF) + kNENPostMarginV;
    CGSize sourceSize = [post.source sizeWithFont:kNENPostSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 时间
    CGFloat timeX = CGRectGetMaxX(self.sourceLabelF) + kNENPostMarginH;
    CGFloat timeY = sourceY;
    CGSize timeSize = [post.time sizeWithFont:kNENPostTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    // 引用评论
    CGFloat contentY = 0;
    if (post.quotePosts.count) {
        CGFloat quotePostX = nameX;
        CGFloat quotePostY = CGRectGetMaxY(self.timeLabelF) + kNENPostMarginV;
        CGFloat quotePostW = cellW - nameX - kNENPostMarginV;
        CGFloat quotePostH = [NENNewsQuotePostsView heightWithPosts:post.quotePosts width:quotePostW];
        self.quotePostsViewF = CGRectMake(quotePostX, quotePostY, quotePostW, quotePostH);
        contentY = CGRectGetMaxY(self.quotePostsViewF) + kNENPostMarginV;
    } else {
        contentY = CGRectGetMaxY(self.timeLabelF) + kNENPostMarginV;
    }
    
    // 内容
    CGFloat contentX = nameX;
    CGFloat contentMaxW = cellW - nameX - kNENPostMarginV;
    CGFloat contentMaxH = kNENPostContentMaxH;
    CGSize contentSize = [post.attributeBody sizeWithMaxW:contentMaxW];
  //  CGSize contentSize = [post.body sizeWithFont:kNENPostContentFont maxW:contentMaxW];
    if (!post.showAll && contentSize.height > contentMaxH) {
        contentSize.height = contentMaxH;
        self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
        // 显示全部按钮
        CGFloat showAllW = 72;
        CGFloat showAllH = 15;
        CGFloat showAllY = CGRectGetMaxY(self.contentLabelF) + kNENPostMarginV;
        CGFloat showAllX = cellW - kNENPostPaddingH - showAllW;
        self.showAllBtnF = CGRectMake(showAllX, showAllY, showAllW, showAllH);
        // cell高度
        self.cellH = CGRectGetMaxY(self.showAllBtnF) + 8 + kNENPostPaddingV;
    } else {
        self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
        // 显示全部按钮
        self.showAllBtnF = CGRectMake(0, 0, 0, 0);
        // cell高度
        self.cellH = CGRectGetMaxY(self.contentLabelF) + kNENPostPaddingV;
    }
    
}

@end
