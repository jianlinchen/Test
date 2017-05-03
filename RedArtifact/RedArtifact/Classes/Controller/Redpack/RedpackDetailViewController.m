//
//  RedpackDetailViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RedpackDetailViewController.h"
#import "SDCycleScrollView.h"
#import "RedpacketStoreinfoCell.h"
#import "RedpacketAdvertinfoCell.h"
#import "RAAdvert.h"
#import "ReportViewController.h"
#import "StoreAddressViewController.h"
#import "RedpackRankViewController.h"
#import "RAShare.h"
#import "Server.h"
#import "SingleWebViewController.h"
#import "CustomAlertView.h"
#import "GuideImageView.h"

static NSString *kRedpacketStoreinfoCellIdentifier = @"RedpacketStoreinfoCellID";
static NSString *kRedpacketAdvertinfoCellIdentifier = @"RedpacketAdvertinfoCellID";

@interface RedpackDetailViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate,UMSocialUIDelegate,AlertViewSureDelegate>
{
    BOOL _descripeScan;//查看全部广告内容，默认不查看
    NSString *_bonus_money;//抢得得红包金额
    NSString *_bonus_time;//抢得红包时间
    
}

@property (nonatomic, strong) RAAdvert *advert;
/** tableView header */
@property (strong, nonatomic) UIView *tableViewHeader;
//未领取
@property (strong, nonatomic) IBOutlet UIView *noFooterView;
//已领取
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *rankButton;

@property (weak, nonatomic) IBOutlet UILabel *join_moneyLabel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

/** 头部轮播图 */
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;

/** 动画view */
@property (strong, nonatomic) IBOutlet UIView *animationView;

/** 静止光图片 */
@property (weak, nonatomic) IBOutlet UIImageView *static_lightImgView;

/** 静止花洒图片 */
@property (weak, nonatomic) IBOutlet UIImageView *static_flowerImgView;

/** 动画imageview */
@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;

/** 取消动画按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelAnimationButton;

/** 抢红包按钮 */
@property (weak, nonatomic) IBOutlet UIButton *getRedpacketButton;

/** 抢得红包后界面 */
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UILabel *red_amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *red_companyLabel;

//商户链接label
@property (weak, nonatomic) IBOutlet UILabel *store_linkLabel;


@end

@implementation RedpackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isScan) {
        self.title = @"预览";
    } else {
        self.title = @"红包详情";
    }
    
    
    _bonus_money = @"0";

    [self initTableView];
    
    if (self.isScan) {
        self.getRedpacketButton.enabled = NO;
        [self getScanAdvertDetailData];
    } else {
        [self getAdvertDetailData];
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-white-return-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.cancelAnimationButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.isScan) {
        [self showGuideImageView];
    }
}

