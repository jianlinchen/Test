//
//  LoginViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showNoDataViewWithString:@"请重新加载" andImage:nil];
    
}
-(void)againRequest{
    [super againRequest];
    NSLog(@"点击手势了");
}
@end
