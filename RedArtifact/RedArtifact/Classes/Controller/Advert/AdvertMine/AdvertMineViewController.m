//
//  AdvertMineViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertMineViewController.h"
#import "RAAdvert.h"
#import "AdvertMineCell.h"
#import "AdvertDetailViewController.h"
#import "AdvertSendViewController.h"
#import "CustomAlertView.h"
#import "RefundLogViewController.h"

static NSString *const kAdvertMineCellIdentifier = @"AdvertMineCellID";

@interface AdvertMineViewController () <UITableViewDelegate, UITableViewDataSource,AlertViewSureDelegate>
{
    NSInteger _offset;
    NSInteger _page;
    
    NSMutableArray *_advertlist;
    
    NSString *_refund_adv_id;//申请退款的advert_id;
    
    NSMutableArray *_clickRowArrays;//点击了的cell
    
    int _applyStatus;//已完成按钮点击状态：1：确认退款，2:申请余额结算 0:其他
    
    RAAdvert *_currentAdvert;//当前选择的广告
    
    BOOL _isShowNoData;//是否显示暂无数据
}
@property (nonatomic, strong) RAAdvert *refundAdvert;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation AdvertMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offset = 0;
    _page = 0;
    _advertlist = [NSMutableArray array];
    _clickRowArrays = [NSMutableArray array];
    _applyStatus = 0;
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertMineCell" bundle:nil] forCellReuseIdentifier:kAdvertMineCellIdentifier];
    self.mainTableView.mj_header = self.header;
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        _isShowNoData = YES;
    }
    
    [self loadNewData];
}

#pragma mark - load data method

- (void)loadNewData {
    [_clickRowArrays removeAllObjects];
    
    _page = 0;
    _offset = 0;
    
    [self loadListData];
}

- (void)loadMoreData {
    _offset = (_page + 1) * 10;
    
    _page++;
    
    [self loadListData];
}

- (void)loadListData {
    NSString *statusStr = kAdvertMineViewControlleEditingList;
    switch (self.status) {
        case Editing:
        {
            statusStr = kAdvertMineViewControlleEditingList;
            break;
        }
        case Prepareing:
        {
            statusStr = kAdvertMineViewControllePrepareingList;
            break;
        }
        case Sending:
        {
            statusStr = kAdvertMineViewControlleSendingList;
            break;
        }
        case Finished:
        {
            statusStr = kAdvertMineViewControlleFinishedList;
            break;
        }
        default:
            break;
    }
    
    [self getAdvertListDataWithStatus:statusStr];
}

