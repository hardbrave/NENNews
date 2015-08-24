//
//  NENNewsCommentController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/17.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsCommentController.h"
#import "NENNewsCommentSectionView.h"
#import "NENNewsNormalComment.h"
#import "NENNewsHotComment.h"
#import "NENHttpTool.h"
#import "NENNewsPost.h"
#import "NENNewsPostFrame.h"
#import "NENNewsPostCell.h"
#import "NENNewsViewController.h"
#import "NENNewsContent.h"

@interface NENNewsCommentController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *normalPostFrames;
@property (nonatomic, copy) NSArray *hotPostFrames;
@end

@implementation NENNewsCommentController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionHeaderHeight = 44;
    // 取消分割线（由每个cell自绘）
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
#if 0
    NSData *data2 = [NSData dataWithContentsOfFile:@"/Users/qianli/Desktop/fakePost.dat"];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingMutableContainers error:nil];
    NENNewsNormalComment *newsComment = [NENNewsNormalComment normalCommentWithDict:dict];
    NSArray *posts = newsComment.newsPosts;
    self.normalPostFrames = [self postFramesWithPosts:posts];
    [self.tableView reloadData];
   
    return;
#endif
    
    [NENHttpTool get:self.hotUrl params:nil success:^(NSDictionary *responseObj) {
        NENNewsHotComment *hotComment = [NENNewsHotComment hotCommentWithDict:responseObj];
        NSArray *posts = hotComment.hotPosts;
        self.hotPostFrames = [self postFramesWithPosts:posts];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"网络错误");
    }];
    
    [NENHttpTool get:self.normalUrl params:nil success:^(NSDictionary *responseObj) {
        NENNewsNormalComment *newsComment = [NENNewsNormalComment normalCommentWithDict:responseObj];
        NSArray *posts = newsComment.newsPosts;
        self.normalPostFrames = [self postFramesWithPosts:posts];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"网络错误");
    }];
    
}

#pragma mark - 监听方法
- (IBAction)btnBtnClick:(UIButton *)sender
{
    [self.newsVC.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotPostFrames.count;
    } else {
        return self.normalPostFrames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    NENNewsPostCell *cell = [NENNewsPostCell cellWithTableView:tableView];
    cell.boardid = self.newsContent.boardid;
    __weak NENNewsCommentController *weakCommentVC = self;
    cell.showAllContentBlock = ^{
        [weakCommentVC.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.showAllFloorBlock = ^(NSString *url){
        [NENHttpTool get:url params:nil success:^(NSDictionary *responseObj) {
            NSDictionary *body = responseObj[@"b"][0];
            NENNewsPost *newsPost = [NENNewsPost newsPostWithListDict:body];
            NENNewsPostFrame *newsPostFrame = [[NENNewsPostFrame alloc] init];
            newsPostFrame.post = newsPost;
            
            if (section == 0) {
                NSMutableArray *hotPostFramesM = [NSMutableArray arrayWithArray:self.hotPostFrames];
                [hotPostFramesM replaceObjectAtIndex:row withObject:newsPostFrame];
                self.hotPostFrames = hotPostFramesM;
            } else {
                NSMutableArray *normalPostFramesM = [NSMutableArray arrayWithArray:self.normalPostFrames];
                [normalPostFramesM replaceObjectAtIndex:row withObject:newsPostFrame];
                self.normalPostFrames = normalPostFramesM;
            }
            
            [weakCommentVC.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^(NSError *error) {
            NSLog(@"网络错误");
        }];
    };
    if (section == 0) {
        cell.postFrame = self.hotPostFrames[row];
    } else {
        cell.postFrame = self.normalPostFrames[row];
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NENNewsCommentSectionView *sectionView = [[NENNewsCommentSectionView alloc] init];
    if (section == 0) {
        sectionView.title = @"最热评论";
    } else if (section == 1) {
        sectionView.title = @"最新评论";
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        return [self.hotPostFrames[row] cellH];
    } else {
        return [self.normalPostFrames[row] cellH];
    }
    
}

#pragma mark - 其他方法
/**
 *  将post数组转换为postFrame数组
 */
- (NSArray *)postFramesWithPosts:(NSArray *)posts
{
    NSMutableArray *normalPostFrames = [NSMutableArray array];
    [posts enumerateObjectsUsingBlock:^(NENNewsPost *post, NSUInteger idx, BOOL *stop) {
        NENNewsPostFrame *postFrame = [[NENNewsPostFrame alloc] init];
        postFrame.post = post;
        [normalPostFrames addObject:postFrame];
    }];
    return normalPostFrames;
}

@end
