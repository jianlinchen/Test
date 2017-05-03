//
//  MapLocation.h
//  
//
//  Created by LiLu on 16/7/2.
//
//


#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CustomAlertView.h"
@interface MapLocation : NSObject<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,AlertViewSureDelegate >{
}

typedef enum : NSUInteger {
    
    WMGetUserLocationUnenable = 0, // 没有激活
    WMGetUserLocationGetFailed, // 定位失败
    WMGetUserLocationReverseGeocodFailed // 反地理解析失败
    
} WMGetUserLocationFailedType;

typedef void (^GetLoactionSuccesBlock)(CLLocationCoordinate2D currentCoordinate,double userLatitude, double userLongitude,NSString *city);
typedef void (^GetLocationFailureBlock)(NSString *errorMsg,NSUInteger errorCode);

//用户纬度
@property (nonatomic,assign) double postLongitude;

//用户经度
@property (nonatomic,assign) double postLatitude;


// 根据反地理编译，获取到经纬度
typedef void (^GetCityAddress)(NSString *cityAddress);

// 地理位置解析标记
@property (nonatomic, assign) BOOL isGeocoder;

@property (strong,nonatomic) BMKLocationService *locService;
@property (strong,nonatomic) BMKGeoCodeSearch *geocodesearch;



@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
//城市名
@property (strong,nonatomic) NSString *cityName;

//用户经度
@property (nonatomic,assign) double userLatitude;

//用户纬度
@property (nonatomic,assign) double userLongitude;

//用户位置
@property (strong,nonatomic) CLLocation *clloction;

@property (nonatomic, copy) GetLoactionSuccesBlock userSuccessBlock;
@property (nonatomic, copy) GetLocationFailureBlock userFailureBlock;
@property (nonatomic, copy) GetCityAddress getCityAddress;

//初始化单例
+ (MapLocation *)sharedInstance;

//初始化百度地图用户位置管理类
- (void)initBMKUserLocation;

//开始定位
-(void)startLocation;

//停止定位
-(void)stopLocation;

- (void)startGetLocation:(GetLoactionSuccesBlock)successBlock
            failureBlock:(GetLocationFailureBlock)failureBlock;

//-(void)geCityAddress:(double)lat andLng(double)lng add
@end
