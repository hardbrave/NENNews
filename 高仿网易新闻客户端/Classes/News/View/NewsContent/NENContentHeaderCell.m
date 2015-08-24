//
//  NENContentHeaderCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENContentHeaderCell.h"
#import "NENNewsAD.h"
#import "UIImageView+WebCache.h"

@interface NENContentHeaderCell ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation NENContentHeaderCell

#pragma mark - 属性方法
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
