//
//  CustomAlertView.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "CustomAlertView.h"

const static CGFloat kCustomAlertViewDefaultContainerWidth     = 268;
const static CGFloat kCustomAlertViewDefaultContainerHeight    = 150;
const static CGFloat kCustomAlertViewDefaultButtonHeight       = 50;

@interface CustomAlertView ()
{
    BOOL _isHaveButton;
}

@end

@implementation CustomAlertView

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        coverView.backgroundColor = [UIColor colorWithHex:0x333333 alpha:0.3];
        [self insertSubview:coverView atIndex:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [coverView addGestureRecognizer:tap];
    }
    return self;
}

/*
 * title:提示标题
 * message:提示内容
 * cancelButtonTitle:取消按钮
 * otherButtonTitles:确定。。。。。
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    self = [self init];
    [self buildWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    return self;
}

/*
 * title:提示标题
 * message:提示内容
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message  {
    self = [self init];
    [self buildWithTitle:title message:message];
    return self;
}


- (void)buildWithTitle:(NSString *)title message:(NSString *)message {
    CGFloat width = kCustomAlertViewDefaultContainerWidth;
    CGFloat height = kCustomAlertViewDefaultContainerHeight;
    CGFloat x = (UIScreenWidth - width)/2;
    CGFloat y = (UIScreenHeight - height)/2;
    CGFloat top = 0;
    
    //提示框view
    UIView *containerView = [[UIView  alloc] initWithFrame:CGRectMake(x, y, width, height)];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.masksToBounds = YES;
    containerView.layer.cornerRadius = 5.0f;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, 50)];
    titleLabel.backgroundColor = [UIColor colorWithHex:0xdb413c];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithHex:0xffffff];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [containerView addSubview:titleLabel];
    
    top = 50;
    
    //提示内容
    UILabel *contentLabel = [[UILabel alloc] init];
    
    contentLabel.frame = CGRectMake(0, top, width, height - top);
    contentLabel.text = message;
    contentLabel.textColor = [UIColor colorWithHex:0x333333];
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    contentLabel.numberOfLines = 0;
    [containerView addSubview:contentLabel];
    
    [self addSubview:containerView];
}


- (void)buildWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles {
    _isHaveButton = YES;
    CGFloat width = kCustomAlertViewDefaultContainerWidth;
    CGFloat height = kCustomAlertViewDefaultContainerHeight;
    CGFloat x = (UIScreenWidth - width)/2;
    CGFloat y = (UIScreenHeight - height)/2;
    CGFloat top = 0;
    
    //提示框view
    UIView *containerView = [[UIView  alloc] initWithFrame:CGRectMake(x, y, width, height)];
    containerView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    containerView.layer.masksToBounds = YES;
    containerView.layer.cornerRadius = 5.0f;
    
    //红色View
    UIView *redView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    redView.backgroundColor = [UIColor colorWithHex:0xdb413c];
    [containerView addSubview:redView];
    
    top = 30;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, 20)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithHex:0xffffff];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [containerView addSubview:titleLabel];

    top = 50;

    //提示内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(0, top, width, 20);
    contentLabel.text = message;
    contentLabel.textColor = [UIColor colorWithHex:0xffffff];
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    contentLabel.numberOfLines = 0;
    [containerView addSubview:contentLabel];

    top = height - kCustomAlertViewDefaultButtonHeight;

    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake(-1, top, width/2, kCustomAlertViewDefaultButtonHeight);
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cancelButton];
    
    //确定按钮
    UIButton *sureButton = [[UIButton alloc] init];
    sureButton.frame = CGRectMake(width/2, top, width/2, kCustomAlertViewDefaultButtonHeight);
    [sureButton setTitle:otherButtonTitles forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithHex:0xdb413c] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    sureButton.backgroundColor = [UIColor whiteColor];
    [sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:sureButton];
    
    [self addSubview:containerView];
    
}

- (void)cancelAction {
    [self removeFromSuperview];
}

- (void)sureAction {
    if (self.delegate) {
//         [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrLocation];
        [self.delegate sureAcion];
        [self removeFromSuperview];
    }
}
- (void)cancelAcion {
    if (self.delegate) {
        [self.delegate cancelAcion];
        [self removeFromSuperview];
//         [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrLocation];
    }
}

#pragma mark - 点击其他地方移除提示框
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (!_isHaveButton) {
        [self removeFromSuperview];
    }
    
}

- (void)showTarget:(UIViewController *)target {
    [target.view.window addSubview:self];
}

@end
