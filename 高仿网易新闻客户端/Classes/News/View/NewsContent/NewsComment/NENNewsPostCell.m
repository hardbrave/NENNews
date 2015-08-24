//
//  NENNewsPostCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsPostCell.h"
#import "NENNewsQuotePostsView.h"
#import "NENNewsPost.h"
#import "NENNewsPostFrame.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
#import "CommonDef.h"
#import "NSString+Font.h"
#import "NENNewsContent.h"

@interface NENNewsPostCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *voteCountLabel;
@property (nonatomic, strong) UIImageView *voteView;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *sepratorLine;
@property (nonatomic, strong) UIButton *showAllBtn;
@property (nonatomic, strong) NENNewsQuotePostsView *quotePostsView;
@end

@implementation NENNewsPostCell

#pragma mark - 实例化方法
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"postCell";
    NENNewsPostCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NENNewsPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 点击时不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化原创评论
        [self setupOriginal];
        
        // 初始引用评论
        [self setupQuote];
    }
    return self;
}

#pragma mark - 其他方法
/**
 *  初始化原创评论
 */
- (void)setupOriginal
{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = kNENPostIconWH * 0.5;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kNENPostNameFont;
    nameLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 点赞数
    UILabel *voteCountLabel = [[UILabel alloc] init];
    voteCountLabel.font = kNENPostVoteCountFont;
    voteCountLabel.textColor = [UIColor grayColor];
    voteCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:voteCountLabel];
    self.voteCountLabel = voteCountLabel;
    
    // 点赞图标
    UIImageView *voteView = [[UIImageView alloc] init];
    [self.contentView addSubview:voteView];
    self.voteView = voteView;
    
    // 来源
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = kNENPostSourceFont;
    sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = kNENPostTimeFont;
    timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 显示全部按钮
    UIButton *showAllBtn = [[UIButton alloc] init];
    [showAllBtn setImage:[UIImage imageNamed:@"comment_showall"] forState:UIControlStateNormal];
    [showAllBtn addTarget:self action:@selector(showAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:showAllBtn];
    self.showAllBtn = showAllBtn;
    
    // 分割线
    UIView *sepratorLine = [[UIView alloc] init];
    sepratorLine.backgroundColor = NENColor(240, 240, 240);
    sepratorLine.height = 1;
    sepratorLine.x = 0;
    [self.contentView addSubview:sepratorLine];
    self.sepratorLine = sepratorLine;
}

/**
 *  初始化引用评论
 */
- (void)setupQuote
{
    NENNewsQuotePostsView *quotePostsView = [[NENNewsQuotePostsView alloc] init];
    [self.contentView addSubview:quotePostsView];
    self.quotePostsView = quotePostsView;
}

#pragma mark - 监听方法
- (void)showAllBtnClick
{
    // 重算一遍frame
    NENNewsPost *post = self.postFrame.post;
    post.showAll = YES;
    self.postFrame.post = post;
    
    if (self.showAllContentBlock) {
        self.showAllContentBlock();
    }
}

#pragma mark - 属性方法
- (void)setPostFrame:(NENNewsPostFrame *)postFrame
{
    _postFrame = postFrame;
    
    NENNewsPost *post = postFrame.post;
    
    /**
     *  原始评论
     */
    // 头像
    UIImage *defaultIcon = [UIImage imageNamed:@"comment_profile_mars"];
    if (post.timg) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:post.timg] placeholderImage:defaultIcon];
    } else {
        self.iconView.image = defaultIcon;
    }
    
    self.iconView.frame = postFrame.iconViewF;
    
    // 名称
    self.nameLabel.text = post.name;
    self.nameLabel.frame = postFrame.nameLabelF;
    
    // 点赞数
    if ([post.vote integerValue]) {
        self.voteCountLabel.hidden = NO;
        self.voteCountLabel.text = post.vote;
        self.voteCountLabel.frame = postFrame.voteCountLabelF;
    } else {
        self.voteCountLabel.hidden = YES;
    }
    
    // 点赞图标
    self.voteView.image = [UIImage imageNamed:@"night_duanzi_up"];
    self.voteView.frame = postFrame.voteViewF;
    
    // 来源
    self.sourceLabel.text = post.source;
    self.sourceLabel.frame = postFrame.sourceLabelF;
    
    // 时间（由于时间会变化，所以此处需要重算一次尺寸）
    self.timeLabel.text = post.time;
    CGFloat timeX = postFrame.timeLabelF.origin.x;
    CGFloat timeY = postFrame.timeLabelF.origin.y;
    CGSize timeSize = [post.time sizeWithFont:kNENPostTimeFont];
    CGRect timeF = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.frame = timeF;
    
    // 引用评论
    self.quotePostsView.frame = postFrame.quotePostsViewF;
    __weak NENNewsPostCell *weakPostCell = self;
    self.quotePostsView.showAllFloorBlock = ^{
        if (weakPostCell.showAllFloorBlock)
        {
            NSString *url = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/load/%@/%@", weakPostCell.boardid, post.pi];
            weakPostCell.showAllFloorBlock(url);
        }
    };
    self.quotePostsView.posts = post.quotePosts;
    
    // 内容
    self.contentLabel.attributedText = post.attributeBody;
    self.contentLabel.frame = postFrame.contentLabelF;
    
    if (!CGRectIsEmpty(postFrame.showAllBtnF)) {
        self.showAllBtn.hidden = NO;
        self.showAllBtn.frame = postFrame.showAllBtnF;
    } else {
        self.showAllBtn.hidden = YES;
    }

}

#pragma mark - 系统方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.sepratorLine.width = self.width;
    self.sepratorLine.y = self.height - 1;
}

@end
