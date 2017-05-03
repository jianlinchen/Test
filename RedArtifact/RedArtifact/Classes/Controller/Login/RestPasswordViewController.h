//
//  RestPasswordViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/8/22.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *identifyTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)getIdentifyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *identifyButton;

- (IBAction)cirAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cirButton;


@end
