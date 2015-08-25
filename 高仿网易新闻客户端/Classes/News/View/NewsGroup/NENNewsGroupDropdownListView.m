//
//  NENNewsGroupDropdownListView.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupDropdownListView.h"
#import "UIView+Frame.h"
#import "NENNewsGroupListItem.h"
#import "NENNewsGroupEditBar.h"
#import "NENNewsGroupListBackItem.h"
#import "NENNewsConst.h"
#import "NENNewsGroup.h"
#import "NENNewsGroupTool.h"

#define kNENNewsGroupDropdownListViewItemPaddingV   20
#define kNENNewsGroupDropdownListViewItemPaddingH   20
#define KNENNewsGroupDropdownListViewItemH          25
#define kNENNewsGroupDropdownListViewItemsPerLine   4


@interface NENNewsGroupDropdownListView ()<NENNewsGroupListItemDelegate> {
    NENNewsGroupListItem *_selectedItem;
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *bottomView;
@property (nonatomic, strong) UILabel *sectionHeader;
@property (nonatomic, strong) NSMutableArray *topTitleItemList;     // 存放上侧区域所有按钮
@property (nonatomic, strong) NSMutableArray *bottomTitleItemList;  // 存放下侧区域所有按钮
@property (nonatomic, strong) NSMutableArray *topBackgroundItemList;    // 存放上侧区域所有背景View
@property (nonatomic, strong) NSMutableArray *bottomBackgroundItemList; // 存放下侧区域所有背景View
@end

@implementation NENNewsGroupDropdownListView

#pragma mark - 懒加载方法
- (NSMutableArray *)topTitleItemList
{
    if (!_topTitleItemList) {
        _topTitleItemList = [NSMutableArray array];
    }
    return _topTitleItemList;
}

- (NSMutableArray *)bottomTitleItemList
{
    if (!_bottomTitleItemList) {
        _bottomTitleItemList = [NSMutableArray array];
    }
    return _bottomTitleItemList;
}

- (NSMutableArray *)topBackgroundItemList
{
    if (!_topBackgroundItemList) {
        _topBackgroundItemList = [NSMutableArray array];
    }
    return _topBackgroundItemList;
}

- (NSMutableArray *)bottomBackgroundItemList
{
    if (!_bottomBackgroundItemList) {
        _bottomBackgroundItemList = [NSMutableArray array];
    }
    return _bottomBackgroundItemList;
}

- (UIView *)topView
{
    if (!_topView) {
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        _topView = topView;
    }
    return _topView;
}

- (UIScrollView *)bottomView
{
    if (!_bottomView) {
        UIScrollView *bottomView = [[UIScrollView alloc] init];
        [self addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        
        // 中间标签区域
        UILabel *sectionHeader = [[UILabel alloc] init];
        sectionHeader.backgroundColor = [UIColor grayColor];
        sectionHeader.text = @"点击添加更多栏目";
        sectionHeader.font = [UIFont systemFontOfSize:16];
        sectionHeader.textColor = [UIColor blackColor];
        [self insertSubview:sectionHeader atIndex:0];
        self.sectionHeader = sectionHeader;
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEditBarNotification:)
                                                     name:kNENNewsGroupEditBarNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onListItemLongPress)
                                                     name:kNENNewsGroupListItemLongPressNotification object:nil];
    }
    return self;
}

#pragma mark - 实例化方法
+ (instancetype)listView
{
    return [[self alloc] init];
}

#pragma mark - 系统方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutTopView];
    [self layoutSectionHeader];
    [self layoutBottonView];
}

#pragma mark -- 公开方法
- (void)selectItem:(NSString *)title
{
    [self.topTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
        if ([item.newsGroup.title isEqualToString:title]) {
            _selectedItem.selected = false;
            item.selected = true;
            _selectedItem = item;
            *stop = YES;
        }
    }];
}

