//
//  NENImagesContentViewCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENImagesContentViewCell.h"
#import "NENNewsContent.h"
#import "UIImageView+WebCache.h"
#import "NSString+reply.h"

@interface NENImagesContentViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyBackground;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@end

@implementation NENImagesContentViewCell

#warning 只能由NENContentViewCell类调用，其他类不可直接调用!
+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NENImagesContentViewCell" owner:nil options:nil] firstObject];
}

- (void)setNewsContent:(NENNewsContent *)newsContent
{
    [super setNewsContent:newsContent];
    
    self.titleLabel.text = newsContent.title;
    
//    NSString *replyString = [NSString replyString:[newsContent.replyCount intValue]];
//    if (replyString) {
//        self.replyLabel.hidden = NO;
//        self.replyBackground.hidden = NO;
//        self.replyLabel.text = replyString;
//    } else {
//        self.replyLabel.hidden = YES;
//        self.replyBackground.hidden = YES;
//    }
    self.replyLabel.hidden = YES;
    self.replyBackground.hidden = YES;
    
    // 多图cell
    UIImage *placeholderImage = [UIImage imageNamed:@"photoview_image_default_white"];
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:newsContent.imgsrc] placeholderImage:placeholderImage];
    [self.secondeImageView sd_setImageWithURL:[NSURL URLWithString:newsContent.imgextra[0][@"imgsrc"]] placeholderImage:placeholderImage];
    [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:newsContent.imgextra[1][@"imgsrc"]] placeholderImage:placeholderImage];
    
}

+ (CGFloat)height
{
    return 130;
}

@end
