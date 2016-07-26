//
//  BaseViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void)againRequest;
- (void)showNoDataViewWithString:(NSString *)str andImage:(UIImage *)image;
- (void)removeNoDataView;

@end