#pragma mark - UITableViewDataSource/Deleagte

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_advertlist.count > 0) {
        return _advertlist.count;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_advertlist.count > 0) {
        AdvertMineCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdvertMineCellIdentifier];
        RAAdvert *advert = _advertlist[indexPath.row];
        if (self.status == Finished) {
            cell.statusLabel.hidden = NO;
            cell.statusButton.hidden = NO;
            if ([advert.refund_status intValue] == 0) {
                NSString *rowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                if ([_clickRowArrays containsObject:rowStr]) {
                    if (_applyStatus == 1) {
                        cell.statusLabel.text = @"已完成";
                        cell.statusButton.hidden = YES;
                        cell.statusLabelConstraint.constant = -30;
                        [cell.statusButton setTitle:nil forState:UIControlStateNormal];
                    } else if (_applyStatus == 2) {
                        cell.statusLabel.text = @"退款中";
                        cell.statusLabelConstraint.constant = 12;
                        [cell.statusButton setTitle:@" 结算进度 " forState:UIControlStateNormal];
                        cell.statusButton.tag = indexPath.row;
                        [cell.statusButton addTarget:self action:@selector(applyRemainAction:) forControlEvents:UIControlEventTouchUpInside];
                    } else {
                        cell.statusLabel.text = @"已完成";
                        cell.statusLabelConstraint.constant = 12;
                        if ([advert.bonus_accepted_num integerValue] == [advert.bonus_total_num integerValue]) {
                            [cell.statusButton setTitle:@" 确认完成 " forState:UIControlStateNormal];
                        } else {
                            [cell.statusButton setTitle:@" 申请余额结算 " forState:UIControlStateNormal];
                        }
                        
                        cell.statusButton.tag = indexPath.row;
                        [cell.statusButton addTarget:self action:@selector(applyRemainAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                } else {
                    cell.statusLabel.text = @"已完成";
                    cell.statusLabelConstraint.constant = 12;
                    if ([advert.bonus_accepted_num integerValue] == [advert.bonus_total_num integerValue]) {
                        [cell.statusButton setTitle:@" 确认完成 " forState:UIControlStateNormal];
                    } else {
                        [cell.statusButton setTitle:@" 申请余额结算 " forState:UIControlStateNormal];
                    }
                    
                    cell.statusButton.tag = indexPath.row;
                    [cell.statusButton addTarget:self action:@selector(applyRemainAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                
            } else if ([advert.refund_status intValue] == 1||[advert.refund_status intValue] == 2) {
                cell.statusLabel.text = @"退款中";
                cell.statusLabelConstraint.constant = 12;
                [cell.statusButton setTitle:@" 结算进度 " forState:UIControlStateNormal];
                cell.statusButton.tag = indexPath.row;
                [cell.statusButton addTarget:self action:@selector(applyRemainAction:) forControlEvents:UIControlEventTouchUpInside];
            } else if ([advert.refund_status intValue] == 9) {
                cell.statusLabel.text = @"退款完成";
                cell.statusButton.hidden = YES;
                cell.statusLabelConstraint.constant = -30;
                [cell.statusButton setTitle:nil forState:UIControlStateNormal];
            } else {
                cell.statusButton.hidden = YES;
                cell.statusLabel.text = @"已完成";
                cell.statusLabelConstraint.constant = -30;
                
                [cell.statusButton setTitle:nil forState:UIControlStateNormal];
            }
        } else {
            cell.statusLabel.hidden = YES;
            cell.statusButton.hidden = YES;
        }

        NSArray *images = advert.advert_content[@"images"];
        if (images.count > 0) {
            [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
        }
        
        cell.advert_titleLabel.attributedText = [UILabel RALabelAttributedString:advert.advert_title lineSpacing:10];
        
        cell.advert_companyLabel.text = advert.pub_user_name;
        cell.advert_timeLabel.text = [NSDate dateWithTimeIntervalString:advert.advert_create_time withDateFormatter:nil];
        if (self.status == Editing || self.status == Prepareing) {
            cell.redpacket_amountLabel.hidden = YES;
        } else {
            cell.redpacket_amountLabel.hidden = NO;
            cell.redpacket_amountLabel.text = [NSString stringWithFormat:@"已领取：%@/%@",advert.bonus_accepted_num,advert.bonus_total_num];
        }
        
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        
        //初始化cell并指定其类型，也可自定义cell
        
        UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 100 - 50)];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        if (_isShowNoData) {
            tempLabel.text = @"暂无数据";
            
        } else {
            tempLabel.text = @"  ";
        }
        tempLabel.textColor = [UIColor colorWithHex:0x999999];
        [cell.contentView addSubview:tempLabel];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_advertlist.count > 0) {
        RAAdvert *advert = _advertlist[indexPath.row];
        if ([advert.advert_status intValue] == 1) {//草稿
            AdvertSendViewController *sendVC = [[AdvertSendViewController alloc] init];
            sendVC.jianlinsSatus = Editing;
            sendVC.advert = advert;
            sendVC.adv_id = advert.advert_id;
            
            [self.navigationController pushViewController:sendVC animated:YES];
        } else {
            AdvertDetailViewController *detailVC = [[AdvertDetailViewController alloc]init];
            if ([advert.advert_status intValue] == 12) {
                detailVC.isFinished = YES;
            } else {
                detailVC.isFinished = NO;
            }
            detailVC.temAdvert = advert;
            detailVC.adv_id = advert.advert_id;
            detailVC.status = self.status;
            detailVC.title = @"广告详情";
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_advertlist.count > 0) {
        return 165;
    } else {
        return UIScreenHeight - 100 - 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

#pragma mark - button action
- (void)applyRemainAction:(UIButton *)sender {
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    
    RAAdvert *advert = _advertlist[sender.tag];
    
    _currentAdvert = advert;
    
    if (_applyStatus == 2) {
        if ([_clickRowArrays containsObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]]) {
            RefundLogViewController *vc = [[RefundLogViewController alloc] init];
            vc.advert = advert;
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
        }
    }
    
    if ([advert.refund_status intValue] == 0) {
        
        [_clickRowArrays addObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        
        self.refundAdvert = advert;
        
        NSString *titleStr = nil;
        
        if ([advert.bonus_accepted_num intValue] == [advert.bonus_total_num intValue]) {
            titleStr = @"您确定要申请结算吗？";
        } else {
            titleStr = @"您确定要申请余额退款吗？";
        }
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:titleStr message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        alertView.delegate = self;
        [alertView showTarget:self];
        
        
        _refund_adv_id = advert.advert_id;
    } else if ([advert.refund_status intValue] == 1||[advert.refund_status intValue] == 2) {
        RefundLogViewController *vc = [[RefundLogViewController alloc] init];
        vc.advert = advert;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)sureAcion {
    [MBProgressHUD showMessag:nil toView:self.view];
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"PRODUCER";
    
    NSMutableDictionary *programDic = [[NSMutableDictionary alloc]init];
    [programDic setObject:_refund_adv_id forKey:@"adv_id"];
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.isVlaueKey = YES;
    
    [request Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PostAdvertisementRefund completed:^(id data, NSString *stringData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data) {
            if ([_currentAdvert.bonus_accepted_num intValue] != [_currentAdvert.bonus_total_num intValue]) {
                RefundLogViewController *vc = [[RefundLogViewController alloc] init];
                vc.advert = _currentAdvert;
                [self.navigationController pushViewController:vc animated:YES];
                _applyStatus = 2;
            } else {
                _applyStatus = 1;

            }
            
            [self.mainTableView reloadData];
            
            [RADBTool deleteObjectById:_refund_adv_id fromTable:kSenderAdvertisementDetailTableName withComplete:nil];
            
        } else {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"申请退款失败,请重试"];
            [alertView showTarget:self];
        }
    } failed:^(RAError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"申请退款失败,请重试"];
        [alertView showTarget:self];
    }];
    
}

#pragma mark - Https
- (void)getAdvertListDataWithStatus:(NSString *)status {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:status withTableName:kAdvertTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"PRODUCER";
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"limit"] = @"10";
        apiDic[@"offset"] = [NSString stringWithFormat:@"%ld",(long)_offset];
        apiDic[@"status"] = status;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSenderAdvertisementList completed:^(id data, NSString *stringData) {
            NSArray *dataArray = data[@"data"][@"list"];
            if (dataArray.count > 0) {
                
                if (_offset == 0) {
                    [_advertlist removeAllObjects];
                    
                }
                if (dataArray.count < 10) {
                    self.mainTableView.mj_footer.hidden = YES;
                    [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.mainTableView.mj_footer.hidden = NO;
                    [self.mainTableView.mj_footer resetNoMoreData];
                }
                
                [_advertlist addObjectsFromArray:[RAAdvert mj_objectArrayWithKeyValuesArray:dataArray]];
                
                [RADBTool putObject:data withId:status intoTable:kAdvertTableName withComplete:nil];
                
            } else {
                self.mainTableView.mj_footer.hidden = YES;
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                if (_offset == 0) {
                    [_advertlist removeAllObjects];
                }
            }
            
            if (_advertlist.count == 0) {
                _isShowNoData = YES;
            } else {
                _isShowNoData = NO;
            }
            
            [self.mainTableView reloadData];
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
        } failed:^(RAError *error) {
            [_advertlist removeAllObjects];
            
            NSArray *dataArray = item.itemObject[@"data"][@"list"];
            [_advertlist addObjectsFromArray:[RAAdvert mj_objectArrayWithKeyValuesArray:dataArray]];
            if (_advertlist.count == 0) {
                _isShowNoData = YES;
            } else {
                _isShowNoData = NO;
            }
            
            [self.mainTableView reloadData];
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
        }];
    } else {
        [_advertlist removeAllObjects];
        
        NSArray *dataArray = item.itemObject[@"data"][@"list"];
        [_advertlist addObjectsFromArray:[RAAdvert mj_objectArrayWithKeyValuesArray:dataArray]];
        
        if (_advertlist.count == 0) {
            _isShowNoData = YES;
        } else {
            _isShowNoData = NO;
        }
        
        [self.mainTableView reloadData];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }

}

-(void)againRequest{
    [super againRequest];
    
    [self loadNewData];
    
}


@end