- (void)showGuideImageView {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"advert-storeDetail-guideImg"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"advert-storeDetail-guideImg"];
        
        GuideImageView *guideImg = [[GuideImageView alloc] initWithImageName:@"advert-storeDetail-guideImg" withVerticalDirection:directionBottom];
        [guideImg showTarget:self];
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RedpackHostViewController" object:nil];

}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RedpacketStoreinfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kRedpacketStoreinfoCellIdentifier];
        infoCell.advert_titleLabel.text = self.advert.advert_title;
        // 调整行间距
        CGFloat height = [self.advert.advert_title sizeOfStringFont:[UIFont systemFontOfSize:15] width:UIScreenWidth - 28].height;
        if (height > 18) {
            infoCell.advert_titleLabel.attributedText = [UILabel RALabelAttributedString:self.advert.advert_title lineSpacing:11];
        }
        
        infoCell.advert_companyLabel.text = self.advert.pub_user_name;
        if (!self.isScan) {
            infoCell.reportBlock = ^(BOOL click) {
                if (click) {
                    ReportViewController *reportVC = [[ReportViewController alloc] init];
                    reportVC.redpacket = self.redpacket;
                    [self.navigationController pushViewController:reportVC animated:YES];
                }
            };
            infoCell.shareBlock = ^(BOOL click) {
                if (click) {
                    [self shareActon];
                }
            };
        }
        
        return infoCell;
    } else {
        RedpacketAdvertinfoCell *advertinfoCell = [tableView dequeueReusableCellWithIdentifier:kRedpacketAdvertinfoCellIdentifier];
        advertinfoCell.advert_descripeLabel.text = self.advert.advert_description;
        
        // 调整行间距
        CGFloat height = [self.advert.advert_description sizeOfStringFont:[UIFont systemFontOfSize:13] width:UIScreenWidth - 28].height;
        if (height > 16) {
            advertinfoCell.advert_descripeLabel.attributedText = [UILabel RALabelAttributedString:self.advert.advert_description lineSpacing:11];
        }
        
        if (!_descripeScan) {
            if (height > 64) {
                advertinfoCell.advert_descripeLabel.numberOfLines = 4;
            } else {
                advertinfoCell.advert_descripeLabel.numberOfLines = 0;
            }
        } else {
            advertinfoCell.advert_descripeLabel.numberOfLines = 0;
        }
        
        
        [advertinfoCell.updownButton addTarget:self action:@selector(upOrDownAction) forControlEvents:UIControlEventTouchUpInside];
        
        return advertinfoCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 148;
    } else {
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    
    [sectionView setBackgroundColor:[UIColor colorWithHex:0xeeeeee]];
    
    return sectionView;
    
}

#pragma mark - Button Action
//一键拨打
- (IBAction)callPhoneAction:(id)sender {
    NSString *str = self.advert.advert_content[@"contact_phone"];
    if (str.length > 0) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"拨打商户电话" message:self.advert.advert_content[@"contact_phone"] cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫"];
        alert.delegate = self;
        [alert showTarget:self];
    } else {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"商家未录入电话"];
        [alert showTarget:self];
    }
}

- (void)sureAcion {
    [Tools callPhoneWithTel:self.advert.advert_content[@"contact_phone"]];
}

//商户链接
- (IBAction)storeLinkAction:(id)sender {
    NSString *str = self.advert.advert_content[@"link"];
    if (str.length > 0) {
        SingleWebViewController *webVC = [[SingleWebViewController alloc] init];
        webVC.webUrl = self.advert.advert_content[@"link"];
        NSString *link_label = self.advert.advert_content[@"link_label"];
        if (link_label.length == 0) {
            link_label = @"商户链接";
        }
        webVC.title = link_label;
        [self.navigationController pushViewController:webVC animated:YES];
    } else {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"商家未录入链接"];
        [alert showTarget:self];
    }
    
    
}
//商家地址
- (IBAction)storeAddressAction:(id)sender {
    if (self.advert.contact_address.length > 0) {
        StoreAddressViewController *addressVC = [[StoreAddressViewController alloc] init];
        addressVC.advert = self.advert;
        [self.navigationController pushViewController:addressVC animated:YES];
    } else {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"商家未录入位置"];
        [alert showTarget:self];
    }
    
}
//排行榜
- (IBAction)rankAction:(id)sender {
    RedpackRankViewController *rankVC = [[RedpackRankViewController alloc] init];
    if (self.status == Involved) {
        rankVC.adv_id = self.consumer.adv_id;
        rankVC.bonus_money = self.consumer.money;
        rankVC.bonus_time = self.consumer.create_time;
    } else {
        rankVC.adv_id = self.advert.advert_id;
        rankVC.bonus_money = _bonus_money;
        rankVC.bonus_time = _bonus_time;
    }
    [self.navigationController pushViewController:rankVC animated:YES];
    
}
//抢红包
- (IBAction)redpackAction:(id)sender {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    [self getRedpacketData];
}
//查看详情
- (void)upOrDownAction {
    _descripeScan = !_descripeScan;
    
    [self.mainTableView reloadData];
}
//取消动画页面
- (IBAction)cancelAnimationView:(id)sender {
    [_animationImgView stopAnimating];
    [self.static_lightImgView stopAnimating];
    
    self.join_moneyLabel.text = [NSString stringWithFormat:@"¥ %@", [NSString setNumLabelWithStr:_bonus_money]];
    self.rankButton.layer.borderColor = [UIColor colorWithHex:0xfea000].CGColor;
    self.mainTableView.tableFooterView = self.footerView;
    
    [self.animationView removeFromSuperview];
    
    self.detailView.hidden = YES;
    self.static_flowerImgView.image = [UIImage imageNamed:@"kongbai"];
    self.static_lightImgView.image = [UIImage imageNamed:@"kongbai"];
}

