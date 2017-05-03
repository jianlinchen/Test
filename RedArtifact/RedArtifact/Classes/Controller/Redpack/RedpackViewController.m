//
//  RedpackViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RedpackViewController.h"
#import "RedpacketNojoinCell.h"
#import "RedpacketJoinCell.h"
#import "RedpackDetailViewController.h"
#import "MapLocation.h"
#import "RARedpacket.h"

static NSString *const kRedpacketJoinCellIdentifier = @"RedpacketJoinCellID";
static NSString *const kRedpacketNojoinCellIdentifier = @"RedpacketNojoinCellID";

@interface RedpackViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
    
    BOOL _isFirst;//是否是第一次进入此页面
    
    NSString *_locationLng;//经度
    NSString *_locationLat;//纬度
    
    NSMutableArray *_showArrays;
    
    BOOL _isShowNoData;//是否显示暂无数据
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation RedpackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _isFirst = YES;
    
    _page = 1;
    
    _locationLat = @"1";
    _locationLng = @"1";
    
    CGRect frame = self.view.frame;
    frame.size.width = UIScreenWidth;
    self.view.frame = frame;
    
    _showArrays = [NSMutableArray array];
    
    if (self.status == NotInvolved) {
        [self.mainTableView registerNib:[UINib nibWithNibName:@"RedpacketNojoinCell" bundle:nil] forCellReuseIdentifier:kRedpacketNojoinCellIdentifier];
    } else {
        
        [self.mainTableView registerNib:[UINib nibWithNibName:@"RedpacketJoinCell" bundle:nil] forCellReuseIdentifier:kRedpacketJoinCellIdentifier];
    }
    
    self.mainTableView.mj_header = self.header;
    
    
    self.mainTableView.backgroundView.backgroundColor = [UIColor redColor];
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    //获取已领取红包数据
    [self loadJoinedData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadNewData];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        _isShowNoData = YES;
    }
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showArrays.count > 0) {
        return _showArrays.count;
    } else {
        self.mainTableView.mj_footer.hidden = YES;
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_showArrays.count > 0) {
        if (self.status == NotInvolved) {
            RARedpacket *packet = _showArrays[indexPath.row];
            
            RedpacketNojoinCell *nojoinCell = [tableView dequeueReusableCellWithIdentifier:kRedpacketNojoinCellIdentifier];
            NSArray *array = packet.red_content[@"images"];
            if (array.count != 0) {
                [nojoinCell.logoImgView sd_setImageWithURL:array[0] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
            }
            nojoinCell.bonus_must_amountLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:packet.prize_top_money]];
            nojoinCell.begin_timeLabel.text = [NSDate dateWithTimeIntervalString:packet.pub_begin_time withDateFormatter:nil];
            nojoinCell.end_timeLabel.text = [NSDate dateWithTimeIntervalString:packet.pub_end_time withDateFormatter:nil];
            return nojoinCell;
        } else {
            RedpacketJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:kRedpacketJoinCellIdentifier];
            
            RAConsumer *consumer = _showArrays[indexPath.row];
            NSArray *images = consumer.adv_content[@"images"];
            if (images.count > 0) {
                [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
            } else {
                [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:consumer.user_heading] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
            }
            cell.bonus_titleLabel.text = consumer.adv_title;
            cell.bonus_companyLabel.text = consumer.pub_name;
            cell.bonus_amountLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:consumer.money]];
            cell.bonus_timeLabel.text = [NSDate dateWithTimeIntervalString:consumer.create_time withDateFormatter:nil];
            
            return cell;
        }

    } else {
        static NSString *CellIdentifier = @"Cell";
        
        //初始化cell并指定其类型，也可自定义cell
        
        UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 100 - 50)];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        
        if (_isShowNoData) {
            tempLabel.text = @"暂无数据";
            
        } else {
            tempLabel.text = @"  ";
        }
        
        tempLabel.textColor = [UIColor colorWithHex:0x999999];
        [cell.contentView addSubview:tempLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_showArrays.count > 0) {
        RedpackDetailViewController *vc = [[RedpackDetailViewController alloc] init];
        if (self.status == NotInvolved) {
            RARedpacket *packet = _showArrays[indexPath.row];
            if ([packet.bonus_remain_num intValue] > 0) {
                vc.redpacket = packet;
                vc.status = self.status;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"结束了！" message:@"下次早点来"];
                [alertView showTarget:self];
            }
            
        } else {
            RAConsumer *consumer = _showArrays[indexPath.row];
            vc.consumer = consumer;
            vc.status = self.status;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_showArrays.count > 0) {
        if (self.status == NotInvolved) {
            return 105;
        } else {
            return 158;
        }
    } else {
        return UIScreenHeight - 100 - 50;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

#pragma mark - load data method

- (void)loadNewData {
    _page = 1;
    
    [self loadListData];
}

- (void)loadMoreData {
    if (self.status == NotInvolved) {
        _page++;
    } else {
        _page = 1;
    }
    [self loadListData];
}

- (void)loadListData {
    if (self.status == NotInvolved) {
        //定位并获取红包数据
        [self getLocation];
    } else {
        //获取已领取红包数据
        [self loadJoinedData];
    }
}

-(void)againRequest{
    [super againRequest];
    
    [self loadNewData];
    
}

#pragma mark - 定位获取经纬度
- (void)getLocation {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"请到手机设置中开启定位服务" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        alertView.delegate=self;
        
        [alertView showTarget:self.navigationController];
        
        [self.header setTitle:@"数据加载失败" forState:MJRefreshStateRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            
        });
        
        
        return;
        
    }
    
    MapLocation *locationManager = [MapLocation sharedInstance];
    locationManager.isGeocoder = NO;
    
    [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {
        
        _locationLat = [NSString stringWithFormat:@"%f",userLatitude];
        
        _locationLng=[NSString stringWithFormat:@"%f",userLongitude];
        //获取红包数据
        [self getRedpacketData];
        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        _isShowNoData = YES;
        [self.mainTableView reloadData];
        [self.header setTitle:@"数据加载失败" forState:MJRefreshStateRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            
        });
    }];
}

