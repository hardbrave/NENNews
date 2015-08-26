//
//  NENContentViewCell.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENContentViewCell.h"
#import "NENNewsContent.h"
#import "UIImageView+WebCache.h"
#import "NENBigImageContentViewCell.h"
#import "NENNewsContentViewCell.h"
#import "NENImagesContentViewCell.h"
#import "NENTopImageContentViewCell.h"
#import "NENTopNewsContentViewCell.h"

@implementation NENContentViewCell
#pragma mark - 初始化方法
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 取消选中状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 实例方法
+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier
{
    NENContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if ([identifier isEqualToString:@"newsCell"]) {
            cell = [NENNewsContentViewCell cell];
        } else if ([identifier isEqualToString:@"imagesCell"]) {
            cell = [NENImagesContentViewCell cell];
        } else if ([identifier isEqualToString:@"bigImageCell"]) {
            cell = [NENBigImageContentViewCell cell];
        } else if ([identifier isEqualToString:@"topImageCell"]) {
            cell = [NENTopImageContentViewCell cell];
        } else if ([identifier isEqualToString:@"topNewsCell"]) {
            cell = [NENTopNewsContentViewCell cell];
        }
    }
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView newsContent:(NENNewsContent *)newsContent
{
    NENContentViewCell *cell = [self cellWithTableView:tableView reuseIdentifier:[self identifierForNewsContent:newsContent]];
    cell.newsContent = newsContent;
    return cell;
}

#pragma mark - 公开方法
+ (NSString *)identifierForNewsContent:(NENNewsContent *)newsContent
{
    if (newsContent.hasHead && newsContent.photosetID) {
        return @"topImageCell";
    } else if (newsContent.hasHead){
        return @"topNewsCell";
    } else if (newsContent.imgType) {
        return @"bigImageCell";
    } else if (newsContent.imgextra) {
        return @"imagesCell";
    } else {
        return @"newsCell";
    }
}

+ (CGFloat)heightForNewsContent:(NENNewsContent *)newsContent
{
    return [self heightForIndentifier:[self identifierForNewsContent:newsContent]];
}

+ (CGFloat)heightForIndentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"newsCell"]) {
        return [NENNewsContentViewCell height];
    } else if ([identifier isEqualToString:@"imagesCell"]) {
        return [NENImagesContentViewCell height];
    } else if ([identifier isEqualToString:@"bigImageCell"]) {
        return [NENBigImageContentViewCell height];
    } else if ([identifier isEqualToString:@"topImageCell"]) {
        return [NENTopImageContentViewCell height];
    } else if ([identifier isEqualToString:@"topNewsCell"]) {
        return [NENTopNewsContentViewCell height];
    } else {
        return 0;
    }
}


@end
