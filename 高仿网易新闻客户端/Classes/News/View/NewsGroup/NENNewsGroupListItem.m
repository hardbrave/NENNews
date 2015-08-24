//
//  NENNewsGroupListItem.m
//  高仿网易新闻客户端
//
//  Created by qianli on 15/8/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NENNewsGroupListItem.h"
#import "UIView+Frame.h"
#import "NENNewsGroupEditBar.h"
#import "NENNewsConst.h"
#import "NENNewsGroup.h"
#import "CommonDef.h"

@interface NENNewsGroupListItem ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *editinglongPressGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign, getter=isPanEnded) BOOL panEnded;
@end

@implementation NENNewsGroupListItem

#pragma mark - 懒加载方法
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        // 删除图标
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(-5, -5, 16, 16);
        [deleteBtn setImage:[UIImage imageNamed:@"channel_edit_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"night_channel_edit_delete"] forState:(UIControlStateHighlighted)];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.hidden = YES;
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return _deleteBtn;
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(btnLongPress:)];
        longPressGesture.minimumPressDuration = 0.5;
        longPressGesture.delegate = self;
        _longPressGesture = longPressGesture;
    }
    return _longPressGesture;
}

- (UILongPressGestureRecognizer *)editinglongPressGesture
{
    if (!_editinglongPressGesture) {
        UILongPressGestureRecognizer *editinglongPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self action:@selector(editingBtnLongPress:)];
        editinglongPressGesture.minimumPressDuration = 0.2;
        editinglongPressGesture.delegate = self;
        _editinglongPressGesture = editinglongPressGesture;
    }
    return _editinglongPressGesture;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btnPan:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置按钮基本属性
        self.layer.cornerRadius = 6;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        // 默认处于非编辑状态
        self.editing = NO;
        
#warning 长按手势通过此属性来判断有没有拖动手势与其一起作用（这种方式感觉不太好，后续看是否能优化！）
        // 默认没有拖动
        self.panEnded = NO;
        
        // 添加点击操作
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 监听广播消息
        [NENNotificationCenter addObserver:self selector:@selector(onEditBarNotification:) name:kNENNewsGroupEditBarNotification object:nil];
        [NENNotificationCenter addObserver:self selector:@selector(onLongPressNotification) name:kNENNewsGroupListItemLongPressNotification object:nil];
    }
    return self;
}

#pragma mark - 实例方法
+ (instancetype)listItem
{
    return [[self alloc] init];
}

#pragma mark - 系统方法
- (void)dealloc
{
    [NENNotificationCenter removeObserver:self];
}

- (void)setSelected:(BOOL)selected
{
    // 下部区域的按钮没有选中状态
    if (self.newsGroup.type == NENNewsGroupTypeTop) {
        [super setSelected:selected];
    }
}

#pragma mark - 属性方法
- (void)setNewsGroup:(NENNewsGroup *)newsGroup
{
    _newsGroup = newsGroup;
    
    [self setTitle:newsGroup.title forState:UIControlStateNormal];
    [self configureGesturesAndDeleteBtn];
}

- (void)setEditEnabled:(BOOL)editEnabled
{
    _editEnabled = editEnabled;
    
    if (!editEnabled) {
        self.layer.borderWidth = 0;
    } else {
        self.layer.borderWidth = 2;
    }
}

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    [self configureGesturesAndDeleteBtn];
}

