//
//  PHBTextView.h
//  测试
//
//  Created by LiLu on 16/8/31.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHBTextView : UITextView
/**
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderColor;
@end
