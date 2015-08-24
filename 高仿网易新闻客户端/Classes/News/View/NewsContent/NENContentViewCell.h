//
//  NENContentViewCell.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NENNewsContent;

@interface NENContentViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)identifier;
+ (instancetype)cellWithTableView:(UITableView *)tableView newsContent:(NENNewsContent *)newsContent;

+ (NSString *)identifierForNewsContent:(NENNewsContent *)newsContent;

+ (CGFloat)heightForNewsContent:(NENNewsContent *)newsContent;
+ (CGFloat)heightForIndentifier:(NSString *)identifier;

@property (nonatomic, strong) NENNewsContent *newsContent;

@end
