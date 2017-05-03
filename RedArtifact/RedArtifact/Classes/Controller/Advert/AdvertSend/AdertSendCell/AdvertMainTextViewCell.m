//
//  AdvertMainTextViewCell.m
//  RedArtifact
//
//  Created by LiLu on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertMainTextViewCell.h"

@implementation AdvertMainTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextView.delegate=self;
//    self.contentTextView.returnKeyType = UIReturnKeySend;
//    self.contentTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
//    self.contentTextView.placeholder = @"输入新消息输入新消息输入新消息输入新消息输入新消息";
//    self.contentTextView.delegate = self;
//    self.contentTextView.backgroundColor = [UIColor clearColor];
//    self.contentTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
//     self.contentTextView.layer.borderWidth = 0.65f;
//     self.contentTextView.layer.cornerRadius = 6.0f;

//    [self.contentTextView scrollRectToVisible:CGRectMake(0, self.contentTextView.contentSize.height-15, self.contentTextView.contentSize.width, 10) animated:YES];
//    self.contentTextView.contentSize
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.textViewBack) {
        self.textViewBack(textView.text);
    }
    NSLog(@"%@",textView.text);
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//
//{    if (![text isEqualToString:@""])
//    
//{
//    
//    _hidenlLabel.hidden = YES;
//    
//}
//    
//    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
//        
//    {
//        
//        _hidenlLabel.hidden = NO;
//        
//    }
//    
//    if (textView.text.length==0) {
//         _hidenlLabel.hidden = NO;
//    }
//    
//    return YES;
//    
//}
@end
