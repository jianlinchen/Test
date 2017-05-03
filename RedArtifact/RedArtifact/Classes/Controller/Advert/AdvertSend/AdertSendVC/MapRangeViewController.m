//
//  MapRangeViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/8/31.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#import "UIViewExt.h"
#import "MapRangeViewController.h"
#import "UIViewExt.h"
#import "MapLocation.h"
#import "PoiAddressViewController.h"
#import "MapRangeTableCell.h"
#import "RangMap.h"
#import "TestView.h"
@interface MapRangeViewController (){
    BMKMapView *selectMapView;
    UIView *circleview;
    
    CLLocationCoordinate2D gloabarCenterPt;//中心点坐标
    
    NSString *gloabarMeter;//距离间隔
    
    NSString *addressStr;//反编译地址信息
    
    BMKMapStatus *status;
    
    int viewHieght;// 针对三行范围的改变值
    
    TestView *testView3;
    TestView *testView4;
    TestView *testView0;
    
    
}
@property (nonatomic, strong) CLGeocoder  *geoC;
@property(nonatomic,strong)NSMutableArray *addressArray;//数据源
/**
 *  漂浮的tableview
 */
@property (nonatomic,strong) UITableView  *floatageTableView;
@end

@implementation MapRangeViewController

-(NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray=[NSMutableArray new];
    }
    return _addressArray;
}
-(UITableView *)floatageTableView{
    
    if (!_floatageTableView) {
        _floatageTableView=[[UITableView alloc]init];
        self.floatageTableView.delegate=self;
        self.floatageTableView.dataSource=self;
        //        self.floatageTableView.estimatedRowHeight=50;
        self.floatageTableView.rowHeight=60;
    }
    return _floatageTableView;
}
-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}
- (void)customLayer{
    
    self.cirfimButton.layer.cornerRadius = 20;
    self.cirfimButton.layer.borderWidth = 1;
    self.cirfimButton.layer.borderColor =[ [UIColor clearColor] CGColor];
    
    self.locationButton.layer.cornerRadius = 5;
    self.locationButton.layer.borderWidth = 1;
    self.locationButton.layer.borderColor =[RGBHex(0xdddddd)  CGColor];
    
    self.searchLoactionButton.layer.borderColor =[ [UIColor grayColor] CGColor];
    self.searchLoactionButton.layer.masksToBounds = YES;
    
    self.cornerView.layer.cornerRadius = 5;
    self.cornerView.layer.borderWidth = 1;
    self.cornerView.layer.borderColor =[RGBHex(0xdddddd)  CGColor];
    self.cornerView.layer.masksToBounds = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"投放目标";
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate=self;
    viewHieght=60;
    
    //地图初始化
    selectMapView= [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    
      [selectMapView setZoomEnabled:YES];
    [selectMapView setZoomLevel:16];//级别，3-19
   
    selectMapView.mapType = BMKMapTypeStandard;

    ////
    selectMapView.delegate = self;
    [self.view addSubview:selectMapView];
    
//    
    /**
     *  建立圆形环
     */
    [self setCircleUI];
    [self setFloatTableViewHeader];
    [self locationUpdates];
    [self setupNav];//设置右边的Bar
    [self GetMapRangeArray];
    [self getNav];

    NSString * firstStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"MapRange"];
    if (![firstStr isEqualToString:@"isFirst"]) {
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self AddReadyGuide];
        [[NSUserDefaults standardUserDefaults]setObject:@"isFirst"forKey:@"MapRange"];
    });
 }

//    [self AddReadyGuide];
}

