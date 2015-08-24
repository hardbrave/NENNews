//
//  NENNewsGroupBar.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupBar.h"
#import "NENNewsGroup.h"
#import "NENNewsGroupTitleLabel.h"
#import "NSString+Font.h"
#import "UIView+Frame.h"
#import "NENNewsGroup.h"
#import "NENNewsConst.h"
#import "CommonDef.h"
#import "NENNewsGroupDropdownListView.h"

@interface NENNewsGroupBar ()
@property (nonatomic, strong) NSMutableArray *titleLabels;
@property (nonatomic, copy) NSString *selectedTitle;
@end

@implementation NENNewsGroupBar
/**
 *  子类自身不合成_delegate变量，使用父控件的delegate
 */
@dynamic delegate;

#pragma mark - 懒加载方法
- (NSMutableArray *)titleLabels
{
    if (!_titleLabels) {
        self.titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        // 接收新闻分组下拉列表中按钮位置选中通知
        [NENNotificationCenter addObserver:self selector:@selector(onListItemSelected:) name:kNENNewsGroupListItemDidSelectNotification object:nil];
    }
    return self;
}

#pragma mark - 监听方法
- (void)onListItemSelected:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [self selectTitle:[userInfo[kNENNewsGroupListItemSelectKey] title]];
}

#pragma mark - 实例化方法
+ (instancetype)bar
{
    return [[self alloc] init];
}

#pragma mark - 系统方法
- (void)dealloc
{
    [NENNotificationCenter removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 布局所有的titleLabel控件
    [self layoutAllTitleLabels];
}

#pragma mark - 公开方法
- (void)scrollToScale:(CGFloat)scale
{
    NSUInteger leftIndex = (NSUInteger)scale;
    CGFloat leftScale = 1 - scale + leftIndex;
    NENNewsGroupTitleLabel *leftLabel = self.subviews[leftIndex];
    leftLabel.scale = leftScale;
    
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex < self.subviews.count) {
        CGFloat rightScale = scale - leftIndex;
        NENNewsGroupTitleLabel *rightLeabel = self.subviews[rightIndex];
        rightLeabel.scale = rightScale;
    }
}

- (void)selectIndex:(NSUInteger)index
{
    [self.titleLabels enumerateObjectsUsingBlock:^(NENNewsGroupTitleLabel *titleLabel, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            titleLabel.scale = 1;
            self.selectedTitle = titleLabel.title;
            CGFloat offsetX = titleLabel.centerX - self.centerX;
            CGFloat offsetMax = self.contentSize.width - self.width + self.contentInset.right;
            if (offsetX < 0) {
                offsetX = 0;
            } else if (offsetX > offsetMax) {
                offsetX = offsetMax;
            }
            [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
            
            if ([self.delegate respondsToSelector:@selector(newsGroupBar:didSelectTitle:)]) {
                [self.delegate newsGroupBar:self didSelectTitle:titleLabel.title];
            }
        } else {
            titleLabel.scale = 0;
        }
    }];
}

- (void)selectTitle:(NSString *)title
{
    __block NSUInteger index = 0;
    [self.titleLabels enumerateObjectsUsingBlock:^(NENNewsGroupTitleLabel *titleLabel, NSUInteger idx, BOOL *stop) {
        if ([titleLabel.title isEqualToString:title]) {
            index = idx;
        }
    }];
    
    [self selectIndex:index];
}

#pragma mark - 属性方法
- (void)setNewsGroups:(NSArray *)newsGroups
{
    _newsGroups = [newsGroups copy];
    
    // 清空之前可能存在的所有titleLabel控件
    [self.titleLabels enumerateObjectsUsingBlock:^(NENNewsGroupTitleLabel *titleLable, NSUInteger idx, BOOL *stop) {
        [titleLable removeFromSuperview];
    }];
    [self.titleLabels removeAllObjects];
    
    // 创建titleLabel控件
    [_newsGroups enumerateObjectsUsingBlock:^(NENNewsGroup *newsGroup, NSUInteger idx, BOOL *stop) {
        [self setupTitleLabel:newsGroup.title];
        
    }];
}

#pragma mark - 私有方法
/**
 *  创建titleLabel控件
 *
 *  @param title 标题
 */
- (void)setupTitleLabel:(NSString *)title
{
    NENNewsGroupTitleLabel *titleLabel = [NENNewsGroupTitleLabel titleLabel];
    titleLabel.title = title;
    __weak NENNewsGroupBar *weakGroupBar = self;
    titleLabel.onClick = ^(){
        [weakGroupBar selectTitle:title];
    };
    
    [self addSubview:titleLabel];
    [self.titleLabels addObject:titleLabel];
}

/**
 *  布局所有的titleLabel控件
 */
- (void)layoutAllTitleLabels
{
    __block CGFloat offsetX = 0;
    [self.titleLabels enumerateObjectsUsingBlock:^(NENNewsGroupTitleLabel *titleLabel, NSUInteger idx, BOOL *stop) {
        CGFloat x = offsetX;
        CGFloat y = 0;
        CGFloat h = self.height;
        CGFloat w = [titleLabel.text sizeWithFont:KNENNewsTitleFont].width + 2 * 10;
        titleLabel.frame = CGRectMake(x, y, w, h);
        offsetX = CGRectGetMaxX(titleLabel.frame);
    }];
    
    self.contentSize = CGSizeMake(offsetX, self.height);
}

#pragma mark - NENNewsGroupDropdownListViewDelegate
- (void)newsGroupDropdownListViewDidExchange:(NENNewsGroupDropdownListView *)listView
{
    self.newsGroups = listView.topNewsGroup;
    
    [self layoutAllTitleLabels];
    
    if ([self.delegate respondsToSelector:@selector(newsGroupBarDidExchange:)]) {
        [self.delegate newsGroupBarDidExchange:self];
    }
    
    [self selectTitle:self.selectedTitle];
}

- (void)newsGroupDropdownListView:(NENNewsGroupDropdownListView *)listView didAddNewsGroup:(NENNewsGroup *)newsGroup
{
    self.newsGroups = listView.topNewsGroup;
    
    [self layoutAllTitleLabels];
    
    if ([self.delegate respondsToSelector:@selector(newsGroupBar:didAddNewsGroup:)]) {
        [self.delegate newsGroupBar:self didAddNewsGroup:newsGroup];
    }
    
    [self selectTitle:self.selectedTitle];
}

- (void)newsGroupDropdownListView:(NENNewsGroupDropdownListView *)listView didDeleteNewsGroup:(NENNewsGroup *)newsGroup
{
    BOOL selected = NO;
    if ([newsGroup.title isEqualToString:self.selectedTitle]) {
        self.selectedTitle = @"头条";
        selected = YES;
    }
    self.newsGroups = listView.topNewsGroup;
    
    [self layoutAllTitleLabels];
    
    if ([self.delegate respondsToSelector:@selector(newsGroupBar:didDeleteNewsGroup:selected:)]) {
        [self.delegate newsGroupBar:self didDeleteNewsGroup:newsGroup selected:selected];
    }
    
    [self selectTitle:self.selectedTitle];
}

@end