#pragma mark - 属性方法
- (void)setNewsGroups:(NSMutableArray *)newsGroups
{
    _newsGroups = newsGroups;
    
    // 保存之前可能选中的标题
    NSString *selectedTitle = _selectedItem.newsGroup.title;
    
    // 清空之前可能存在的数据
    [self.topTitleItemList removeAllObjects];
    [self.bottomTitleItemList removeAllObjects];
    [self.topBackgroundItemList removeAllObjects];
    [self.bottomBackgroundItemList removeAllObjects];
    [self.topView.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
    
    [newsGroups enumerateObjectsUsingBlock:^(NENNewsGroup *newsGroup, NSUInteger idx, BOOL *stop) {
        if (newsGroup.type == NENNewsGroupTypeTop) {
            // 背景
            NENNewsGroupListBackItem *backgroundItem = [NENNewsGroupListBackItem item];
            [self.topBackgroundItemList addObject:backgroundItem];
            [self.topView insertSubview:backgroundItem atIndex:0];   // 背景块一概插到View的最底层，防止其挡住上方按钮
            backgroundItem.hidden = !(idx != 0);
            // 按钮
            NENNewsGroupListItem *item = [NENNewsGroupListItem listItem];
            item.newsGroup = newsGroup;
            item.delegate = self;
            item.editEnabled = (idx != 0);
            [self.topTitleItemList addObject:item];
            [self.topView addSubview:item];
            
        } else if (newsGroup.type == NENNewsGroupTypeBottom) {
            // 背景
            NENNewsGroupListBackItem *backgroundItem = [NENNewsGroupListBackItem item];
            [self.bottomBackgroundItemList addObject:backgroundItem];
            [self.bottomView insertSubview:backgroundItem atIndex:0];    // 背景块一概插到View的最底层，防止其挡住上方按钮
            // 按钮
            NENNewsGroupListItem *item = [NENNewsGroupListItem listItem];
            item.newsGroup = newsGroup;
            item.delegate = self;
            item.editEnabled = YES;
            [self.bottomTitleItemList addObject:item];
            [self.bottomView addSubview:item];
        }

    }];
    
    // 还原之前可能选中的标题
    [self selectItem:selectedTitle];
    
    // 强制布局
    [self setNeedsLayout];
}

- (NSArray *)topNewsGroup
{
    NSMutableArray *topNewsGroup = [NSMutableArray array];
    [self.topTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
        if (item.newsGroup.type == NENNewsGroupTypeTop) {
            [topNewsGroup addObject:item.newsGroup];
        }
    }];
    return topNewsGroup;
}

- (NSArray *)bottomNewsGroup
{
    NSMutableArray *bottomNewsGroup = [NSMutableArray array];
    [self.bottomTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
        if (item.newsGroup.type == NENNewsGroupTypeTop) {
            [bottomNewsGroup addObject:item.newsGroup];
        }
    }];
    return bottomNewsGroup;
}

#pragma mark - 其它方法
- (void)animationWithBlock:(void(^)())block
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews
                     animations:block completion:nil];
}

#pragma mark - 监听方法
- (void)onEditBarNotification:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    BOOL isEditing = [userinfo[kNENNewsGroupEditBarIsEditing] boolValue];
    self.sectionHeader.hidden = isEditing;
    self.bottomView.hidden = isEditing;
    _selectedItem.selected = !isEditing;   // 编辑界面没有选中状态
}

- (void)onListItemLongPress
{
    self.sectionHeader.hidden = YES;
    self.bottomView.hidden = YES;
}

#pragma mark -- NENNewsGroupListItemDelegate
- (void)newsGroupListItemDidMove:(NENNewsGroupListItem *)listitem
{
    // 判断当前按钮区域与哪个按钮区域相交
    NSUInteger curIndex = [self.topTitleItemList indexOfObject:listitem];
    __block NSUInteger exchangeIndex = curIndex;
    __block NENNewsGroup *exchangeNewsGroup = nil;
    [self.topTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(item.frame, listitem.center) && idx != curIndex && idx != 0) {
            exchangeIndex = idx;
            exchangeNewsGroup = [self.topTitleItemList[idx] newsGroup];
            *stop = YES;
        }
    }];
    
    if (exchangeIndex != curIndex) {
        // 调整新闻分组模型数组
        [self exchangeNewsGroup:listitem.newsGroup withOther:exchangeNewsGroup];
        
        // 交换当前按钮与相交按钮的位置
        [self.topTitleItemList exchangeObjectAtIndex:curIndex withObjectAtIndex:exchangeIndex];
        [self animationWithBlock:^{
            [self.topTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
                // 布局上侧区域除了当前按钮以外的其它按钮位置
                if (idx != exchangeIndex) {
                    [self layoutTopListItem:item withIndex:idx];
                }
            }];
        }];
    }
}

