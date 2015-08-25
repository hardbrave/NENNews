//
//  NENNewsViewController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsViewController.h"
#import "NSString+Font.h"
#import "CommonDef.h"
#import "NENNewsGroupTitleLabel.h"
#import "UIView+Frame.h"
#import "NENNewsGroupBar.h"
#import "MJExtension.h"
#import "NENNewsGroup.h"
#import "NENNewsGroupDropdownButton.h"
#import "NENNewsGroupEditBar.h"
#import "NENNewsGroupDropdownListView.h"
#import "NENNewsContentController.h"
#import "NENNewsGroupTool.h"
#import "NENNewsDetailController.h"
#import "NENNavigationController.h"
#import "NENNewsConst.h"
#import "NENHttpTool.h"

#define kNENNewsGroupBarH                   40
#define kNENNewsGroupDropdownBtnW           40
#define kNENNewsGroupDropdownListViewH      kNENScreenH - (64 + kNENNewsGroupBarH)
#define kNENNewsGroupDropdownListViewY      2 * (64 + kNENNewsGroupBarH) - kNENScreenH

@interface NENNewsViewController ()<UIScrollViewDelegate, NENNewsGroupBarDelegate>
@property (nonatomic, strong) NENNewsGroupBar *newsGroupBar;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NENNewsGroupDropdownButton *newsGroupDropdownBtn;
@property (nonatomic, strong) NENNewsGroupEditBar *newsGroupEditBar;
@property (nonatomic, strong) NENNewsGroupDropdownListView *newsGroupDropdownListView;
@property (nonatomic, strong) NSMutableArray *newsGroups;
@property (nonatomic, copy, readonly) NSArray *topNewsGroups;
/**
 *  ContentController字典，key为新闻组标题
 */
@property (nonatomic, strong) NSMutableDictionary *contentVCs;
@end

@implementation NENNewsViewController

#pragma mark - 懒加载方法
- (NSMutableArray *)newsGroups
{
    if (!_newsGroups) {
        self.newsGroups = [NENNewsGroupTool newsGroups];
    }
    return _newsGroups;
}

- (NENNewsGroupEditBar *)newsGroupEditBar
{
    if (!_newsGroupEditBar) {
        NENNewsGroupEditBar *newsGroupEditBar = [NENNewsGroupEditBar bar];
        newsGroupEditBar.frame = CGRectMake(0, 64, kNENScreenW - kNENNewsGroupDropdownBtnW, kNENNewsGroupBarH);
        newsGroupEditBar.hidden = YES;
        [self.view addSubview:newsGroupEditBar];
        self.newsGroupEditBar = newsGroupEditBar;
    }
    return _newsGroupEditBar;
}

- (NENNewsGroupDropdownListView *)newsGroupDropdownListView
{
    if (!_newsGroupDropdownListView) {
        NENNewsGroupDropdownListView *listView = [NENNewsGroupDropdownListView listView];
        listView.newsGroups = self.newsGroups;
        listView.delegate = self.newsGroupBar;
        listView.frame = CGRectMake(0, kNENNewsGroupDropdownListViewY, kNENScreenW, kNENNewsGroupDropdownListViewH);
        [self.view insertSubview:listView aboveSubview:self.contentView];
        self.newsGroupDropdownListView = listView;
    }
    return _newsGroupDropdownListView;
}

- (NSMutableDictionary *)contentVCs
{
    if (!_contentVCs) {
        self.contentVCs = [NSMutableDictionary dictionary];
    }
    return _contentVCs;
}

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 自己控制内部scrollView控件的位置和偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置背景
    [self setupBackground];
    
    // 添加新闻分组栏
    [self setupNewsGroupBar];
    
    // 添加新闻分组栏右侧下拉按钮
    [self setupNewsGroupDropdownBtn];
    
    // 添加新闻分组栏下方内容视图
    [self setupContentView];
    
    // 默认选中第一个新闻分组
    [self.newsGroupBar selectIndex:0];
    
    // 5秒后更新newsGroup列表
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateNewsGroupList) userInfo:nil repeats:NO];
}

