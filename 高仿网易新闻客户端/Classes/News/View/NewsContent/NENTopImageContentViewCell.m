//
//  NENTopImageContentViewCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/25.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENTopImageContentViewCell.h"
#import "NENNewsContent.h"
#import "UIImageView+WebCache.h"

@interface NENTopImageContentViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation NENTopImageContentViewCell
#pragma mark - 实例化方法
+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NENTopImageContentViewCell" owner:nil options:nil] firstObject];
}

#pragma mark - 公开方法
+ (CGFloat)height
{
    return 215;
}

#pragma mark - 父类属性方法
- (void)setNewsContent:(NENNewsContent *)newsContent
{
    [super setNewsContent:newsContent];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"photoview_image_default_white"];
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:newsContent.imgsrc] placeholderImage:placeholderImage];
    self.titleLabel.text = newsContent.title;
}
@end
