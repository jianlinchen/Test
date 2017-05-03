//
//  BaseViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "CustomAlertView.h"
@interface BaseViewController : UIViewController
//@property (nonatomic, strong) MJRefreshGifHeader *header;
@property (nonatomic, strong)MJRefreshNormalHeader *header;
-(void)againRequest;
- (void)showNoDataViewWithString:(NSString *)str andImage:(UIImage *)image;
- (void)removeNoDataView;
- (void)loadNewData;
-(void)goVC;
- (void)showUnauthorizedView:(NSString *)str andImage:(UIImage *)image andBool:(BOOL)isEnable;
@end
