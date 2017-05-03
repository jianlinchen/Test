//
//  AdvertMainTextViewCell.h
//  RedArtifact
//
//  Created by LiLu on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextViewback) (NSString *textStr); //方法为typedef
@interface AdvertMainTextViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *hidenlLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;



@property (copy,nonatomic) TextViewback textViewBack;


@end
