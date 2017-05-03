//
//  PerTrajectoryController.m
//  RedArtifact
//
//  Created by LiLu on 16/11/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PerTrajectoryController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
@interface PerTrajectoryController () <BMKMapViewDelegate>
{
    BMKMapView *perTrajectMapView;
}


@end

@implementation PerTrajectoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end