//获取未领取红包数据
- (void)getRedpacketData {
    if ([_locationLng isEqualToString:@"1"]||[_locationLng isEqualToString:@"1"]) {
        
       [self getLocation];
        return;  
    }
    
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:kRedpacketNOJoinedList withTableName:kRedpacketTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"CONSUMER";
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"lng"] = _locationLng;
        apiDic[@"lat"] = _locationLat;
        apiDic[@"limit"] = @"10";
        apiDic[@"offset"] = [NSString stringWithFormat:@"%ld",(_page - 1) * 10];
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetNearbyAdvertisementList completed:^(id data, NSString *stringData) {
            NSArray *dataArray = data[@"data"][@"list"];
            if (dataArray.count > 0) {
                
                if (_page == 1) {
                    [_showArrays removeAllObjects];
                }
                if (dataArray.count < 10) {
                    self.mainTableView.mj_footer.hidden = YES;
                    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.mainTableView.mj_footer.hidden= NO;
                    [self.mainTableView.mj_footer resetNoMoreData];
                }
                
                [_showArrays addObjectsFromArray:[RARedpacket mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                if (_delegate) {
                    [self.delegate reloadNojoinCount:data[@"data"][@"count"]];
                }
                
                [RADBTool putObject:data withId:kRedpacketNOJoinedList intoTable:kRedpacketTableName withComplete:nil];
            } else {
                self.mainTableView.mj_footer.hidden = YES;
                
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                
                if (_page == 1) {
                    [_showArrays removeAllObjects];
                }
                
                if (_delegate) {
                    [self.delegate reloadNojoinCount:@"0"];
                }
            }
            
            if (_showArrays.count == 0) {
                _isShowNoData = YES;
            } else {
                _isShowNoData = NO;
            }
            
            [self.mainTableView reloadData];
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
        } failed:^(RAError *error) {
            NSArray *dataArray = item.itemObject[@"data"][@"list"];
            if (dataArray.count > 0) {
                [_showArrays removeAllObjects];
                
                [_showArrays addObjectsFromArray:[RARedpacket mj_objectArrayWithKeyValuesArray:dataArray]];
                
                if (_showArrays.count == 0) {
                    _isShowNoData = YES;
                } else {
                    _isShowNoData = NO;
                }
                
                [self.mainTableView reloadData];
                
                if (_delegate) {
                    [self.delegate reloadNojoinCount:item.itemObject[@"data"][@"count"]];
                }
                
            } else {
                if (_delegate) {
                    [self.delegate reloadNojoinCount:@"0"];
                }
            }
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
        }];
    } else {
        NSArray *dataArray = item.itemObject[@"data"][@"list"];
        if (dataArray.count > 0) {
            [_showArrays removeAllObjects];
            
            [_showArrays addObjectsFromArray:[RARedpacket mj_objectArrayWithKeyValuesArray:dataArray]];
            
            if (_showArrays.count == 0) {
                _isShowNoData = YES;
            } else {
                _isShowNoData = NO;
            }
            
            [self.mainTableView reloadData];
            
            if (_delegate) {
                [self.delegate reloadNojoinCount:item.itemObject[@"data"][@"count"]];
            }
            
        } else {
            if (_delegate) {
                [self.delegate reloadNojoinCount:@"0"];
            }
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }
}

