//
//  NENNewsContentViewCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsContentViewCell.h"
#import "NENNewsContent.h"
#import "UIImageView+WebCache.h"
#import "NSString+reply.h"

@interface NENNewsContentViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyBackground;
@end

@implementation NENNewsContentViewCell
#warning 只能由NENContentViewCell类调用，其他类不可直接调用!
+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NENNewsContentViewCell" owner:nil options:nil] firstObject];
}

- (void)setNewsContent:(NENNewsContent *)newsContent
{
    [super setNewsContent:newsContent];
    
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:newsContent.imgsrc]];
    self.titleLabel.text = newsContent.title;
    self.subtitleLabel.text = newsContent.digest;
    
    NSString *replyString = [NSString replyString:[newsContent.replyCount intValue]];
    if (replyString) {
        self.replyLabel.hidden = NO;
        self.replyBackground.hidden = NO;
        self.replyLabel.text = replyString;
    } else {
        self.replyLabel.hidden = YES;
        self.replyBackground.hidden = YES;
    }
}

+ (CGFloat)height
{
    return 80;
}

@end
