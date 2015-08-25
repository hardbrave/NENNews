//
//  NENNewsPostCell.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NENNewsPostFrame;

@interface NENNewsPostCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) NSString *boardid;
@property (nonatomic, strong) NENNewsPostFrame *postFrame;
@property (nonatomic, copy) void(^showAllContentBlock)();
@property (nonatomic, copy) void(^showAllFloorBlock)(NSString *url);
@end
