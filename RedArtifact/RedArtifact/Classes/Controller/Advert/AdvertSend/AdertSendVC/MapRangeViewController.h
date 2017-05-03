//
//  MapRangeViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/8/31.
//  Copyright © 2016年 jianlin. All rights reserved.
//

typedef void (^AddressArrayBlock) (NSMutableArray *addressArray);
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
@interface MapRangeViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,UIPickerViewDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,AlertViewSureDelegate>

@property (nonatomic,strong) NSMutableArray *transitionArray;//过渡数组，传递范围的数组
@property (strong,nonatomic) BMKGeoCodeSearch *geocodesearch;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchLoactionButton;
- (IBAction)searchLocationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *meterRangeLabel;

@property (strong, nonatomic) IBOutlet UIView *tableViewHeader;
@property (weak, nonatomic) IBOutlet UIView *cornerView;

@property (weak, nonatomic) IBOutlet UIButton *cirfimButton;
@property (strong, nonatomic) IBOutlet UIView *floatMapFooterView;
@property (nonatomic,strong) NSString *name;

@property (nonatomic,copy) AddressArrayBlock arrayBlock;

@property (nonatomic,strong) NSString *adv_id;
- (IBAction)cirfimAction:(id)sender;
- (IBAction)addAction:(id)sender;



@end