- (void)shareActon {
    Server *server = [Server shareInstance];
    if (server.promotion_share_info[@"content"]==nil) {
        [Tools getServerKeyConfig];
        
        return;
    }
    

    
    NSString *shareText   = @"分享内容";
    if (self.status == Involved) {
        NSString *mbMonStr=[NSString setNumLabelWithStr:self.consumer.money];
        NSString *tempStr = server.description_on_accepted_redpacket_share;
        
        shareText = [tempStr stringByReplacingOccurrencesOfString:@"{BONUS_MONEY}" withString:mbMonStr];
    } else {
        shareText = server.description_unaccepted_redpacket_share;
    }
    
    NSArray *imageArrays  = self.advert.advert_content[@"images"];
    
    if (imageArrays.count > 0) {
        [RAShare presentSnsIconSheetView:self shareTitle:server.redpacket_share_title shareText:shareText shareImage:imageArrays[0] shareLinkURL:server.share_link delegate:nil];
    } else {
        [RAShare presentSnsIconSheetView:self shareTitle:server.redpacket_share_title shareText:shareText shareImage:nil shareLinkURL:server.share_link delegate:nil];
    }
}
#pragma mark - view
- (void)initTableView {
    self.mainTableView.tableHeaderView = self.tableViewHeader;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*4/3) imageNamesGroup:nil];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"bian_default_seating"];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView = cycleScrollView;
    [self.tableViewHeader addSubview:cycleScrollView];
    
    //register cell
    if (self.status == NotInvolved) {
        self.mainTableView.tableFooterView = self.noFooterView;
    } else {
        self.join_moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:self.consumer.money]];
        self.rankButton.layer.borderColor = [UIColor colorWithHex:0xfea000].CGColor;
        self.mainTableView.tableFooterView = self.footerView;
    }
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"RedpacketStoreinfoCell" bundle:nil] forCellReuseIdentifier:kRedpacketStoreinfoCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"RedpacketAdvertinfoCell" bundle:nil] forCellReuseIdentifier:kRedpacketAdvertinfoCellIdentifier];
}

#pragma mark - Property
- (UIView *)tableViewHeader{
    if (_tableViewHeader == nil) {
        _tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenWidth*4/3)];
    }
    return _tableViewHeader;
}