- (void)newsGroupListItemDidEndMoving:(NENNewsGroupListItem *)listItem
{
    // 重新布局上侧区域所有的按钮
    [self animationWithBlock:^{
        [self.topTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
            [self layoutTopListItem:item withIndex:idx];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(newsGroupDropdownListViewDidExchange:)]) {
        [self.delegate newsGroupDropdownListViewDidExchange:self];
    }
    
    // 存储新闻分组模型数组
    [NENNewsGroupTool saveNewsGroups:self.newsGroups];
}

- (void)newsGroupListItemDelete:(NENNewsGroupListItem *)listItem
{
    // 调整新闻分组模型数组
    [self exchangeNewsGroupFromTopToBottom:listItem.newsGroup];
    
    // 将当期背景块从上侧侧区域删除
    NSUInteger curIndex = [self.topTitleItemList indexOfObject:listItem];
    NENNewsGroupListBackItem *backItem = self.topBackgroundItemList[curIndex];
    [self.topBackgroundItemList removeObjectAtIndex:curIndex];
    // 计算当前背景块在下侧区域中的frame（实现平滑的动画效果）
    backItem.frame = [backItem.superview convertRect:backItem.frame toView:self.bottomView];
    [backItem removeFromSuperview];
    
    // 将当前按钮从上侧区域删除
    [self.topTitleItemList removeObject:listItem];
    // 计算当前按钮在下侧区域中的frame（实现平滑的动画效果）
    listItem.frame = [listItem.superview convertRect:listItem.frame toView:self.bottomView];
    [listItem removeFromSuperview];
    
    // 将当前按钮添加到下侧区域
    listItem.editing = NO;
    [self.bottomView addSubview:listItem];
    [self.bottomTitleItemList insertObject:listItem atIndex:0];
    
    // 将当前背景块添加到下侧区域
    [self.bottomBackgroundItemList addObject:backItem];
    [self.bottomView insertSubview:backItem atIndex:0];   // 背景块一概插到父View的最底层，防止其挡住上方按钮
    
    // 布局上下区域
    [self animationWithBlock:^{
        [self layoutTopView];
        [self layoutSectionHeader];
        [self layoutBottonView];;
    }];

    if ([self.delegate respondsToSelector:@selector(newsGroupDropdownListView:didDeleteNewsGroup:)]) {
        [self.delegate newsGroupDropdownListView:self didDeleteNewsGroup:listItem.newsGroup];
    }
    
    // 存储新闻分组模型数组
    [NENNewsGroupTool saveNewsGroups:self.newsGroups];
}

- (void)newsGroupListItemAdd:(NENNewsGroupListItem *)listItem
{
    // 调整新闻分组模型数组
    [self exchangeNewsGroupFromBottomToTop:listItem.newsGroup];
    
    // 将当前按钮从下侧区域删除
    [self.bottomTitleItemList removeObject:listItem];
    // 计算当前按钮在上侧区域中的frame（实现平滑的动画效果）
    listItem.frame = [listItem.superview convertRect:listItem.frame toView:self.topView];
    [listItem removeFromSuperview];
    
    // 将当前按钮添加到上侧区域
    [self.topTitleItemList addObject:listItem];
    [self.topView addSubview:listItem];
    
    // 布局上下区域
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self layoutTopView];
        [self layoutSectionHeader];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [self layoutBottonView];
        } completion:^(BOOL finished) {
            // 将下侧区域最后一个背景块移到上侧区域的末尾
            NENNewsGroupListBackItem *lastBackgroundItem = [self.bottomBackgroundItemList lastObject];
            [lastBackgroundItem removeFromSuperview];
            [self.bottomBackgroundItemList removeObject:lastBackgroundItem];
            [self.topBackgroundItemList addObject:lastBackgroundItem];
            [self.topView insertSubview:lastBackgroundItem atIndex:0];  // 背景块一概插到父View的最底层，防止其挡住上方按钮
            [self layoutTopListItem:lastBackgroundItem withIndex:(self.topBackgroundItemList.count -1 )];
        }];
    }];
    
    if ([self.delegate respondsToSelector:@selector(newsGroupDropdownListView:didAddNewsGroup:)]) {
        [self.delegate newsGroupDropdownListView:self didAddNewsGroup:listItem.newsGroup];
    }

    // 存储新闻分组模型数组
    [NENNewsGroupTool saveNewsGroups:self.newsGroups];
}

