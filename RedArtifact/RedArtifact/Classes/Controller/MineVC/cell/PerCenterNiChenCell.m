//
//  PerCenterNiChenCell.m
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PerCenterNiChenCell.h"

@implementation PerCenterNiChenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.niChenTextField.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.niChenTextField];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    NSLog(@"+++++++++++++++++++++++%@",lang);
    if ([lang isEqualToString:@"zh-Hans"]||[lang isEqualToString:@"zh-Hant"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写zh-Hant（繁体中午）
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 15) {
                textField.text = [toBeString substringToIndex:15];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 15) {
            textField.text = [toBeString substringToIndex:15];
        }
    }
    
    if(self.textFieldBack){
        self.textFieldBack(textField.text);
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.niChenTextField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)post:(NSString *)niChenStr{
    
//    if ([[User sharedInstance].userNmae isEqualToString:niChenStr  ]||niChenStr.length==0) {
//        self.niChenTextField.text=@"";
//        
//    }else{
    self.niChenTextField.text=niChenStr;
    
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(self.textFieldBack){
        self.textFieldBack(textField.text);
    }
}

@end
