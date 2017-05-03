//
//  StoreAddressViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/14.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "StoreAddressViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件


@interface StoreAddressViewController () <BMKMapViewDelegate>
{
    BMKMapView *_mapView;
}

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation StoreAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家地址";
    
    self.addressLabel.text = self.advert.contact_address;
    
    [self setupMapView];
}

- (void)setupMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 65)];
    
    //使用3D楼宇
    [_mapView setBuildingsEnabled:YES];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    float a = [self.advert.contact_lat floatValue] ? [self.advert.contact_lat floatValue] : 39.912565;
    float b = [self.advert.contact_lng floatValue] ? [self.advert.contact_lng floatValue] : 116.43459;
    
    CLLocationCoordinate2D coor;
    coor.latitude = a;
    coor.longitude = b;
    
    annotation.coordinate = coor;
    annotation.title = self.advert.contact_address;
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.6,0.6));
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    
    _mapView.zoomLevel = 15.0;
    
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:coor radius:1000];
    [_mapView addOverlay:circle];
    [_mapView addAnnotation:annotation];
    
    [self.view insertSubview:_mapView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;
        return newAnnotationView;
    }
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        circleView.lineWidth = 2.0;
        return circleView;
    }
    return nil;
}

@end
