//
//  AdvertDetailViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertDetailViewController.h"
#import "RAAdvert.h"
#import "SDCycleScrollView.h"
#import "AdvertDetailTitleCell.h"
#import "AdvertDetailDescripeCell.h"
#import "AdvertStoreCell.h"
#import "AdvertDetailSetupCell.h"
#import "AdvertDetailRedpacketCell.h"
#import "AdvertDetailArrivalCell.h"
#import "AdvertDetailRemainCell.h"
#import "AdvertSendViewController.h"
#import "PayMoneyViewController.h"
#import "RARedpacket.h"
#import "AdvertArriveViewController.h"
#import "SingleWebViewController.h"

static NSString *const kAdvertDetailTitleCellIdentifier = @"AdvertDetailTitleCellID";
static NSString *const kAdvertDetailDescripeCellIdentifier = @"AdvertDetailDescripeCellID";
static NSString *const kAdvertStoreCellIdentifier = @"AdvertStoreCellID";
static NSString *const kAdvertDetailSetupCellIdentifier = @"AdvertDetailSetupCellID";
static NSString *const kAdvertDetailRedpacketCellIdentifier = @"AdvertDetailRedpacketCellID";
static NSString *const kAdvertDetailArrivalCellIdentifier = @"AdvertDetailArrivalCellID";
static NSString *const kAdvertDetailRemainCellIdentigier = @"AdvertDetailRemainCellID";

@interface AdvertDetailViewController () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
{
    BOOL _descripeScan;//查看全部广告内容，默认不查看
    
    NSMutableArray *_pub_addressArrays;//投放地址数组
    
    NSString *_str1;
    NSString *_str2;
    NSString *_str3;
}

@property (nonatomic, strong) RAAdvert *advert;

@property (nonatomic, strong) RARedpacket *redpacket;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (strong, nonatomic) UIView *tableViewHeader;

@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@end

