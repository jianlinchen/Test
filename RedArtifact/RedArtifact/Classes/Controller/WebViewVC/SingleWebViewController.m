//
//  SingleWebViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "SingleWebViewController.h"

@interface SingleWebViewController ()
@property (nonatomic,strong) UIWebView *name;
@end
@implementation SingleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singleWebVIew.delegate=self;
    [self.singleWebVIew setScalesPageToFit:YES];
    self.singleWebVIew.backgroundColor = [UIColor whiteColor];
    self.singleWebVIew.opaque = NO;
    [self.singleWebVIew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}
//#pragma  添加动画效果，防止在加载webView的时候，一片空白
//- (void)webViewDidStartLoad:(UIWebView *)webView {
//    NSLog(@"开始加载");
//    [MBProgressHUD showMessag:@"" toView:self.view];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
//    NSLog(@"加载完成");
//}
@end
