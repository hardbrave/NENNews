//
//  NENContentHeader.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/16.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENContentHeader.h"
#import "NENContentHeaderCell.h"
#import "NENNewsAD.h"
#import "UIView+Frame.h"

#define KNENContentCellID       @"headerCell"
#define kNENContentCellSections 100

@interface NENContentHeader () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UICollectionView *collView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation NENContentHeader

#pragma mark - 实例化方法
+ (instancetype)header
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NENContentHeader" owner:nil options:nil] lastObject];
}

#pragma mark - 系统方法
- (void)awakeFromNib
{
    // 注册cell
    [self.collView registerNib:[UINib nibWithNibName:@"NENContentHeaderCell" bundle:nil] forCellWithReuseIdentifier:KNENContentCellID];
}

- (void)setFrame:(CGRect)frame
{
    // 保证collectionView以及内部collectionCell的大小与父控件大小一致
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collView.collectionViewLayout;
    layout.itemSize = CGSizeMake(frame.size.width, frame.size.height - 32);
    
    [super setFrame:frame];
    
}

#pragma mark - 属性方法
- (void)setNewsADs:(NSArray *)newsADs
{
    _newsADs = [newsADs copy];
    
    self.pageControl.hidden = NO;
    self.iconView.hidden = NO;
    self.pageControl.numberOfPages = newsADs.count;
    self.pageControl.currentPage = 0;
    self.titleLabel.text = [newsADs[0] title];
    [self.collView reloadData];
    
    // 将collectionView移动到中间分组（实现无限滚动）
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:kNENContentCellSections * 0.5];
    [self.collView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newsADs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NENContentHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KNENContentCellID forIndexPath:indexPath];
    cell.imageUrl = [self.newsADs[indexPath.item] imgsrc];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kNENContentCellSections;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(contentHeader:didClick:)]) {
        [self.delegate contentHeader:self didClick:indexPath.item];
    }
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index = (NSUInteger)(scrollView.contentOffset.x / scrollView.width + 0.5) % self.newsADs.count;
    self.pageControl.currentPage = index;
    self.titleLabel.text = [self.newsADs[index] title];
}


@end
