//
//  MapLocation.m
//  
//
//  Created by LiLu on 16/7/2.
//
//

#import "MapLocation.h"
@interface MapLocation ()
@property (nonatomic, assign,getter=isGetLocation) BOOL getLocation;

@end
@implementation MapLocation

+ (MapLocation *)sharedInstance
{
    static MapLocation *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}
-(id)init
{
    if (self == [super init])
    {
        [self initBMKUserLocation];
    }
    return self;
}
#pragma 初始化百度地图用户位置管理类
/**
 *  初始化百度地图用户位置管理类
 */
- (void)initBMKUserLocation
{
    _locService = [[BMKLocationService alloc]init];
//    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    _locService.distanceFilter = kCLDistanceFilterNone;
    _locService.delegate = self;
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate=self;
    [self startLocation];
    
}

// 启动获取经纬度
- (void)startGetLocation:(GetLoactionSuccesBlock)successBlock
            failureBlock:(GetLocationFailureBlock)failureBlock {
    
    _userSuccessBlock = [successBlock copy];
    _userFailureBlock = [failureBlock copy];
    
    self.getLocation = NO;
    
    
  
    // 定位服务是否开启
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
//        NSString * orLoactionStr = [[NSUserDefaults standardUserDefaults] objectForKey:OrLocation];
//        if ([orLoactionStr isEqualToString:@"定位未开启"]) {
//            
//            
//        }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"定位未开启" forKey:OrLocation];
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"请到手机设置中开启定位服务" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        alertView.delegate=self;
        
        UIViewController *VC=[self pppactivityViewController ];
        [alertView showTarget:VC];

//        }
   
        if (_userFailureBlock) {
            _userFailureBlock(@"定位服务未开启",WMGetUserLocationUnenable);
        }
        
        
    } else {
        
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrLocation];
        // 启动定位服务
        [_locService startUserLocationService];
    }
}

#pragma 打开定位服务
/**
 *  打开定位服务
 */
-(void)startLocation
{
    [_locService startUserLocationService];
}
#pragma 关闭定位服务

/**
 *  关闭定位服务
 */
-(void)stopLocation
{
    [_locService stopUserLocationService];
    NSLog(@"stop locate");
}

- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
  
}
#pragma BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
// *@param userLocation 新的用户位置
// */

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
 _clloction = userLocation.location;
//    _clloction = cllocation;
    _userLatitude = _clloction.coordinate.latitude;
    _userLongitude = _clloction.coordinate.longitude;
    _currentCoordinate= _clloction.coordinate;
    
    CLLocationCoordinate2D pt =(CLLocationCoordinate2D){_userLatitude, _userLongitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
//        if (_userSuccessBlock) {
//        _userSuccessBlock( _clloction.coordinate.latitude,_clloction.coordinate.longitude,nil);
//    }
    [self stopLocation];

}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (_userSuccessBlock) {
        _userSuccessBlock(_currentCoordinate, _clloction.coordinate.latitude,_clloction.coordinate.longitude,result.address);
    }

}

-(void)onClickReverseGeocode{
    
    
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self stopLocation];
}

- (UIViewController *)pppactivityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
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
