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
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 保证tableView在状态栏上方
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    // 设置刷新回调
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (!self.newsGroup.url) {
            return;
        }

        NSString *url = [NSString stringWithFormat:@"%@/0-140.html", self.newsGroup.url];
        [NENHttpTool get:url params:nil success:^(NSDictionary *response) {
            NSString *key = [response.keyEnumerator nextObject];
            self.newsContents = [NENNewsContent objectArrayWithKeyValuesArray:response[key]];

            if (self.newsContents.count >= 1) {
                NENNewsContent *newsContent = self.newsContents[0];
                if (newsContent.hasAD && newsContent.hasHead) {
                    NENNewsAD *newsAD = [[NENNewsAD alloc] init];
                    newsAD.title = newsContent.title;
                    newsAD.subtitle = newsContent.subtitle;
                    newsAD.imgsrc = newsContent.imgsrc;
                    newsAD.url = newsContent.skipID;
                    [self.newsAds addObject:newsAD];
                    [self.newsContents removeObject:newsContent];
                        
                    // 请求滚动数据
                    if (self.newsGroup.adUrl) {
                        [NENHttpTool get:[NSString stringWithFormat:@"%@/0-3.html", self.newsGroup.adUrl] params:nil success:^(NSDictionary *response) {
                            NSString *key = [response.keyEnumerator nextObject];
                            NSMutableArray *newsADs = [NENNewsAD objectArrayWithKeyValuesArray:response[key]];
                            [self.newsAds addObjectsFromArray:newsADs];
                            self.contentHeader.newsADs = self.newsAds;
                        } failure:^(NSError *error) {
                            NSLog(@"%@", error);
                        }];
                    } else {
                        self.contentHeader.newsADs = self.newsAds;
                    }
                }
            }


            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [self.tableView.header endRefreshing];
        }];
    }];
    
    [self.tableView.header beginRefreshing];
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
    return 215;
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