//获取已领取红包数据
- (void)loadJoinedData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:kRedpacketJoinedList withTableName:kRedpacketTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"CONSUMER";
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetJoinedBonusList completed:^(id data, NSString *stringData) {
            if (_isFirst) {
                if (_delegate) {
                    [self.delegate reloadJoinCount:data[@"data"][@"count"]];
                }
                _isFirst = NO;
            } else {
                NSArray *dataArray = data[@"data"][@"list"];
                if (dataArray.count > 0) {
                    
                    [_showArrays removeAllObjects];
                    
                    [_showArrays addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                    
                    if (_showArrays.count == 0) {
                        _isShowNoData = YES;
                    } else {
                        _isShowNoData = NO;
                    }
                    
                    [self.mainTableView reloadData];
                    if (_delegate) {
                        [self.delegate reloadJoinCount:data[@"data"][@"count"]];
                    }
                    
                } else {
                    [_showArrays removeAllObjects];
                    
                    [self.delegate reloadJoinCount:@"0"];
                }
            }
            [RADBTool putObject:data withId:kRedpacketJoinedList intoTable:kRedpacketTableName withComplete:nil];
            
        } failed:^(RAError *error) {
            if (_isFirst) {
                if (_delegate) {
                    [self.delegate reloadJoinCount:item.itemObject[@"data"][@"count"]];
                }
                _isFirst = NO;
            } else {
                NSArray *dataArray = item.itemObject[@"data"][@"list"];
                if (dataArray.count > 0) {
                    
                    [_showArrays removeAllObjects];
                    
                    [_showArrays addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
                    
                    if (_showArrays.count == 0) {
                        _isShowNoData = YES;
                    } else {
                        _isShowNoData = NO;
                    }
                    
                    [self.mainTableView reloadData];
                    if (_delegate) {
                        [self.delegate reloadJoinCount:item.itemObject[@"data"][@"count"]];
                    }
                    
                } else {
                    [self.delegate reloadJoinCount:@"0"];
                }
            }
        }];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    } else {
        if (_isFirst) {
            if (_delegate) {
                [self.delegate reloadJoinCount:item.itemObject[@"data"][@"count"]];
            }
            _isFirst = NO;
        } else {
            NSArray *dataArray = item.itemObject[@"data"][@"list"];
            if (dataArray.count > 0) {
                
                [_showArrays removeAllObjects];
                
                [_showArrays addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
                if (_showArrays.count == 0) {
                    _isShowNoData = YES;
                } else {
                    _isShowNoData = NO;
                }
                
                [self.mainTableView reloadData];
                if (_delegate) {
                    [self.delegate reloadJoinCount:item.itemObject[@"data"][@"count"]];
                }
                
            } else {
                [self.delegate reloadJoinCount:@"0"];
            }
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
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
