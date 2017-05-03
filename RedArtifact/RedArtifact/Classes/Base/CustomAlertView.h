//
//  CustomAlertView.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/24.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewSureDelegate <NSObject>

- (void)sureAcion;
-(void)cancelAcion;
@end

@interface CustomAlertView : UIView

@property (nonatomic, assign) id<AlertViewSureDelegate>delegate;

/*
 * title:提示标题
 * message:提示内容
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;


/*
 * title:提示标题
 * message:提示内容
 * cancelButtonTitle:取消按钮
 * otherButtonTitles:确定。。。。。
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;


- (void)showTarget:(UIViewController *)target;

@end