#pragma mark - 监听方法
- (void)updateNewsGroupList
{
    [NENHttpTool get:@"http://c.m.163.com/nc/topicset/ios/subscribe/manage/listspecial.html" params:nil success:^(NSDictionary *responseObj) {
        NSArray *groupList = responseObj[@"tList"];
        // 将本地列表与最新列表做比对，往本地列表中添加不存在的项
        [groupList enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            __block BOOL found = NO;
            [self.newsGroups enumerateObjectsUsingBlock:^(NENNewsGroup *newsGroup, NSUInteger idx, BOOL *stop) {
                if ([newsGroup.tid isEqualToString:dict[@"tid"]]) {
                    *stop = YES;
                    found = YES;
                }
            }];
            if (!found) {
                NENNewsGroup *newsGroup = [[NENNewsGroup alloc] init];
                newsGroup.tid = dict[@"tid"];
                newsGroup.title = dict[@"tname"];
                newsGroup.type = NENNewsGroupTypeBottom;
                [self.newsGroups addObject:newsGroup];
            }
        }];
        // 刷新listView
        self.newsGroupDropdownListView.newsGroups = self.newsGroups;
        // 保存本地列表
        [NENNewsGroupTool saveNewsGroups:self.newsGroups];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 初始化方法
/**
 *  设置背景
 */
- (void)setupBackground
{
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView *backImage = [[UIImageView alloc] init];
    backImage.image = [UIImage imageNamed:@"photoview_image_default_white"];
    backImage.contentMode = UIViewContentModeCenter;
    backImage.frame = CGRectMake(0, 0, kNENScreenW, kNENScreenH);
    [self.view addSubview:backImage];
}

/**
 *  添加新闻分组栏
 */
- (void)setupNewsGroupBar
{
    NENNewsGroupBar *newsGroupBar = [NENNewsGroupBar bar];
    newsGroupBar.frame = CGRectMake(0, 64, kNENScreenW, kNENNewsGroupBarH);
    newsGroupBar.delegate = self;
    newsGroupBar.contentInset = UIEdgeInsetsMake(0, 0, 0, kNENNewsGroupDropdownBtnW);
    newsGroupBar.newsGroups = self.topNewsGroups;
    
    [self.view addSubview:newsGroupBar];
    self.newsGroupBar = newsGroupBar;
}

/**
 *  添加新闻分组栏右侧下拉按钮
 */
- (void)setupNewsGroupDropdownBtn
{
    NENNewsGroupDropdownButton *btn = [NENNewsGroupDropdownButton button];
    btn.frame = CGRectMake(kNENScreenW - kNENNewsGroupDropdownBtnW, 64, kNENNewsGroupDropdownBtnW, kNENNewsGroupBarH);
    btn.onClick = ^{
        // 编辑标题栏还原为“非编辑状态”
        self.newsGroupEditBar.editing = NO;
        
        // 隐藏/显示编辑标题栏
        self.newsGroupEditBar.hidden = !self.newsGroupEditBar.hidden;
        // 隐藏/显示底部标签栏
        self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
        
        // 隐藏/显示编辑列表栏
        [UIView animateWithDuration:0.3 animations:^{
            if (self.newsGroupDropdownListView.y > 0) {
                self.newsGroupDropdownListView.transform = CGAffineTransformMakeTranslation(0, -kNENNewsGroupDropdownListViewH);
            } else {
                self.newsGroupDropdownListView.transform = CGAffineTransformMakeTranslation(0, kNENNewsGroupDropdownListViewH);
            }
        }];

    };
    [self.view addSubview:btn];
    self.newsGroupDropdownBtn = btn;
}

/**
 *  添加新闻分组栏下方内容视图
 */
- (void)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.delegate = self;
    
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.newsGroupBar.frame);
    CGFloat w = kNENScreenW;
    CGFloat h = kNENScreenH - y;
    contentView.frame = CGRectMake(x, y, w, h);
    contentView.backgroundColor = [UIColor clearColor];
    contentView.delegate = self;
    contentView.contentSize = CGSizeMake(self.topNewsGroups.count * w, h);
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    
    // 将内容视图插到视图层次结构背景层上面
    [self.view insertSubview:contentView atIndex:1];
    self.contentView = contentView;
}