#pragma mark - 新闻分组模型数组交换模型方法
- (void)exchangeNewsGroup:(NENNewsGroup *)newsGroup withOther:(NENNewsGroup *)other
{
    NSUInteger index1 = [self.newsGroups indexOfObject:newsGroup];
    NSUInteger index2 = [self.newsGroups indexOfObject:other];
    [self.newsGroups exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

- (void)exchangeNewsGroupFromTopToBottom:(NENNewsGroup *)newsGroup
{
    newsGroup.type = NENNewsGroupTypeBottom;
    [self.newsGroups removeObject:newsGroup];
    if (self.bottomBackgroundItemList.count != 0) {
        NSUInteger index = [self.newsGroups indexOfObject:[self.bottomTitleItemList.firstObject newsGroup]];
        [self.newsGroups insertObject:newsGroup atIndex:index];
    } else {
        [self.newsGroups insertObject:newsGroup atIndex:0];
    }
}

- (void)exchangeNewsGroupFromBottomToTop:(NENNewsGroup *)newsGroup
{
    newsGroup.type = NENNewsGroupTypeTop;
    [self.newsGroups removeObject:newsGroup];
    if (self.topTitleItemList.count != 0) {
        NSUInteger index = [self.newsGroups indexOfObject:[[self.topTitleItemList lastObject] newsGroup]];
        [self.newsGroups insertObject:newsGroup atIndex:(index + 1)];
    } else {
        [self.newsGroups insertObject:newsGroup atIndex:0];
    }
}

#pragma mark - 布局方法
- (void)layoutTopView
{
    // 计算topView中所有背景块的frame
    [self.topBackgroundItemList enumerateObjectsUsingBlock:^(NENNewsGroupListBackItem *item, NSUInteger idx, BOOL *stop) {
        [self layoutTopListItem:item withIndex:idx];
    }];
    
    // 计算topView中所有按钮的frame
    [self.topTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
        [self layoutTopListItem:item withIndex:idx];
    }];
    
    // 计算topView的frame
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = self.width;
    CGFloat topViewH = CGRectGetMaxY([[self.topTitleItemList lastObject] frame]) + kNENNewsGroupDropdownListViewItemPaddingV;
    self.topView.frame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
}

- (void)layoutSectionHeader
{
    self.sectionHeader.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.width, 30);
}

- (void)layoutBottonView
{
    // 计算bottomView中所有背景块的frame
    [self.bottomBackgroundItemList enumerateObjectsUsingBlock:^(NENNewsGroupListBackItem *item, NSUInteger idx, BOOL *stop) {
        [self layoutBottomListItem:item withIndex:idx];
    }];
    
    // 计算bottomView中所有按钮的frame
    [self.bottomTitleItemList enumerateObjectsUsingBlock:^(NENNewsGroupListItem *item, NSUInteger idx, BOOL *stop) {
        [self layoutBottomListItem:item withIndex:idx];
    }];
    
    // 计算bottomView的frame以及contentSize
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = CGRectGetMaxY(self.sectionHeader.frame);
    CGFloat bottomViewH = self.height - self.topView.height - self.sectionHeader.height;
    CGFloat bottomViewW = self.width;
    self.bottomView.frame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    CGFloat bottomViewRealH = CGRectGetMaxY([[self.bottomTitleItemList lastObject] frame]) + kNENNewsGroupDropdownListViewItemPaddingV;
    self.bottomView.contentSize = CGSizeMake(self.width, bottomViewRealH);
}

- (void)layoutTopListItem:(UIView *)listItem withIndex:(NSUInteger)index
{
    CGFloat itemW = (self.width - (1 + kNENNewsGroupDropdownListViewItemsPerLine) * kNENNewsGroupDropdownListViewItemPaddingH) / kNENNewsGroupDropdownListViewItemsPerLine;
    CGFloat itemH = KNENNewsGroupDropdownListViewItemH;
    CGFloat itemX = kNENNewsGroupDropdownListViewItemPaddingH + (kNENNewsGroupDropdownListViewItemPaddingH + itemW) * (index % kNENNewsGroupDropdownListViewItemsPerLine);
    CGFloat itemY = kNENNewsGroupDropdownListViewItemPaddingV + (kNENNewsGroupDropdownListViewItemPaddingV + itemH) * (index / kNENNewsGroupDropdownListViewItemsPerLine);
    listItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
}

- (void)layoutBottomListItem:(UIView *)listItem withIndex:(NSUInteger)index
{
    CGFloat itemW = (self.width - (1 + kNENNewsGroupDropdownListViewItemsPerLine) * kNENNewsGroupDropdownListViewItemPaddingH) / kNENNewsGroupDropdownListViewItemsPerLine;
    CGFloat itemH = KNENNewsGroupDropdownListViewItemH;
    CGFloat itemX = kNENNewsGroupDropdownListViewItemPaddingH + (kNENNewsGroupDropdownListViewItemPaddingH + itemW) *
    (index % kNENNewsGroupDropdownListViewItemsPerLine);
    CGFloat itemY = kNENNewsGroupDropdownListViewItemPaddingV + (kNENNewsGroupDropdownListViewItemPaddingV + itemH) *
    (index / kNENNewsGroupDropdownListViewItemsPerLine);
    listItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
}

@end
