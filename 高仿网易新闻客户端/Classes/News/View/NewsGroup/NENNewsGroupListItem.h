//
//  NENNewsGroupListItem.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组下拉列表中的按钮控件

#import <UIKit/UIKit.h>

@class NENNewsGroup;
@class NENNewsGroupListItem;

@protocol NENNewsGroupListItemDelegate <NSObject>
@optional
- (void)newsGroupListItemDidMove:(NENNewsGroupListItem *)listItem;
- (void)newsGroupListItemDidEndMoving:(NENNewsGroupListItem *)listItem;

- (void)newsGroupListItemDelete:(NENNewsGroupListItem *)listItem;
- (void)newsGroupListItemAdd:(NENNewsGroupListItem *)listItem;
@end

@interface NENNewsGroupListItem : UIButton
+ (instancetype)listItem;

@property (nonatomic, strong) NENNewsGroup *newsGroup;
@property (nonatomic, assign, getter=isEditEnabled) BOOL editEnabled;
@property (nonatomic, assign, getter=isEditing) BOOL editing;
@property (nonatomic, weak) id<NENNewsGroupListItemDelegate> delegate;
@end
