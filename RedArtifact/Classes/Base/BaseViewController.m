//
//  BaseViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController(){
      UIView *noDataView;
}
@end
@implementation BaseViewController
- (void)showNoDataViewWithString:(NSString *)str andImage:(UIImage *)image{
    noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, APP_W, APP_H-64)];
    noDataView.backgroundColor = [UIColor blueColor];
    [noDataView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againRequest)]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, APP_W, 21)];
    label.textAlignment = NSTextAlignmentCenter;
    if(str == nil){
        label.text = @"";
    }else{
        label.text = str;
    }
    label.font = [UIFont systemFontOfSize:15.0f];
    [noDataView addSubview:label];
    
    [self.view addSubview:noDataView];
    [self.view bringSubviewToFront:noDataView];
}
- (void)removeNoDataView{
  
    [noDataView removeFromSuperview];
}
-(void)againRequest{
    
}
@end
