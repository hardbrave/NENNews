//
//  NENNewsQuotePostsView.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/20.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsQuotePostsView.h"
#import "NENNewsQuotePost.h"
#import "NENNewsQuotePostView.h"
#import "NSString+Font.h"
#import "UIView+Frame.h"
#import "NENNewsQuotePostFrame.h"
#import "NSAttributedString+paragraph.h"

@implementation NENNewsQuotePostsView

#define kNENNewsQuoteMaxEmbedNum    4

#pragma mark - 属性方法
- (void)setPosts:(NSArray *)posts
{
    _posts = [posts copy];
    
    NSUInteger postCount = posts.count;
    
    while (self.subviews.count < postCount) {
        NENNewsQuotePostView *postView = [[NENNewsQuotePostView alloc] init];
        [self addSubview:postView];
    }

    /** 根据传入的post数组生成postFrame数组 */
    NSMutableArray *postFrames = [NSMutableArray array];
    __block CGFloat quoteHeight = 0;
    [posts enumerateObjectsUsingBlock:^(NENNewsQuotePost *post, NSUInteger idx, BOOL *stop) {
        
        NENNewsQuotePostFrame *postFrame = [[NENNewsQuotePostFrame alloc] init];
        postFrame.post = post;
        
        NSUInteger realEmbedNum = MIN(kNENNewsQuoteMaxEmbedNum, postCount - idx - 1);
        
        CGFloat postViewX = realEmbedNum * kNENQuotePostPaddingH;
        CGFloat postViewY = realEmbedNum * kNENQuotePostPaddingV;
        CGFloat postViewW = self.width - postViewX * 2;
        
        CGFloat padding = 0;
        if (quoteHeight) {
            padding = quoteHeight + kNENQuotePostPaddingV;
        }
        
        // 如果是隐藏楼层
        if (post.isHidden) {
            CGFloat showBtnX = 0;
            CGFloat showBtnY = padding;
            CGFloat showBtnW = postViewW;
            CGFloat showBtnH = kNENQuotePostShowBtnH;
            postFrame.showBtnF = CGRectMake(showBtnX, showBtnY, showBtnW, showBtnH);
            
            CGFloat postViewH = CGRectGetMaxY(postFrame.showBtnF);
            postFrame.PostViewF = CGRectMake(postViewX, postViewY, postViewW, postViewH);
            
            [postFrames addObject:postFrame];
            
            quoteHeight = postViewH;
            
            return;
        }
        
        CGFloat floorY = padding + kNENQuotePostMarginV;
        CGSize floorSize = [post.floor sizeWithFont:kNENQuotePostFloorFont];
        CGFloat floorX = postViewW - floorSize.width - kNENQuotePostMarginH;
        postFrame.floorLabelF = (CGRect){{floorX, floorY}, floorSize};
        
        CGFloat nameX = kNENQuotePostMarginH;
        CGFloat nameY = padding + kNENQuotePostMarginV;
        CGFloat nameW = postViewW - nameX - floorSize.width - kNENQuotePostMarginH - 3;
        CGSize nameSize = [post.name sizeWithFont:kNENQuotePostNameFont];
        postFrame.nameLabelF = CGRectMake(nameX, nameY, nameW, nameSize.height);
        
        CGFloat contentX = kNENQuotePostMarginH;
        CGFloat contentY = CGRectGetMaxY(postFrame.nameLabelF) + kNENQuotePostMarginV;
        CGFloat contentMaxW = postViewW - 2 * kNENQuotePostMarginH;
        CGSize contentSize = [post.attributeBody sizeWithMaxW:contentMaxW];
      //  CGSize contentSize = [post.body sizeWithFont:kNENQuotePostContentFont maxW:(postViewW - 2 * kNENQuotePostMarginH)];
        postFrame.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
        
        CGFloat postViewH = CGRectGetMaxY(postFrame.contentLabelF) + kNENQuotePostMarginV;
        postFrame.PostViewF = CGRectMake(postViewX, postViewY, postViewW, postViewH);
        
        [postFrames addObject:postFrame];
        
        quoteHeight = postViewH;
        
    }];

    /** 为每个postView赋值一个postFrame数组 */
    [self.subviews enumerateObjectsUsingBlock:^(NENNewsQuotePostView *postView, NSUInteger idx, BOOL *stop) {
        if (idx < postCount) {
            postView.hidden = NO;
            postView.postFrame = postFrames[postCount - idx - 1];
            postView.showAllFloorBlock = self.showAllFloorBlock;
        } else {
            postView.hidden = YES;
        }
    }];
}

#pragma mark - 公开方法
/**
 *  得到引用评论区域的高度
 *
 *  @param posts 引用评论数组
 *  @param width 引用评论区域的宽度
 *
 *  @return 引用评论区域的高度
 */
+ (CGFloat)heightWithPosts:(NSArray *)posts width:(CGFloat)width
{
    NSUInteger postCount = posts.count;
    
    __block CGFloat quoteHeight = 0;
    [posts enumerateObjectsUsingBlock:^(NENNewsQuotePost *post, NSUInteger idx, BOOL *stop) {
        
        NSUInteger realEmbedNum = MIN(kNENNewsQuoteMaxEmbedNum, postCount - idx - 1);
        CGFloat postViewW = width - (realEmbedNum * kNENQuotePostPaddingH) * 2;
        
        CGFloat padding = 0;
        if (quoteHeight) {
            padding = quoteHeight + kNENQuotePostPaddingV;
        }
        
        // 如果是隐藏楼层
        if (post.isHidden) {
            CGFloat showBtnY = padding + kNENQuotePostMarginV;
            CGFloat showBtnH = kNENQuotePostShowBtnH;
            quoteHeight = showBtnY + showBtnH;
            return;
        }
        
        CGFloat nameY = padding + kNENQuotePostMarginV;
        CGSize nameSize = [post.name sizeWithFont:kNENQuotePostNameFont];
        
        CGFloat contentY = nameY + nameSize.height + kNENQuotePostMarginV;
        CGFloat contentMaxW = postViewW - 2 * kNENQuotePostMarginH;
        CGSize contentSize = [post.attributeBody sizeWithMaxW:contentMaxW];
       // CGSize contentSize = [post.body sizeWithFont:kNENQuotePostContentFont maxW:(postViewW - 2 * kNENQuotePostMarginH)];
        
        CGFloat postViewH = contentY + contentSize.height + kNENQuotePostMarginV;
        
        quoteHeight = postViewH;
        
    }];

    
    return quoteHeight;
}

@end
