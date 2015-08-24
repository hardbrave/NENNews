//
//  NENTabBarController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENTabBarController.h"
#import "NENNewsViewController.h"
#import "NENReaderViewController.h"
#import "NENMediaViewController.h"
#import "NENDiscoverViewController.h"
#import "NENProfileViewContrller.h"
#import "NENNavigationController.h"

@interface NENTabBarController ()

@end

@implementation NENTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 初始化子控制器
    NENNewsViewController *newsVC = [[NENNewsViewController alloc] init];
    [self addChildViewController:newsVC withTitle:@"新闻" image:@"tabbar_icon_news_normal" selectedImage:@"tabbar_icon_news_highlight"];
    
    NENReaderViewController *readerVC = [[NENReaderViewController alloc] init];
    [self addChildViewController:readerVC withTitle:@"阅读" image:@"tabbar_icon_reader_normal" selectedImage:@"tabbar_icon_reader_highlight"];
    
    NENMediaViewController *mediaVC = [[NENMediaViewController alloc] init];
    [self addChildViewController:mediaVC withTitle:@"视听" image:@"tabbar_icon_media_normal" selectedImage:@"tabbar_icon_media_highlight"];
    
    NENDiscoverViewController *discoverVC = [[NENDiscoverViewController alloc] init];
    [self addChildViewController:discoverVC withTitle:@"发现" image:@"tabbar_icon_found_normal" selectedImage:@"tabbar_icon_found_highlight"];
    
    NENProfileViewContrller *profileVC = [[NENProfileViewContrller alloc] init];
    [self addChildViewController:profileVC withTitle:@"我" image:@"tabbar_icon_me_normal" selectedImage:@"tabbar_icon_me_highlight"];

}

- (void)addChildViewController:(UIViewController *)childVC withTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器标题
    childVC.title = title;
    
    // 设置子控制器对应tabBar的图片
    childVC.tabBarItem.image = [UIImage imageNamed:image];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置子控制器对应tabBar的文字属性
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    textAttribute[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childVC.tabBarItem setTitleTextAttributes:textAttribute forState:UIControlStateNormal];
    
    // 设置子控制器对应tabBar的选中文字属性
    NSMutableDictionary *selectedTextAttribute = [NSMutableDictionary dictionary];
    selectedTextAttribute[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedTextAttribute[NSForegroundColorAttributeName] = [UIColor redColor];
    [childVC.tabBarItem setTitleTextAttributes:selectedTextAttribute forState:UIControlStateSelected];
    
    // 用自定义的导航控制器封装子控制器
    NENNavigationController *navVC = [[NENNavigationController alloc] initWithRootViewController:childVC];
    
    // 添加子控制器
    [self addChildViewController:navVC];

}


@end