#pragma mark - NENNewsGroupBarDelegate
- (void)newsGroupBar:(NENNewsGroupBar *)bar didSelectTitle:(NSString *)title
{
    __block NSUInteger index = 0;
    [self.topNewsGroups enumerateObjectsUsingBlock:^(NENNewsGroup *newsGroup, NSUInteger idx, BOOL *stop) {
        if ([newsGroup.title isEqualToString:title]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    NENNewsContentController *contentVC = self.contentVCs[title];
    if (!contentVC) {
        contentVC = [[NENNewsContentController alloc] init];
        contentVC.newsGroup = self.newsGroups[index];
        contentVC.newsVC = self;
        contentVC.view.frame = CGRectMake(index * self.contentView.width, 0, self.contentView.width, self.contentView.height);
        [self.contentVCs setObject:contentVC forKey:title];
        [self.contentView addSubview:contentVC.view];
    }
    
    [self.contentView setContentOffset:CGPointMake(index * kNENScreenW, 0) animated:NO];
    [self.newsGroupDropdownListView selectItem:title];
}

- (void)newsGroupBar:(NENNewsGroupBar *)bar didAddNewsGroup:(NENNewsGroup *)newsGroup
{
    // 增加contentView的contentSize
    CGSize contentSize = self.contentView.contentSize;
    contentSize.width += self.contentView.width;
    self.contentView.contentSize = contentSize;
}

- (void)newsGroupBar:(NENNewsGroupBar *)bar didDeleteNewsGroup:(NENNewsGroup *)newsGroup selected:(BOOL)selected
{
    // 减少contentView的contentSize
    CGSize contentSize = self.contentView.contentSize;
    contentSize.width -= self.contentView.width;
    self.contentView.contentSize = contentSize;
    
    // 如果被删除的新闻分组正在显示，则需要将它删除
    NSString *title = newsGroup.title;
    NENNewsContentController *contentVC = self.contentVCs[title];
    if (selected) {
        [contentVC.view removeFromSuperview];
        [self.contentVCs removeObjectForKey:title];
    }
    
    // 调整已加载到contentView上的子view的位置
    [self.contentVCs enumerateKeysAndObjectsUsingBlock:^(NSString *title, NENNewsContentController *contentVC, BOOL *stop) {
        NENNewsGroup *newsGroup = contentVC.newsGroup;
        NSUInteger index = [self.newsGroups indexOfObject:newsGroup];
        contentVC.view.x = index * self.contentView.width;
    }];
}

- (void)newsGroupBarDidExchange:(NENNewsGroupBar *)bar
{
    // 调整已加载到contentView上的子view的位置
    [self.contentVCs enumerateKeysAndObjectsUsingBlock:^(NSString *title, NENNewsContentController *contentVC, BOOL *stop) {
        NENNewsGroup *newsGroup = contentVC.newsGroup;
        NSUInteger index = [self.newsGroups indexOfObject:newsGroup];
        contentVC.view.x = index * self.contentView.width;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contentView) {
        CGFloat offsetScale = self.contentView.contentOffset.x / self.contentView.width;
        if (offsetScale < 0 || offsetScale > self.newsGroups.count) {
            return;
        }
        
        [self.newsGroupBar scrollToScale:offsetScale];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentView) {
        CGFloat offsetScale = self.contentView.contentOffset.x / self.contentView.width;
        if (offsetScale < 0) {
            return;
        }
        
        NSUInteger curIndex = (NSUInteger)offsetScale;
        [self.newsGroupBar selectIndex:curIndex];
    }
}

#pragma mark - 属性方法
- (NSArray *)topNewsGroups
{
    NSMutableArray *topNewsGroups = [NSMutableArray array];
    [self.newsGroups enumerateObjectsUsingBlock:^(NENNewsGroup *newsGroup, NSUInteger idx, BOOL *stop) {
        if (newsGroup.type == NENNewsGroupTypeTop) {
            [topNewsGroups addObject:newsGroup];
        }
    }];
    return topNewsGroups;
}

@end
