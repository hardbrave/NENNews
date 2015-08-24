//
//  NENNewsGroupEditBar.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupEditBar.h"
#import "NENNewsGroupEditButton.h"
#import "UIView+Frame.h"
#import "NENNewsGroupListItem.h"
#import "NENNewsConst.h"
#import "CommonDef.h"

@interface NENNewsGroupEditBar ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NENNewsGroupEditButton *editBtn;
@end

@implementation NENNewsGroupEditBar

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色
        self.backgroundColor = [UIColor whiteColor];
        
        // 左侧标签
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 30)];
        title.text = @"切换栏目";
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        [self addSubview:title];
        self.title = title;
        
        // 右侧按钮
        NENNewsGroupEditButton *editBtn = [NENNewsGroupEditButton buttonWithTitle:@"排序删除"];
        editBtn.frame = CGRectMake(0, 5, 60, 30);
        [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editBtn];
        self.editBtn = editBtn;
        
        // 默认处于非编辑状态
        self.editing = NO;
        
        // 接收新闻分组下拉列表中按钮的长按通知
        [NENNotificationCenter addObserver:self selector:@selector(onListItemLongPress) name:kNENNewsGroupListItemLongPressNotification object:nil];
       
        
    }
    return self;
}

#pragma mark - 实例化方法
+ (instancetype)bar
{
    return [[self alloc] init];
}

#pragma mark - 监听方法
- (void)editBtnClick
{
    self.editing = !self.editing;
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    if (editing) {
        self.title.text = @"拖动排序";
        self.editBtn.title = @"完成";
    } else {
        self.title.text = @"切换栏目";
        self.editBtn.title = @"排序删除";
    }
    [NENNotificationCenter postNotificationName:kNENNewsGroupEditBarNotification
                                                        object:self
                                                      userInfo:@{kNENNewsGroupEditBarIsEditing: @(editing)}];
}

- (void)onListItemLongPress
{
    self.editing = YES;
    self.title.text = @"拖动排序";
    self.editBtn.title = @"完成";
}

#pragma mark - 系统方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置右侧按钮位置
    self.editBtn.x = self.width - self.editBtn.width;
}

- (void)dealloc
{
    [NENNotificationCenter removeObserver:self];
}


@end