-(void)AddReadyGuide{
    testView0 = [[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    testView0.backgroundColor = [UIColor clearColor];
    testView0.opaque =NO;

    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, KScreenHeight/2)];
    
    naImageView.image=[UIImage imageNamed:@"advert_handGuide"];

    
    UIImageView *naImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.5, kScreenWidth, KScreenHeight/2)];
    
    naImageView2.image=[UIImage imageNamed:@"advert_handGuide_bottom"];
    [testView0 addSubview:naImageView2];
    
    [testView0 addSubview:naImageView];
    naImageView.contentMode=UIViewContentModeCenter;
    naImageView2.contentMode=UIViewContentModeCenter;
    [self.navigationController.view addSubview:testView0];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewPersonView)];
    [testView0 addGestureRecognizer:singleTap];
    
}
-(void)addNewPersonView{
    [testView0 removeFromSuperview];
    testView3 = [[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    testView3.backgroundColor = [UIColor clearColor];
    testView3.opaque =NO;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestView3:)];
    [testView3 addGestureRecognizer:singleTap];
    
    testView3.needRect=CGRectMake(kScreenWidth-56, KScreenHeight-55, 50, 50);
    
    CGFloat left;
    
    if (kScreenWidth==320) {
        left=kScreenWidth/2-40;
    }else{
        left=kScreenWidth/2;
    }
    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(left, KScreenHeight-35, kScreenWidth-80, 60)];
    
    naImageView.center=CGPointMake(left, KScreenHeight-46);
    naImageView.image=[UIImage imageNamed:@"advert_map_bottom"];
    
    [testView3 addSubview:naImageView];
    naImageView.contentMode=UIViewContentModeCenter;
    [self.navigationController.view addSubview:testView3];
    
}
-(void)handleTestView3:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    [testView3 removeFromSuperview];
    testView4 =[[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    testView4.backgroundColor = [UIColor clearColor];
    testView4.opaque =NO;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTestView4:)];
    [testView4 addGestureRecognizer:singleTap];
    
    testView4.needRect=CGRectMake(kScreenWidth-60, 20, 50, 50);
    
        CGFloat left;
    if (kScreenWidth==320) {
        left=kScreenWidth/2-35;
    }else{
        left=kScreenWidth/2;
    }
    
    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(left, 30, kScreenWidth-80, 60)];
    naImageView.center=CGPointMake(left, 60);
    
    naImageView.image=[UIImage imageNamed:@"advert_map_top"];
    
    [testView4 addSubview:naImageView];
    naImageView.contentMode=UIViewContentModeCenter;
    [self.navigationController.view addSubview:testView4];
    
}
-(void)handleTestView4:(UITapGestureRecognizer*)recognizer
{
    [testView3 removeFromSuperview];
    [testView4 removeFromSuperview];

}
-(void)getNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBack)];
}
-(void)leftBack{
     [self.navigationController popViewControllerAnimated:YES];
     [selectMapView viewWillDisappear];
    if (self.arrayBlock) {
        self.arrayBlock(self.addressArray);
    }
     selectMapView.delegate = nil;
    
}

