//
//  NENNewsContentController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsContentController.h"
#import "NENContentViewCell.h"
#import "NENNewsContent.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "NENHttpTool.h"
#import "NENNewsGroup.h"
#import "NENContentHeader.h"
#import "NENNewsAD.h"
#import "NENNewsContent.h"
#import "NENNewsViewController.h"
#import "NENNewsDetailController.h"
#import "NENNewsPhotosetController.h"
#import "MBProgressHUD+MJ.h"
#import "NENNewsContentTool.h"

@interface NENNewsContentController () <NENContentHeaderDelegate>
@property (nonatomic, strong) NSMutableArray *newsContents;
@property (nonatomic, strong) NSMutableArray *newsAds;
@property (nonatomic, strong) NENContentHeader *contentHeader;
@end

@implementation NENNewsContentController

#pragma mark - 懒加载方法
- (NSMutableArray *)newsAds
{
    if (!_newsAds) {
        self.newsAds = [NSMutableArray array];
    }
    return _newsAds;
}

- (NENContentHeader *)contentHeader
{
    if (!_contentHeader) {
        NENContentHeader *header = [NENContentHeader header];
        header.delegate = self;
        self.contentHeader = header;
    }
    return _contentHeader;
}

#pragma mark - 初始化方法
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    // 去掉tableView顶部空白区域
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    // 去掉tableView底部空白区域
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 保证tableView在状态栏上方
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    // 加载缓存数据
    NSArray *newsContens = [NENNewsContentTool newsContentsWithTid:self.newsGroup.tid];
    self.newsContents = [NENNewsContent objectArrayWithKeyValuesArray:newsContens];
    [self.tableView reloadData];
    
    // 集成上拉刷新
    [self setupUpRefresh];
    
    // 集成下拉刷新
    [self setupDownRefresh];
    
}

#pragma mark - 监听方法
- (void)loadNewData
{
    NSString *url = [NSString stringWithFormat:@"%@/0-20.html", self.newsGroup.url];
    [NENHttpTool get:url params:nil success:^(NSDictionary *response) {
        NSString *key = [response.keyEnumerator nextObject];
        // 缓存数据
        [NENNewsContentTool resetNewsContents:response[key] tid:key];
        self.newsContents = [NENNewsContent objectArrayWithKeyValuesArray:response[key]];
        
        if (self.newsContents.count >= 1 && self.newsGroup.isHeadLine) {
            // 清空已有数据
            [self.newsAds removeAllObjects];
            
            // 取出第一个newsContent对象，并将它转换为一个newsAD对象
            NENNewsContent *newsContent = self.newsContents[0];
            NENNewsAD *newsAD = [[NENNewsAD alloc] init];
            newsAD.title = newsContent.title;
            newsAD.subtitle = newsContent.subtitle;
            newsAD.imgsrc = newsContent.imgsrc;
            newsAD.url = newsContent.skipID;
            [self.newsAds addObject:newsAD];
            [self.newsContents removeObject:newsContent];
                
            // 请求滚动数据
            NSString *url = [NSString stringWithFormat:@"%@/0-3.html", self.newsGroup.adUrl];
            [NENHttpTool get:url params:nil success:^(NSDictionary *response) {
                NSString *key = [response.keyEnumerator nextObject];
                NSMutableArray *newsADs = [NENNewsAD objectArrayWithKeyValuesArray:response[key]];
                [self.newsAds addObjectsFromArray:newsADs];
                self.contentHeader.newsADs = self.newsAds;
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [self.tableView.header endRefreshing];
    }];

}

- (void)loadMoreData
{
    NSString *url = [NSString stringWithFormat:@"%@/%ld-20.html", self.newsGroup.url, self.newsContents.count];
    [NENHttpTool get:url params:nil success:^(NSDictionary *response) {
        NSString *key = [response.keyEnumerator nextObject];
        // 缓存数据
        [NENNewsContentTool saveNewsContents:response[key] tid:key number:20];
        NSMutableArray *newsContents = [NENNewsContent objectArrayWithKeyValuesArray:response[key]];
        // 返回的数据有可能大于20条，只取20条，要不然会导致后续请求请求不到数据
        if (newsContents.count > 20) {
            NSRange range;
            range.location = 19;
            range.length = newsContents.count - 20;
            [newsContents removeObjectsInRange:range];
        }
        
        [self.newsContents addObjectsFromArray:newsContents];
        
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [self.tableView.footer endRefreshing];
    }];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NENNewsContent *newsContent = self.newsContents[indexPath.row];
    NENContentViewCell *cell = [NENContentViewCell cellWithTableView:tableView newsContent:newsContent];
    return cell;
}

#pragma mark - UITableViewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NENNewsContent *newsContent = self.newsContents[indexPath.row];
    return [NENContentViewCell heightForNewsContent:newsContent];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.newsGroup.isHeadLine) {
        return 215;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.contentHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NENNewsContent *newsContent = self.newsContents[indexPath.row];
    if ([newsContent.skipType isEqualToString:@"photoset"]) {
        [self showPhotoSet:[self photoSetUrlWithPhotoId:newsContent.photosetID]];
    } else {
        [self showNewsDetail:indexPath.row];
    }
}

#pragma mark - NENContentHeaderDelegate
- (void)contentHeader:(NENContentHeader *)contentHeader didClick:(NSUInteger)index
{
    NENNewsAD *newsAD = self.newsAds[index];
    [self showPhotoSet:[self photoSetUrlWithPhotoId:newsAD.url]];
}

#pragma mark - 其他方法
- (void)setupUpRefresh
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setupDownRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.header beginRefreshing];
}

- (void)showNewsDetail:(NSUInteger)index
{
    NENNewsDetailController *detailVC = [[NENNewsDetailController alloc] init];
    detailVC.newsVC = self.newsVC;
    detailVC.newsContent = self.newsContents[index];
    [self.newsVC.navigationController pushViewController:detailVC animated:YES];
}

- (void)showPhotoSet:(NSString *)url
{
    NENNewsPhotosetController *phtotsetVC = [[NENNewsPhotosetController alloc] init];
    phtotsetVC.newsVC = self.newsVC;
    phtotsetVC.url = url;
    self.newsVC.hidesBottomBarWhenPushed = YES;
    [self.newsVC.navigationController setNavigationBarHidden:YES];
    [self.newsVC.navigationController pushViewController:phtotsetVC animated:YES];
}

- (NSString *)photoSetUrlWithPhotoId:(NSString *)photosetID
{
    NSArray *photoSetIDs = [[photosetID substringFromIndex:4] componentsSeparatedByString:@"|"];
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json", photoSetIDs[0],photoSetIDs[1]];
    return url;
}

@end
