//
//  SetCustomerAddressController.h
//  RedArtifact
//
//  Created by LiLu on 16/10/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^AddressData) (BMKPoiInfo *poi);
@interface SetCustomerAddressController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate,AlertViewSureDelegate>{

}
@property (nonatomic,strong) BMKPoiInfo *sendPoi;//判断是否首先要定位
@property (strong,nonatomic) BMKGeoCodeSearch *geocodesearch;
- (IBAction)locationAction:(id)sender;
- (IBAction)cirfimAddressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchAddressButton;
- (IBAction)searchAddressAction:(id)sender;
@property (copy,nonatomic) AddressData addressDataBack;
@end