@implementation AdvertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pub_addressArrays = [NSMutableArray array];
    
    [self initTableView];
    
    if (self.status == Editing) {
        [self.bottomButton setTitle:@"立即付款" forState:UIControlStateNormal];
    } else {
        [self.bottomButton setTitle:@"再次发布" forState:UIControlStateNormal];
    }
    
    if (self.isScan) {
        self.bottomViewHeight.constant = 0;
    }
    [self getAdvertDetailData];
    
    [self getAdvertPublishdetailData];
    
    [self getAdvertisementbonusData];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-white-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:AdvertListIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.status == Sending) {
        return 6;
    } else if (self.status == Finished) {
        if ([self.advert.refund_status intValue] == 0) {
            return 6;
        } else {
            return 7;
        }
        
    } else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.advert.advert_title.length > 0) {
        switch (indexPath.section) {
            case 0:
            {
                AdvertDetailTitleCell *detailTitleCell = [tableView dequeueReusableCellWithIdentifier:kAdvertDetailTitleCellIdentifier];
                
                detailTitleCell.adv_titleLabel.text = self.advert.advert_title;
                
                // 调整行间距
                CGFloat height = [self.advert.advert_title sizeOfStringFont:[UIFont systemFontOfSize:15] width:UIScreenWidth - 28].height;
                if (height > 18) {
                    detailTitleCell.adv_titleLabel.attributedText = [UILabel RALabelAttributedString:self.advert.advert_title lineSpacing:11];
                }
                
                detailTitleCell.adv_companyLabel.text = self.advert.pub_user_name;
                
                return detailTitleCell;
                
                break;
            }
            case 1:
            {
                AdvertDetailDescripeCell *descripeCell = [tableView dequeueReusableCellWithIdentifier:kAdvertDetailDescripeCellIdentifier];
                descripeCell.advert_descripeLabel.text = self.advert.advert_description;
                
                // 调整行间距
                CGFloat height = [self.advert.advert_description sizeOfStringFont:[UIFont systemFontOfSize:13] width:UIScreenWidth - 28].height;
                if (height > 16) {
                    descripeCell.advert_descripeLabel.attributedText = [UILabel RALabelAttributedString:self.advert.advert_description lineSpacing:11];
                }
                
                if (!_descripeScan) {
                    if (height > 64) {
                        descripeCell.advert_descripeLabel.numberOfLines = 4;
                    } else {
                        descripeCell.advert_descripeLabel.numberOfLines = 0;
                    }
                } else {
                    descripeCell.advert_descripeLabel.numberOfLines = 0;
                }
                
                
                [descripeCell.updownButton addTarget:self action:@selector(upOrDownAction) forControlEvents:UIControlEventTouchUpInside];
                return descripeCell;
                break;
            }
            case 2:
            {
                AdvertStoreCell *storeCell = [tableView dequeueReusableCellWithIdentifier:kAdvertStoreCellIdentifier];
                NSString *linkStr = self.advert.advert_content[@"link"];
                if (linkStr.length > 0) {
                    NSString *link_labelStr = self.advert.advert_content[@"link_label"];
                    if (link_labelStr.length > 0) {
                        storeCell.link_labelLabel.text = [NSString stringWithFormat:@" %@ ",link_labelStr];
                    } else {
                        storeCell.link_labelLabel.text = @" 进去看看 ";
                    }
                    [storeCell.linkTapButton addTarget:self action:@selector(linkTap:) forControlEvents:UIControlEventTouchUpInside];
                    storeCell.advert_store_linkLabel.text = self.advert.advert_content[@"link"];
                } else {
                    storeCell.link_labelLabel.hidden = YES;
                }
                
                
                CGRect fram = storeCell.link_labelLabel.frame;
                fram.size.width = 100;
                storeCell.link_labelLabel.frame = fram;
                
                storeCell.advert_store_telLabel.text = self.advert.advert_content[@"contact_phone"];
                
                storeCell.advert_store_addressLabel.text = self.advert.contact_address;
                
                return storeCell;
                break;
            }
            case 3:
            {
                AdvertDetailSetupCell *setupCell = [tableView dequeueReusableCellWithIdentifier:kAdvertDetailSetupCellIdentifier];
                setupCell.begin_timeLabel.text = [NSDate dateWithTimeIntervalString:self.advert.pub_begin_time withDateFormatter:nil];
                setupCell.end_timeLabel.text = [NSDate dateWithTimeIntervalString:self.advert.pub_end_time withDateFormatter:nil];
                setupCell.addressArrays = _pub_addressArrays;
                
                return setupCell;
                break;
            }
            case 4:
            {
                AdvertDetailRedpacketCell *redpacketCell = [tableView dequeueReusableCellWithIdentifier:kAdvertDetailRedpacketCellIdentifier];
                [redpacketCell initRedpacketData:self.redpacket];
                return redpacketCell;
                break;
            }
            case 5:
            {
                AdvertDetailArrivalCell *arrvialCell = [tableView dequeueReusableCellWithIdentifier:kAdvertDetailArrivalCellIdentifier];
                arrvialCell.amountLabel.text = [NSString stringWithFormat:@"%@/%@",self.temAdvert.bonus_accepted_num,self.temAdvert.bonus_total_num];
                NSString *str1 = [NSString setNumLabelWithStr:self.advert.bonus_accepted_amount];
                NSString *str2 = [NSString setNumLabelWithStr:self.redpacket.prize_total_money];
                arrvialCell.priceLabel.text = [NSString stringWithFormat:@"¥%@/¥%@",str1,str2];
                if (self.status == Sending) {
                    arrvialCell.scanDetailButton.hidden = YES;
                } else if ([self.advert.refund_status intValue] == 0) {
                    arrvialCell.scanDetailButton.hidden = YES;
                } else {
                    arrvialCell.scanDetailButton.hidden = NO;
                    
                    [arrvialCell.scanDetailButton addTarget:self action:@selector(arrivalAction) forControlEvents:UIControlEventTouchUpInside];
                }
                
                return arrvialCell;
                break;
            }
            case 6:
            {
                AdvertDetailRemainCell *remainCell = [tableView dequeueReusableCellWithIdentifier:kAdvertDetailRemainCellIdentigier];
                NSInteger num = [self.advert.bonus_total_num integerValue] - [self.advert.bonus_accepted_num integerValue];
                
                if ([self.advert.refund_status intValue] == 9 || [self.advert.refund_status intValue] == 8) {
                    remainCell.return_numbriefLabel.text = @"退回红包";
                    remainCell.return_pricebriefLabel.text = @"退回金额";
                } else {
                    remainCell.return_numbriefLabel.text = @"可退红包";
                    remainCell.return_pricebriefLabel.text = @"可退金额";
                }
                    
                remainCell.reture_amountLabel.text = [NSString stringWithFormat:@"%ld",num];
                remainCell.return_priceLabel.text = [NSString setNumLabelWithStr:[NSString stringWithFormat:@"%@",self.advert.refund_total_amount]];
                return remainCell;
                break;
                
            }
            default:
            {
                static NSString *CellIdentifier = @"Cell";
                
                //初始化cell并指定其类型，也可自定义cell
                
                UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                }
                
                return cell;
                break;
            }
        }
    } else {
        static NSString *CellIdentifier = @"Cell";
        
        //初始化cell并指定其类型，也可自定义cell
        
        UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithHex:0xeeeeee];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat height = [self.advert.advert_title sizeOfStringFont:[UIFont systemFontOfSize:15] width:UIScreenWidth - 28].height;
        return height + 15 + 38 + 13 + (height/18 - 1)*11;
    } else if (indexPath.section == 1) {
        if (_descripeScan) {
            CGFloat height = [self.advert.advert_description sizeOfStringFont:[UIFont systemFontOfSize:13] width:UIScreenWidth - 28].height;
            return height + 40 + 40 + (height/16 - 1)*11;
        } else {
            CGFloat height = [self.advert.advert_description sizeOfStringFont:[UIFont systemFontOfSize:13] width:UIScreenWidth - 28].height;
            if (height > 64) {
                return 64 + 40 + 40 + (64/16 - 1)*11;
            } else {
                return height + 40 + 40 + (height/16 - 1)*11;
            }
        }
    } else if (indexPath.section == 2) {
        return 145;
    } else if (indexPath.section == 3) {
        CGFloat returnHeight = 0;
        CGFloat width = UIScreenWidth - 64 - 24 - 16;
        if (_str1) {
            CGFloat height = [_str1 sizeOfStringFont:[UIFont systemFontOfSize:13] width:width].height;
            
            if (height > 16) {
                returnHeight = (height  + 24 + 9) + returnHeight;
            } else {
                returnHeight =  (height  + 24) + returnHeight;
            }
        }
        if (_str2) {
            CGFloat height = [_str2 sizeOfStringFont:[UIFont systemFontOfSize:13] width:width].height;
            
            if (height > 16) {
                returnHeight = (height  + 24 + 9) + returnHeight;
            } else {
                returnHeight =  (height  + 24) + returnHeight;
            }
        }
        if (_str3) {
            CGFloat height = [_str3 sizeOfStringFont:[UIFont systemFontOfSize:13] width:width].height;
            if (height > 16) {
                returnHeight = (height  + 24 + 9) + returnHeight;
            } else {
                returnHeight =  (height  + 24) + returnHeight;
            }
        }
        
        return returnHeight + 75;
        
    } else if (indexPath.section == 4) {
        return 294;
    } else if (indexPath.section == 5) {
        return 103;
    } else if (indexPath.section == 6) {
        return 77;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}
