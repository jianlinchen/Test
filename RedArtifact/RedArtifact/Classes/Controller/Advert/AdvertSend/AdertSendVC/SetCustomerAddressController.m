//
//  SetCustomerAddressController.m
//  RedArtifact
//
//  Created by LiLu on 16/10/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "SetCustomerAddressController.h"
#import "MapLocation.h"
#import "PoiAddressViewController.h"
@interface SetCustomerAddressController (){
    BMKMapView *selectMapView;
    UIView *circleview;
    
    CLLocationCoordinate2D gloabarCenterPt;//中心点坐标
    NSString *addressStr;//反编译地址信息
    BMKMapStatus *status;
//  BMKPoiInfo *locBMKPoi;

}
@property (nonatomic, strong) CLGeocoder  *geoC;
@end

@implementation SetCustomerAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商家地址";
//    locBMKPoi=[[BMKPoiInfo alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate=self;
    self.searchAddressButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    self.searchAddressButton.layer.borderWidth = 1.5;
    self.searchAddressButton.layer.cornerRadius = 2.5;
    self.searchAddressButton.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    self.searchAddressButton.layer.borderWidth = 1.5;
    self.searchAddressButton.layer.cornerRadius = 2.5;
    self.searchAddressButton.layer.borderColor=[UIColor groupTableViewBackgroundColor].CGColor;
    selectMapView= [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight-114)];
    selectMapView.mapType = BMKMapTypeStandard;
    selectMapView.delegate = self;
    [self.view addSubview:selectMapView];
    status=[[BMKMapStatus alloc]init];
    status.fOverlooking=0;
    status.fRotation=0;
    status.fLevel=18;
    [selectMapView setMapStatus:status withAnimation:YES];
    [self setCircleUI];
    
    [self judgeOrLocation];
    [self getNav];
}
-(void)getNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [selectMapView viewWillDisappear];
     selectMapView.delegate = nil;
}

// 判断是否需要定位
-(void)judgeOrLocation{
    
    
    if (self.sendPoi.address.length!=0&& self.sendPoi.address) {
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.title=self.sendPoi.address;
        annotation.coordinate = self.sendPoi.pt;
        
        CLLocationCoordinate2D loc = self.sendPoi.pt;
        
        
         [self.searchAddressButton setTitle:self.sendPoi.address forState:UIControlStateNormal];
        
        ///此类表示地图状态信息
        status=[[BMKMapStatus alloc]init];
        
        status.fOverlooking=0;
        status.fRotation=0;
        status.fLevel=18;
        status.targetGeoPt=loc;
        status.targetScreenPt=circleview.center;
        [selectMapView setMapStatus:status withAnimation:YES];
        [selectMapView removeAnnotations:selectMapView.annotations];
        [selectMapView addAnnotation:annotation];
        
        [selectMapView setCenterCoordinate:loc];
  
       
    }else{
        
        
          [self locationUpdates];

    }
    
}

-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
-(void)setCircleUI{
    circleview = [[UIView alloc]init];
    
    circleview.frame = CGRectMake(0,  0, kScreenWidth/2, kScreenWidth/2);
    circleview.center =selectMapView.center;    //    selectMapView.center;
    circleview.backgroundColor = [UIColor blueColor];
    circleview.alpha = 0.2;
    circleview.layer.masksToBounds = YES;
    circleview.layer.cornerRadius =circleview.frame.size.height/2;
    circleview.userInteractionEnabled = NO;
    circleview.layer.borderWidth = 2;
    circleview.layer.borderColor = [[UIColor greenColor]CGColor];
    [self.view addSubview:circleview];
}
#pragma 打开定位
-(void)locationUpdates{
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"请到手机设置中开启定位服务" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        alertView.delegate=self;
        
        [alertView showTarget:self.navigationController];
        
        return;
        
    }
    
    
    MapLocation *locationManager = [MapLocation sharedInstance];
    locationManager.isGeocoder = NO;
    
    [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {

        DLog(@"当前定位当前定位%f===%f===%@",userLatitude,userLongitude,city
              );
        [self.searchAddressButton setTitle:city forState:UIControlStateNormal];
        
        addressStr=city;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.title=city;
        annotation.coordinate = currentCoordinate;
        
        CLLocationCoordinate2D loc = currentCoordinate;
        [selectMapView setCenterCoordinate:loc];
        ///此类表示地图状态信息
        status=[[BMKMapStatus alloc]init];
        
        status.fOverlooking=0;
        status.fRotation=0;
        status.fLevel=18;
        status.targetGeoPt=loc;
        status.targetScreenPt=circleview.center;
        [selectMapView setMapStatus:status withAnimation:YES];
        [selectMapView removeAnnotations:selectMapView.annotations];
        [selectMapView addAnnotation:annotation];
        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        
    }];
}
#pragma 百度地图自带方法
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
//    addressStr=nil;
    //圆环的的中心点
    CLLocationCoordinate2D centerPoint = [mapView convertPoint:selectMapView.center toCoordinateFromView:self.view];
    CLLocationCoordinate2D pt =(CLLocationCoordinate2D){centerPoint.latitude, centerPoint.longitude };
    
    gloabarCenterPt=pt;
    self.sendPoi.pt=gloabarCenterPt;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        DLog(@"反geo检索发送成功");
    }
    else
    {
        DLog(@"反geo检索发送失败");
    }
    
    [mapView removeAnnotations:mapView.annotations];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = centerPoint.latitude;
    coor.longitude =centerPoint.longitude;
    annotation.coordinate = coor;
    [mapView addAnnotation:annotation];
    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (result.address.length==0&&self.sendPoi.address!=nil) {
        [self.searchAddressButton setTitle:self.sendPoi.address forState:UIControlStateNormal];
        
        addressStr=self.sendPoi.address;
        self.sendPoi.address=result.address;

    }else{
        
    [self.searchAddressButton setTitle:result.address forState:UIControlStateNormal];

     addressStr=result.address;
    self.sendPoi.address=result.address;
    }
    
    
}

- (IBAction)locationAction:(id)sender {
    [self locationUpdates];
}

- (IBAction)cirfimAddressAction:(id)sender {
        
    if (self.addressDataBack) {
        if (self.sendPoi.address.length > 0) {
            self.addressDataBack(self.sendPoi);
            
            [selectMapView viewWillDisappear];
            selectMapView.delegate = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
   
    
}
- (IBAction)searchAddressAction:(id)sender {
    PoiAddressViewController *VC=[[PoiAddressViewController alloc]init];
//    VC.transmitPoiInfo=[[BMKPoiInfo alloc]init];
//    VC.transmitPoiInfo.pt    =gloabarCenterPt;
//    VC.transmitPoiInfo.name  =self.searchAddressButton.titleLabel.text;
    
    VC.transmitPoiInfo=self.sendPoi;
    
    VC.poiBack =^(BMKPoiInfo *poi){
        DLog(@"输出的是%@",poi);
        [self updateStatusPoi:poi];
        
    };
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)updateStatusPoi:(BMKPoiInfo *)poi{
    
    NSString *str =poi.address;
    [self.searchAddressButton setTitle:str forState:UIControlStateNormal];
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(poi.pt.latitude,poi.pt.longitude);
    [selectMapView setCenterCoordinate:loc];
    ///此类表示地图状态信息
    status.fOverlooking=0;
    status.fRotation=0;
    status.fLevel=18;
    status.targetGeoPt=loc;
    [selectMapView setMapStatus:status withAnimation:YES];
    
}
- (void)sureAcion{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}
-(void)cancelAcion{
    
}
@end