-(void)GetMapRangeArray{
    
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"PRODUCER";
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    apiDic[@"adv_id"] = self.adv_id;
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:PostRangMap completed:^(id data, NSString *stringData) {
        NSLog(@"+++++++++++%@",data);
        
        NSMutableDictionary *dic=data;
        NSArray *getArray=dic[@"data"][@"list"];
        
        for (int i=0; i<getArray.count; i++) {
            RangMap *rangMap=[[RangMap alloc]init];
            NSDictionary *dic=getArray[i];
            rangMap.addressStr=[NSString stringWithFormat:@"%@",dic[@"pub_address"]];
            rangMap.latStr=[NSString stringWithFormat:@"%@",dic[@"pub_lat"]];
            rangMap.lngStr=[NSString stringWithFormat:@"%@",dic[@"pub_lng"]];
            rangMap.meterStr=[NSString stringWithFormat:@"%@",dic[@"pub_range"]];
            rangMap.pub_id=[NSString stringWithFormat:@"%@",dic[@"pub_id"]];
            
            [self.addressArray addObject:rangMap];
        }
        
        for (int p=0; p<self.addressArray.count; p++) {
            viewHieght=viewHieght+60;
        }
        
        [self.floatageTableView setFrame:CGRectMake(0, KScreenHeight-64-viewHieght,kScreenWidth, viewHieght)];
        
        [self.floatageTableView reloadData];
        
    } failed:^(RAError *error) {
        
    }];
}
#pragma 设置导航栏
-(void)setupNav
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    rightButton.titleLabel.font=[UIFont systemFontOfSize :14.0];
    [rightButton addTarget:self action:@selector(click)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

-(void)click{

    if (self.addressArray.count==0) {
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请点击“+”添加投放目标"];
        [alertView showTarget:self.tabBarController];
        
        return;
    }
    
        if (self.arrayBlock) {
            self.arrayBlock(self.addressArray);
        }
        [self.navigationController popViewControllerAnimated:YES];

}
-(void)back{
    
    [selectMapView viewWillDisappear];
    selectMapView.delegate = nil;

    //调用了自定义的返回的方法
    if (self.arrayBlock) {
        self.arrayBlock(self.addressArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma 设置tableView
-(void) setFloatTableViewHeader{
    [self.floatageTableView setFrame:CGRectMake(0, KScreenHeight-64-60, kScreenWidth, 60)];
    [self.view addSubview:self.floatageTableView];
    
    self.floatageTableView.tableHeaderView=self.tableViewHeader;
    [self customLayer];
}
#pragma 建立圆形环
-(void)setCircleUI{
    circleview = [[UIView alloc]init];
    
    circleview.frame = CGRectMake(0,  0, KScreenHeight/2-80, KScreenHeight/2-80);
    circleview.center =CGPointMake(kScreenWidth/2, KScreenHeight/4);
    //    selectMapView.center;
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
        
        
        
        NSLog(@"当前定位当前定位%f===%f===%@",userLatitude,userLongitude,city
              );
        [self.searchLoactionButton setTitle:city forState:UIControlStateNormal];
        
        addressStr=city;
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.title=city;
        annotation.coordinate = currentCoordinate;
        
        CLLocationCoordinate2D loc = currentCoordinate;
        [selectMapView setCenterCoordinate:loc];
        ///此类表示地图状态信息
        status=[[BMKMapStatus alloc]init];
        
//        status.fOverlooking=0;
//        status.fRotation=0;
//        status.fLevel=18;
        status.targetGeoPt=loc;
        status.targetScreenPt=CGPointMake(kScreenWidth/2, KScreenHeight/4);
        [selectMapView setMapStatus:status withAnimation:YES];
        [selectMapView removeAnnotations:selectMapView.annotations];
        [selectMapView addAnnotation:annotation];
        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        
    }];
}
#pragma 百度地图自带方法
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    addressStr=nil;
    //圆环的的中心点
    CLLocationCoordinate2D centerPoint = [mapView convertPoint:CGPointMake(kScreenWidth/2, KScreenHeight/4) toCoordinateFromView:self.view];
    
    CLLocationCoordinate2D pt =(CLLocationCoordinate2D){centerPoint.latitude, centerPoint.longitude };
    
    gloabarCenterPt=pt;
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
    
    [mapView removeAnnotations:mapView.annotations];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = centerPoint.latitude;
    coor.longitude =centerPoint.longitude;
    annotation.coordinate = coor;
    [mapView addAnnotation:annotation];
    
    
    // 确定顶点的坐标
    CLLocationCoordinate2D roundPoint = [mapView convertPoint:CGPointMake(kScreenWidth/2, 80) toCoordinateFromView:self.view];
    
    CLLocation *centerLocation=[[CLLocation alloc] initWithLatitude:centerPoint.latitude longitude:centerPoint.longitude];
    
    CLLocation *roundLocation=[[CLLocation alloc] initWithLatitude:roundPoint.latitude longitude:roundPoint.longitude];
    // 计算距离
    CLLocationDistance meters=[centerLocation distanceFromLocation:roundLocation];
    int metersInt= meters;
    gloabarMeter=[NSString stringWithFormat:@"%d米",metersInt];
    
    self.meterRangeLabel.text=[NSString stringWithFormat:@"%d米",metersInt];
    NSLog(@"++++%f====",meters);
    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    [self.searchLoactionButton setTitle:result.address forState:UIControlStateNormal];
    
    addressStr=result.address;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MapRangeTableCell";
    MapRangeTableCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MapRangeTableCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    cell.deleteButton.tag=indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteRowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.addressArray.count!=0) {
        RangMap *rangMap=[[RangMap alloc]init];
        rangMap=self.addressArray[indexPath.row];
        NSString *blendStr=[NSString stringWithFormat:@"%@ <%@米",rangMap.addressStr,rangMap.meterStr];
        
        NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:blendStr];
        [nameStr addAttribute:NSForegroundColorAttributeName value:RGBHex(0x333333) range:NSMakeRange(0,rangMap.addressStr.length)];
        
        cell.addressLabel.attributedText=nameStr;
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    return cell  ;
}
-(void)deleteRowAction:(UIButton *)btn{
    
    RangMap *rangMap=[[RangMap alloc]init];
    rangMap=self.addressArray[btn.tag];
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;headerDic[@"IDENTITY"] =@"PRODUCER";
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    programDic[@"pub_id"]    =rangMap.pub_id;
    
     [MBProgressHUD showMessag:@"" toView:self.view];
    [GLOBLHttp Method:DELETE withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PostRangMap completed:^(id data, NSString *stringData) {
        
        [self.addressArray removeObjectAtIndex:btn.tag];
        
//        [MBProgressHUD showSuccess:@"删除成功" toView:self.view];     
//        NSLog(@"删除成功%@",data);
        viewHieght=viewHieght-60;
        [self.floatageTableView setFrame:CGRectMake(0, KScreenHeight-64-viewHieght,kScreenWidth, viewHieght)];
        
        [self.floatageTableView reloadData];
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       
        
    } failed:^(RAError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail];
        [alertView showTarget:self.navigationController];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
}

- (IBAction)locationAction:(id)sender {
    [self locationUpdates];
    
}
- (IBAction)searchLocationAction:(id)sender {
    
    PoiAddressViewController *VC=[[PoiAddressViewController alloc]init];
    VC.transmitPoiInfo=[[BMKPoiInfo alloc]init];
    VC.transmitPoiInfo.pt    =gloabarCenterPt;
    VC.transmitPoiInfo.address  =self.searchLoactionButton.titleLabel.text;
    
    VC.poiBack =^(BMKPoiInfo *poi){
        NSLog(@"输出的是%@",poi);
        [self updateStatusPoi:poi];
        
    };
    [self.navigationController pushViewController:VC animated:YES];
}
//
-(void)updateStatusPoi:(BMKPoiInfo *)poi{
    
    NSString *str =poi.name;
    [self.searchLoactionButton setTitle:str forState:UIControlStateNormal];
    
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(poi.pt.latitude,poi.pt.longitude);
    [selectMapView setCenterCoordinate:loc];
    ///此类表示地图状态信息
//    status.fOverlooking=0;
//    status.fRotation=0;
//    status.fLevel=18;
    status.targetGeoPt=loc;
    [selectMapView setMapStatus:status withAnimation:YES];
    
}
- (IBAction)cirfimAction:(id)sender {
    
}

- (IBAction)addAction:(id)sender {
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if (self.addressArray.count<3) {
        
        RangMap *rangMap=[[RangMap alloc]init];
        rangMap.latStr=[NSString stringWithFormat:@"%f",gloabarCenterPt.latitude];
        rangMap.lngStr=[NSString stringWithFormat:@"%f", gloabarCenterPt.longitude];;
        rangMap.addressStr=addressStr;
        rangMap.meterStr=gloabarMeter;
        
        if (rangMap.latStr.length==0||rangMap.lngStr.length==0||rangMap.addressStr.length==0||rangMap.meterStr.length==0) {
            return;
        }
        viewHieght=viewHieght+60;
        
        
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;headerDic[@"IDENTITY"] =@"PRODUCER";
        
        
        NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
        programDic[@"adv_id"]    =self.adv_id;
        programDic[@"lat"]       =[NSString stringWithFormat:@"%@",  rangMap.latStr];
        programDic[@"lng"]       =[NSString stringWithFormat:@"%@",rangMap.lngStr];
        int pp=[rangMap.meterStr intValue];
        programDic[@"range"]     =[NSString stringWithFormat:@"%d",pp];
        programDic[@"address"]   =rangMap.addressStr;
         [MBProgressHUD showMessag:@"" toView:self.view];
        [GLOBLHttp Method:POST  withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PostRangMap completed:^(id data, NSString *stringData) {
         
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSDictionary *dic=data;
            
            RangMap *rangMapContent=[[RangMap alloc]init];
            
            rangMapContent.addressStr=[NSString stringWithFormat:@"%@" ,dic[@"data"][@"info"][@"pub_address"]];
            rangMapContent.meterStr=[NSString stringWithFormat:@"%@" ,dic[@"data"][@"info"][@"pub_range"]];
            rangMapContent.latStr=[NSString stringWithFormat:@"%@" ,dic[@"data"][@"info"][@"pub_lat"]];
            rangMapContent.lngStr=[NSString stringWithFormat:@"%@" ,dic[@"data"][@"info"][@"pub_lng"]];
            rangMapContent.pub_id=[NSString stringWithFormat:@"%@" ,dic[@"data"][@"info"][@"pub_id"]];
            [self.addressArray addObject:rangMapContent];
            
            [self.floatageTableView setFrame:CGRectMake(0, KScreenHeight-64-viewHieght,kScreenWidth, viewHieght)];
            [self.floatageTableView reloadData];
            
        } failed:^(RAError *error) {
              [MBProgressHUD hideHUDForView:self.view animated:YES];
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail];
            [alertView showTarget:self.navigationController];
        }];
        
    }else{
//        [MBProgressHUD showError:@"最多添加三条数据" toView:self.view];
    }
    
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
