//
//  NENNewsGroupDropdownListView.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组下拉列表

#import <UIKit/UIKit.h>

@class NENNewsGroupDropdownListView;
@class NENNewsGroup;

@protocol NENNewsGroupDropdownListViewDelegate <NSObject>
@optional
- (void)newsGroupDropdownListViewDidExchange:(NENNewsGroupDropdownListView *)listView;
- (void)newsGroupDropdownListView:(NENNewsGroupDropdownListView *)listView didAddNewsGroup:(NENNewsGroup *)newsGroup;
- (void)newsGroupDropdownListView:(NENNewsGroupDropdownListView *)listView didDeleteNewsGroup:(NENNewsGroup *)newsGroup;
@end

@interface NENNewsGroupDropdownListView : UIView
+ (instancetype)listView;

- (void)selectItem:(NSString *)title;

@property (nonatomic, weak) id<NENNewsGroupDropdownListViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *newsGroups;
@property (nonatomic, copy, readonly) NSArray *topNewsGroup;
@property (nonatomic, copy, readonly) NSArray *bottomNewsGroup;
@end