#pragma mark - Button Action
- (IBAction)publishAction:(id)sender {
    if (self.status == Editing) {
        PayMoneyViewController *payVC = [[PayMoneyViewController alloc] init];
        payVC.adv_id = self.advert.advert_id;
        payVC.moneyStr = self.advert.bonus_total_amount;
        payVC.shareSuccesssTitle = self.advert.advert_title;
        NSArray *images = self.advert.advert_content[@"images"];
        if (images.count > 0) {
            payVC.shareImageURL = images[0];
        }
        [self.navigationController pushViewController:payVC animated:YES];
        
    } else {
        AdvertSendViewController *sendVC = [[AdvertSendViewController alloc] init];
        sendVC.advert = self.advert;
        sendVC.adv_id = self.advert.advert_id;
        sendVC.jianlinsSatus = self.status;
        [self.navigationController pushViewController:sendVC animated:YES];
    }
}

- (void)upOrDownAction {
    _descripeScan = !_descripeScan;
    
    [self.mainTableView reloadData];
}

- (void)arrivalAction {
    AdvertArriveViewController *vc = [[AdvertArriveViewController alloc] init];
    vc.advert = self.advert;
    vc.redpacket = self.redpacket;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)linkTap:(UIButton *)tap {
    SingleWebViewController *vc = [[SingleWebViewController alloc] init];
    vc.webUrl =  self.advert.advert_content[@"link"];
    vc.title = self.advert.advert_title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private
- (void)initTableView {
    self.mainTableView.tableHeaderView = self.tableViewHeader;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*4/3) imageNamesGroup:nil];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"bian_default_seating"];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView = cycleScrollView;
    
    //    self.mainTableView.estimatedRowHeight = 80;
    [self.tableViewHeader addSubview:cycleScrollView];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertDetailTitleCell" bundle:nil] forCellReuseIdentifier:kAdvertDetailTitleCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertDetailDescripeCell" bundle:nil] forCellReuseIdentifier:kAdvertDetailDescripeCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertStoreCell" bundle:nil] forCellReuseIdentifier:kAdvertStoreCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertDetailSetupCell" bundle:nil] forCellReuseIdentifier:kAdvertDetailSetupCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertDetailRedpacketCell" bundle:nil] forCellReuseIdentifier:kAdvertDetailRedpacketCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertDetailRemainCell" bundle:nil] forCellReuseIdentifier:kAdvertDetailRemainCellIdentigier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertDetailArrivalCell" bundle:nil] forCellReuseIdentifier:kAdvertDetailArrivalCellIdentifier];
}

