//
//  NENNewsPhotosetCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/18.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsPhotosetCell.h"
#import "UIImageView+WebCache.h"

@interface NENNewsPhotosetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation NENNewsPhotosetCell

#pragma mark - 属性方法
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
