//
//  NENNewsDetailController.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/17.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NENNewsDetailController.h"
#import "NENNewsViewController.h"
#import "NENHttpTool.h"
#import "NENNewsDetail.h"
#import "NENNewsDetailImg.h"
#import "MJExtension.h"
#import "CommonDef.h"
#import "NENNewsCommentController.h"
#import "NENNewsContent.h"
#import "NSString+reply.h"

@interface NENNewsDetailController ()
@property (nonatomic, weak) IBOutlet UILabel *replyLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIButton *replyBtn;
@property (nonatomic, strong) NENNewsDetail *newsDetail;
@property (nonatomic, assign) CGFloat replyCount;
@end

@implementation NENNewsDetailController

#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 发送请求加载页面
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.newsContent.docid];
    [NENHttpTool get:url params:nil success:^(NSDictionary *response) {
        NSString *key = [response.keyEnumerator nextObject];
        self.newsDetail = [NENNewsDetail objectWithKeyValues:response[key]];
        [self.webView loadHTMLString:[self htmlString] baseURL:nil];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

    
    // 设置跟帖人数
    NSString *replyString = [NSString replyString:[self.newsContent.replyCount floatValue]];
    if (replyString) {
        self.replyLabel.hidden = NO;
        self.replyBtn.hidden = NO;
        self.replyLabel.text = replyString;
    } else {
        self.replyLabel.hidden = YES;
        self.replyBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.newsVC.tabBarController.tabBar.hidden = YES;
    [self.newsVC.navigationController setNavigationBarHidden:YES animated:YES];
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
    NSString *hotUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2",self.newsContent.boardid, self.newsContent.docid];
    NSString *normalUrl = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/normal/%@/%@/desc/0/10/10/2/2",self.newsContent.boardid, self.newsContent.docid];
    NENNewsCommentController *replyVC = [[NENNewsCommentController alloc] init];
    replyVC.newsVC = self.newsVC;
    replyVC.newsContent = self.newsContent;
    replyVC.normalUrl = normalUrl;
    replyVC.hotUrl = hotUrl;
    [self.newsVC.navigationController pushViewController:replyVC animated:YES];
}

#pragma mark - 私有方法
- (NSString *)htmlString
{
    NSMutableString *htmlstring = [NSMutableString string];
    [htmlstring appendString:@"<html>"];
    
    [htmlstring appendString:@"<head>"];
    NSURL *cssUri = [[NSBundle mainBundle] URLForResource:@"NENNewsDetail" withExtension:@"css"];
    [htmlstring appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",cssUri];
    [htmlstring appendString:@"</head>"];
    
    [htmlstring appendString:@"<body>"];
    [htmlstring appendString:[self bodyString]];
    [htmlstring appendString:@"</body>"];
    
    [htmlstring appendString:@"</html>"];
    
    return htmlstring;
}

- (NSString *)bodyString
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.newsDetail.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.newsDetail.ptime];
    if (self.newsDetail.body != nil) {
        [body appendString:self.newsDetail.body];
    }
    // 遍历图片数组
    [self.newsDetail.img enumerateObjectsUsingBlock:^(NENNewsDetailImg *detailImg, NSUInteger idx, BOOL *stop) {
        NSMutableString *image = [NSMutableString string];
        
        [image appendString:@"<div class=\"image\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImg.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject] floatValue];
        CGFloat height = [[pixel lastObject] floatValue];
        
        // 判断是否超过最大宽度
        CGFloat maxWidth = kNENScreenW * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        [image appendFormat:@"<img width=\"%f\" height=\"%f\" src=\"%@\">", width, height, detailImg.src];
        
        [image appendString:@"</div>"];
        
        // 替换标记
        [body replaceOccurrencesOfString:detailImg.ref withString:image options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
        
    }];
    return body;
}


@end
