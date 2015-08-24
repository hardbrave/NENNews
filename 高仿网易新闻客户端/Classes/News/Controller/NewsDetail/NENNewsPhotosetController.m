//
//  NENNewsPhotosetController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/17.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsPhotosetController.h"
#import "NENNewsViewController.h"
#import "UIView+Frame.h"
#import "NENHttpTool.h"
#import "NENPhotoDetail.h"
#import "NENPhotoSet.h"
#import "MJExtension.h"
#import "NENNewsPhotosetCell.h"
#import "NSString+reply.h"
#import "NENNewsContent.h"
#import "NENNewsCommentController.h"
#import "MBProgressHUD+MJ.h"

#define KNENNewsPhotosetCellID       @"photosetCell"

@interface NENNewsPhotosetController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collView;
@property (nonatomic, strong) NENPhotoSet *photoset;
@end

@implementation NENNewsPhotosetController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collView.collectionViewLayout;
    layout.itemSize = self.collView.size;
    
    [self.collView registerNib:[UINib nibWithNibName:@"NENNewsPhotosetCell" bundle:nil] forCellWithReuseIdentifier:KNENNewsPhotosetCellID];
    
    // 请求图片数据
    [NENHttpTool get:self.url params:nil success:^(NSDictionary *dict) {
        self.photoset = [NENPhotoSet objectWithKeyValues:dict];
        [self setupTitleViewWithIndex:0];
        [self.collView reloadData];
        // 请求跟帖人数
        NSString *replyUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/thread/total/photoview_bbs/%@", self.photoset.postid];
        [NENHttpTool get:replyUrl params:nil success:^(NSDictionary *responseObj) {
            CGFloat replyCount = [responseObj[@"votecount"] floatValue];
            // 设置跟帖人数
            NSString *replyString = [NSString replyString:replyCount];
            if (replyString) {
                self.replyLabel.hidden = NO;
                self.replyBtn.hidden = NO;
                self.replyLabel.text = replyString;
            } else {
                self.replyLabel.hidden = YES;
                self.replyBtn.hidden = YES;
            }

        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误"];
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.newsVC.tabBarController.tabBar.hidden = YES;
    [self.newsVC.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    [self setupTitleViewWithIndex:index];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoset.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NENNewsPhotosetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KNENNewsPhotosetCellID forIndexPath:indexPath];
    cell.imageUrl = [self.photoset.photos[indexPath.item] imgurl];
    return cell;
}


#pragma mark - 监听方法
- (IBAction)backBtnClick:(id)sender
{
    [self.newsVC.navigationController popViewControllerAnimated:YES];
    [self.newsVC.navigationController setNavigationBarHidden:NO];
    self.newsVC.tabBarController.tabBar.hidden = NO;
}

- (IBAction)replyBtnClick:(id)sender
{
    NSString *hotUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/photoview_bbs/%@/0/10/10/2/2",self.photoset.postid];
    NSString *normalUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/normal/photoview_bbs/%@/desc/0/10/10/2/2", self.self.photoset.postid];
#warning 此处未设置newsContent！！
    NENNewsCommentController *replyVC = [[NENNewsCommentController alloc] init];
    replyVC.newsVC = self.newsVC;
    replyVC.normalUrl = normalUrl;
    replyVC.hotUrl = hotUrl;
    [self.newsVC.navigationController pushViewController:replyVC animated:YES];
    
}


#pragma make - 其他方法
- (void)setupTitleViewWithIndex:(NSUInteger)index
{
    self.titleLabel.text = self.photoset.setname;
    if (index < self.photoset.photos.count) {
        self.subtitleLabel.text = [self.photoset.photos[index] imgtitle];
        NSAttributedString *pageCount = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.photoset.photos.count] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
        NSMutableAttributedString *pageText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/", index+1]];
        [pageText appendAttributedString:pageCount];
        self.pageLabel.attributedText = pageText;
    }
}

@end