#pragma mark - Https
// 	 预览-获取广告信息
- (void)getScanAdvertDetailData {
    NSString *adv_idStr = nil;
    
    adv_idStr = self.scanAdv_id;
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"PRODUCER";
    
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    apiDic[@"adv_id"] = adv_idStr;
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSenderAdvertisementDetail completed:^(id data, NSString *stringData) {
        if (data) {
            RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:data[@"data"][@"info"]];
            self.advert = advert;
            
            NSArray *imageURLs = advert.advert_content[@"images"];
            if (imageURLs.count != 0) {
                self.cycleScrollView.imageURLStringsGroup = imageURLs;
            }
            
            [self.mainTableView reloadData];
            
            NSString *link_label = self.advert.advert_content[@"link_label"];
            if (link_label.length == 0) {
                link_label = @"商户链接";
            }
            self.store_linkLabel.text = link_label;
            
        }
        
    } failed:^(RAError *error) {
        
    }];

}
// 	 发布者-获取广告信息
- (void)getAdvertDetailData {
    NSString *adv_idStr = nil;

    if (self.status == NotInvolved) {
        adv_idStr = self.redpacket.adv_id;
    } else {
        adv_idStr = self.consumer.adv_id;
    }
    
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:adv_idStr withTableName:kRedpacketTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:-1]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"CONSUMER";

        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = adv_idStr;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSenderAdvertisementDetail completed:^(id data, NSString *stringData) {
            if (data) {
                RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:data[@"data"][@"info"]];
                self.advert = advert;
                
                NSArray *imageURLs = advert.advert_content[@"images"];
                if (imageURLs.count != 0) {
                    self.cycleScrollView.imageURLStringsGroup = imageURLs;
                }
                
                [self.mainTableView reloadData];
                
                NSString *link_label = self.advert.advert_content[@"link_label"];
                if (link_label.length == 0) {
                    link_label = @"商户链接";
                }
                self.store_linkLabel.text = link_label;
                
                [RADBTool putObject:data withId:adv_idStr intoTable:kRedpacketTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            if (error.code == 13000029) {
                self.getRedpacketButton.hidden = YES;
            }
            RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
            self.advert = advert;
            
            NSArray *imageURLs = advert.advert_content[@"images"];
            if (imageURLs.count != 0) {
                self.cycleScrollView.imageURLStringsGroup = imageURLs;
            }
            
            NSString *link_label = self.advert.advert_content[@"link_label"];
            if (link_label.length == 0) {
                link_label = @"商户链接";
            }
            self.store_linkLabel.text = link_label;
            
            [self.mainTableView reloadData];
        }];
    } else {
        RAAdvert *advert = [RAAdvert mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
        self.advert = advert;
        
        NSArray *imageURLs = advert.advert_content[@"images"];
        if (imageURLs.count != 0) {
            self.cycleScrollView.imageURLStringsGroup = imageURLs;
        }
        
        NSString *link_label = self.advert.advert_content[@"link_label"];
        if (link_label.length == 0) {
            link_label = @"商户链接";
        }
        self.store_linkLabel.text = link_label;
        
        [self.mainTableView reloadData];
    }

}
/** 抢红包 */
- (void)getRedpacketData {
    [MBProgressHUD showMessag:@"" toView:self.view];
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"CONSUMER";
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    [apiDic setObject:self.redpacket.adv_id forKey:@"adv_id"];
    [apiDic setObject:self.redpacket.pub_id forKey:@"pub_id"];
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetConsumerAdvertisementBonus completed:^(id data, NSString *stringData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data) {
            _bonus_money = data[@"data"][@"bonus"] ? data[@"data"][@"bonus"] : @" ";
            _bonus_time = data[@"data"][@"accept_time"] ? data[@"data"][@"accept_time"] : @" ";
            
            [self addAnimationView];
            
            [RADBTool deleteObjectById:self.redpacket.adv_id fromTable:kRedpacketTableName withComplete:^(RAError *error) {
                if (error) {
                    NSLog(@"%@",error.errorDetail);
                }
            }];
        }
        
    } failed:^(RAError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail];
            [alertView showTarget:self];
        }
    }];
}
#pragma 动画处理
- (void)addAnimationView {
    
    [self.animationView removeFromSuperview];
    self.animationView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    
    [self.view.window addSubview:_animationView];
    
    self.red_companyLabel.text = self.advert.pub_user_name;
    
    self.red_amountLabel.text = [NSString stringWithFormat:@"¥ %@", [NSString setNumLabelWithStr:_bonus_money]];
    
    //创建一个数组，数组中按顺序添加要播放的图片（图片为静态的图片）
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=0; i<35; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"jinbi_%02d",i]];
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
    _animationImgView.animationImages = imgArray;
    //设置执行一次完整动画的时长
    _animationImgView.animationDuration = 35*0.06;
    //动画重复次数 （0为重复播放）
    _animationImgView.animationRepeatCount = 1;
    //开始播放动画
    [_animationImgView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.static_flowerImgView.image = [UIImage imageNamed:@"flower"];
        self.detailView.hidden = NO;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_animationImgView stopAnimating];
        self.static_lightImgView.image = [UIImage imageNamed:@"guang"];
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 1.0];
        rotationAnimation.duration = 6;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 100;
        
        [self.static_lightImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        self.cancelAnimationButton.enabled = YES;
    });
}


@end