#pragma mark - 其它方法
- (void)configureGesturesAndDeleteBtn
{
    // 首先清除可能存在的手势
    [self removeGestureRecognizer:self.panGesture];
    [self removeGestureRecognizer:self.longPressGesture];
    [self removeGestureRecognizer:self.editinglongPressGesture];
    
    if (self.newsGroup.type == NENNewsGroupTypeTop) {
        if (self.isEditEnabled) {
            if (self.isEditing) {
                /**
                 *  如果是可编辑，并且处于编辑状态
                 *  则为按钮添加拖动手势、编辑长按手势（实现“点击变大”功能）
                 *  显示左上角删除按钮
                 */
                [self addGestureRecognizer:self.panGesture];
                [self addGestureRecognizer:self.editinglongPressGesture];
                self.deleteBtn.hidden = NO;
            } else {    //
                /**
                 *  如果是可编辑，并且处于非可编辑状态
                 *  则为按钮添加长按手势（实现“长按进入可编辑状态”功能）
                 *  隐藏左上角删除按钮
                 */
                [self addGestureRecognizer:self.longPressGesture];
                self.deleteBtn.hidden = YES;
            }
        } else {
            // 处于不可编辑状态，则左上角删除按钮一直隐藏
            self.deleteBtn.hidden = YES;
        }
    } else if (self.newsGroup.type == NENNewsGroupTypeBottom) {
        self.deleteBtn.hidden = YES;
    }
}

#pragma mark - 监听方法
- (void)btnClick
{
    if (self.newsGroup.type == NENNewsGroupTypeTop) {
        if (self.isEditing) {
            
        } else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            userInfo[kNENNewsGroupListItemSelectKey] = self.newsGroup;
            [NENNotificationCenter postNotificationName:kNENNewsGroupListItemDidSelectNotification object:self userInfo:userInfo];
            
        }
    } else if (self.newsGroup.type == NENNewsGroupTypeBottom) {
        if ([self.delegate respondsToSelector:@selector(newsGroupListItemAdd:)]) {
            [self.delegate newsGroupListItemAdd:self];
        };
    }
}

- (void)deleteBtnClick
{
    if (self.newsGroup.type == NENNewsGroupTypeTop) {
        if (self.isEditing) {
            if ([self.delegate respondsToSelector:@selector(newsGroupListItemDelete:)]) {
                [self.delegate newsGroupListItemDelete:self];
            }
        }
    }
}

- (void)btnLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (self.newsGroup.type == NENNewsGroupTypeTop) {
        if (!self.isEditing) {
            [NENNotificationCenter postNotificationName:kNENNewsGroupListItemLongPressNotification object:self];
        }
    }
}

- (void)editingBtnLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    if (self.newsGroup.type == NENNewsGroupTypeTop) {
        if (self.isEditing) {
            switch (longPressGesture.state) {
                case UIGestureRecognizerStateBegan:
                    self.frame = CGRectMake(self.x - 5, self.y - 5, self.width + 10, self.height + 10);
                    break;
                case UIGestureRecognizerStateEnded:
                    if (!self.isPanEnded) {
                        self.frame = CGRectMake(self.x + 5, self.y + 5, self.width - 10, self.height - 10);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)btnPan:(UIPanGestureRecognizer *)panGesture
{
    // 将当前按钮移至所有其它按钮的最前面
    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self]
                        withSubviewAtIndex:(self.superview.subviews.count - 1)];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.panEnded = NO;
            break;
        case UIGestureRecognizerStateChanged: {
            // 移动按钮
            CGPoint translation = [panGesture translationInView:self];
            self.centerX = self.centerX + translation.x;
            self.centerY = self.centerY + translation.y;
            [panGesture setTranslation:CGPointZero inView:self];
            
            // 通知代理按钮正在移动
            if ([self.delegate respondsToSelector:@selector(newsGroupListItemDidMove:)]) {
                [self.delegate newsGroupListItemDidMove:self];
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // 通知代理按钮移动完毕
            if ([self.delegate respondsToSelector:@selector(newsGroupListItemDidEndMoving:)]) {
                [self.delegate newsGroupListItemDidEndMoving:self];
            }
            self.panEnded = YES;
            break;
        }
        default:
            break;
    }
}

- (void)onEditBarNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    self.editing = [userInfo[kNENNewsGroupEditBarIsEditing] boolValue];
}

- (void)onLongPressNotification
{
    self.editing = YES;
}

#pragma mark - UIGestureRecognizerDelegate
// 同时响应长按手势和拖动手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
