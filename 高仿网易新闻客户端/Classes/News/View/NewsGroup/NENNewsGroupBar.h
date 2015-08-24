//
//  NENNewsGroupBar.h
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//  新闻分组栏

#import <UIKit/UIKit.h>
#import "NENNewsGroupDropdownListView.h"

@class NENNewsGroup;
@class NENNewsGroupBar;

@protocol NENNewsGroupBarDelegate <UIScrollViewDelegate>
@optional
- (void)newsGroupBar:(NENNewsGroupBar *)bar didSelectTitle:(NSString *)title;
- (void)newsGroupBar:(NENNewsGroupBar *)bar didAddNewsGroup:(NENNewsGroup *)newsGroup;
- (void)newsGroupBar:(NENNewsGroupBar *)bar didDeleteNewsGroup:(NENNewsGroup *)newsGroup selected:(BOOL)selected;
- (void)newsGroupBarDidExchange:(NENNewsGroupBar *)bar;
@end

@interface NENNewsGroupBar : UIScrollView <NENNewsGroupDropdownListViewDelegate>
+ (instancetype)bar;

- (void)scrollToScale:(CGFloat)scale;

- (void)selectIndex:(NSUInteger)index;
- (void)selectTitle:(NSString *)title;

@property (nonatomic, copy) NSArray *newsGroups;
@property (nonatomic, weak) id<NENNewsGroupBarDelegate> delegate;
@end