- (UIView *)tableViewHeader{
    if (_tableViewHeader == nil) {
        _tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*4/3)];
    }
    return _tableViewHeader;
}

#pragma mark - Https
// 	 发布者-获取广告信息
- (void)getAdvertDetailData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:_adv_id withTableName:kSenderAdvertisementDetailTableName];
    NSInteger expirydate = 0;
    if (self.isFinished == YES) {
        expirydate = -1;
    }
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:expirydate]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"PRODUCER";
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = self.adv_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSenderAdvertisementDetail completed:^(id data, NSString *stringData) {
            if (data) {
                RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:data[@"data"][@"info"]];
                self.advert = advert;
                
                NSArray *imageURLs = advert.advert_content[@"images"];
                if (imageURLs.count != 0) {
                    self.cycleScrollView.imageURLStringsGroup = imageURLs;
                }
                
                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:_adv_id intoTable:kSenderAdvertisementDetailTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
            self.advert = advert;
            
            NSArray *imageURLs = advert.advert_content[@"images"];
            if (imageURLs.count != 0) {
                self.cycleScrollView.imageURLStringsGroup = imageURLs;
            }
        }];
    } else {
        RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
        self.advert = advert;
        
        NSArray *imageURLs = advert.advert_content[@"images"];
        if (imageURLs.count != 0) {
            self.cycleScrollView.imageURLStringsGroup = imageURLs;
        }
    }

}

// 	发布者-获取广告发布信息
- (void)getAdvertPublishdetailData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:_adv_id withTableName:kSenderAdvertisementPublishDetailTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:-1]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"PRODUCER";
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = self.adv_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSenderAdvertisementPublishDetail completed:^(id data, NSString *stringData) {
            if (data) {
                [_pub_addressArrays removeAllObjects];
                
                [_pub_addressArrays addObjectsFromArray:[RAAdvert mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                for (int i = 0; i < _pub_addressArrays.count; i++) {
                    if (i == 0) {
                        RAAdvert *advert = _pub_addressArrays[0];
                        _str1 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
                    } else if (i == 1) {
                        RAAdvert *advert = _pub_addressArrays[1];
                        _str2 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
                    } else {
                        RAAdvert *advert = _pub_addressArrays[2];
                        _str3 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
                    }
                }
                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:_adv_id intoTable:kSenderAdvertisementPublishDetailTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            [_pub_addressArrays removeAllObjects];
            
            [_pub_addressArrays addObjectsFromArray:[RAAdvert mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
            for (int i = 0; i < _pub_addressArrays.count; i++) {
                if (i == 0) {
                    RAAdvert *advert = _pub_addressArrays[0];
                    _str1 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
                } else if (i == 1) {
                    RAAdvert *advert = _pub_addressArrays[1];
                    _str2 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
                } else {
                    RAAdvert *advert = _pub_addressArrays[2];
                    _str3 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
                }
            }
            [self.mainTableView reloadData];
        }];
    } else {
        [_pub_addressArrays removeAllObjects];
        
        [_pub_addressArrays addObjectsFromArray:[RAAdvert mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        for (int i = 0; i < _pub_addressArrays.count; i++) {
            if (i == 0) {
                RAAdvert *advert = _pub_addressArrays[0];
                _str1 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
            } else if (i == 1) {
                RAAdvert *advert = _pub_addressArrays[1];
                _str2 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
            } else {
                RAAdvert *advert = _pub_addressArrays[2];
                _str3 = [NSString stringWithFormat:@"%@空格<%@",advert.pub_address,advert.pub_range];
            }
        }
        [self.mainTableView reloadData];
    }

}
// 	发布者-获取红包配置
-(void)getAdvertisementbonusData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:_adv_id withTableName:kSenderAdvertisementBonusTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:-1]) {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] =@"PRODUCER";
        NSMutableDictionary *apiDic=[[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = self.adv_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSenderAdvertisementBonus completed:^(id data, NSString *stringData) {
            if (data) {
                RARedpacket *redPacket = [RARedpacket mj_objectWithKeyValues:data[@"data"][@"info"]];
                self.redpacket = redPacket;
                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:_adv_id intoTable:kSenderAdvertisementBonusTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            RARedpacket *redPacket = [RARedpacket mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
            self.redpacket = redPacket;
            [self.mainTableView reloadData];
        }];
    } else {
        RARedpacket *redPacket = [RARedpacket mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
        self.redpacket = redPacket;
        [self.mainTableView reloadData];
    }
}

@end
