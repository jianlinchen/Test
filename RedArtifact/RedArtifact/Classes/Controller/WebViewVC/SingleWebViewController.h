//
//  SingleWebViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SingleWebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *singleWebVIew;
@property (nonatomic,strong) NSString *webUrl;
@end
