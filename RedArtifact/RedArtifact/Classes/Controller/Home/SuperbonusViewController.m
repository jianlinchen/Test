//
//  SuperbonusViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/21.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "SuperbonusViewController.h"
#import "BeforePrizeViewController.h"
#import "SingleWebViewController.h"
#import "BeforePeopleCell.h"
#import "BeforePrizeScanViewController.h"
#import "RAShare.h"
#import "Server.h"
#import "SingleWebViewController.h"
#import "SuperbonusStatusViewController.h"

static NSString *const kBeforePeopleCellIdentifier = @"BeforePeopleCellID";

@interface SuperbonusViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
{
    NSMutableArray *_beforePeopleArrays;
    
    BOOL _isJoin;//是否参与了活动
    
    BOOL _isOpenPrize;//是否开奖
    
    NSString *_ticket_id;

    NSArray *_reward_users;//获奖人数
    
    //超级大红包当前时间
    NSString *_superbonus_current_time;
}

@property (nonatomic, strong) RASuperbonus *superbonus;

@property (strong, nonatomic) UIScrollView *mainScrollView;

//广告图
@property (strong, nonatomic) IBOutlet UIView *advertView;
@property (weak, nonatomic) IBOutlet UIImageView *advertImgView;
@property (weak, nonatomic) IBOutlet UIButton *advertTimeBut;

@property (strong, nonatomic) IBOutlet UIView *mainBackView;

//show data
@property (weak, nonatomic) IBOutlet UILabel *superbonus_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_peopleLabel;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_companyLabel;

//join view
@property (weak, nonatomic) IBOutlet UIView *inputKeyView;
@property (weak, nonatomic) IBOutlet UITextField *inputKeyField;
@property (weak, nonatomic) IBOutlet UIView *join_text_view;
@property (weak, nonatomic) IBOutlet UIView *inputFieldView;
@property (weak, nonatomic) IBOutlet UIButton *join_cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *join_sureButton;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_join_ticketLabel;

//show view
@property (strong, nonatomic) IBOutlet UIView *peopleBeforeView;
@property (strong, nonatomic) IBOutlet UIView *joinView;

@property (strong, nonatomic) UIView *joinSuccessBackView;
@property (strong, nonatomic) IBOutlet UIView *joinSuccessView;


@property (strong, nonatomic) UICollectionView *beforePeopleCollectionView;

//layoutConstraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *superbonus_introduceViewHeight;
/*
 * 是否参与：参与：0 未参与：67
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isJoinHeight;


// button
@property (weak, nonatomic) IBOutlet UIButton *joinButton;


@end

@implementation SuperbonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _beforePeopleArrays = [NSMutableArray array];
    _reward_users = [NSArray array];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"往期得主" style:UIBarButtonItemStylePlain target:self action:@selector(peopleBeforeAction)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    self.mainScrollView.bounces = NO;
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.mainBackView];
    
    [self showBackViewData];
    
    
    [self addAdvertImageView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.peopleBeforeView removeFromSuperview];
}

- (void)addAdvertImageView {
    
    if (self.lastSuperbonus.images.count > 0) {
        int x = arc4random() % self.lastSuperbonus.images.count;
        NSString *imageStr = self.lastSuperbonus.images[x];
        [_advertImgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    self.advertView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    
    [self.view insertSubview:self.advertView aboveSubview:self.view];
    
    
    [Tools setTimerWithTimecount:5 timerRuning:^(NSString *tiemStr) {
        
        [self getSuperbonusDetail];
        
        [self isJoinData];
        
    } tiemrInvalid:^(BOOL invalid) {
        if (invalid) {
            
            [_advertView removeFromSuperview];
            
            self.navigationController.navigationBarHidden = NO;
            
            [self.advertView removeFromSuperview];
        }
    }];
    
}

- (void)isJoinData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:[NSString stringWithFormat:@"join%@",_event_id] withTableName:kSuperbonusTableName];
    if ([item.itemObject[@"join_state"] intValue] == 1) {
        _ticket_id = item.itemObject[@"ticket_id"];
        _isJoin = YES;
        self.isJoinHeight.constant = 0;
        [self.joinButton setTitle:@"已参与" forState:UIControlStateNormal];
        [self.joinButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [self.joinButton setBackgroundColor:[UIColor colorWithHex:0x43ADAC]];
        
    } else {
        self.isJoinHeight.constant = 0;
    }
}

- (void)getSuperbonusDetail {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:_event_id withTableName:kSuperbonusTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] = @"CONSUMER";
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"event_id"] = self.event_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetSuperbonusDetail completed:^(id data, NSString *stringData) {
            if (data) {
                self.superbonus = [RASuperbonus mj_objectWithKeyValues:data[@"data"][@"info"]];
                
                _superbonus_current_time = data[@"data"][@"current_time"];
                
                _reward_users = data[@"data"][@"info"][@"reward_users"];
                
                [RADBTool putObject:data withId:_event_id intoTable:kSuperbonusTableName withComplete:nil];
                
                [self showDetailData];
            } else {
                [self showBackViewData];
            }
            
            [self joinStatus];
        } failed:^(RAError *error) {
            if (item.itemObject) {
                self.superbonus = [RASuperbonus mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
                
                [self showDetailData];
            } else {
                [self showBackViewData];
            }
            
        }];
    } else {
        if (item.itemObject) {
            self.superbonus = [RASuperbonus mj_objectWithKeyValues:item.itemObject[@"data"][@"info"]];
            
            [self showDetailData];
        } else {
            [self showBackViewData];
        }
    }
}

- (void)showDetailData {
    self.superbonus_timeLabel.text = self.superbonus.end_time_str;
    self.superbonus_titleLabel.text = self.superbonus.event_name;
    self.superbonus_moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:self.superbonus.bonus_money]];
    
    self.superbonus_peopleLabel.text = [NSString stringWithFormat:@"参与人数：%@人",self.superbonus.user_count ? self.superbonus.user_count : @"0"];
    
    self.superbonus_companyLabel.text = self.superbonus.merchant_name;
    
    CGFloat height = [self.self.superbonus.superbonus_description sizeOfStringFont:[UIFont systemFontOfSize:13] width:240].height;
    if (height > 18) {
        self.superbonus_descriptionLabel.attributedText = [UILabel RALabelAttributedString:self.superbonus.superbonus_description lineSpacing:12];
    }
    self.superbonus_introduceViewHeight.constant = 200 + height + 12*(height/15 - 1);

    [self showBackViewData];
}

#pragma mark - get/set
- (UICollectionView *)beforePeopleCollectionView {
    if (_beforePeopleCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing           = 0;
        flowLayout.minimumInteritemSpacing      = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 54, UIScreenWidth, 110) collectionViewLayout:flowLayout];
        collectionView.dataSource      = self;
        collectionView.delegate        = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor colorWithHex:0xdddddd];
        [collectionView registerNib:[UINib nibWithNibName:@"BeforePeopleCell" bundle:nil] forCellWithReuseIdentifier:kBeforePeopleCellIdentifier];
        _beforePeopleCollectionView = collectionView;
        
    }
    return _beforePeopleCollectionView;
}

#pragma mark - data
- (void)showBackViewData {

    self.mainScrollView.contentSize = CGSizeMake(UIScreenWidth, 369 + self.superbonus_introduceViewHeight.constant + 335 + 64);

    self.mainBackView.frame = CGRectMake(0, 0, UIScreenWidth, 369 + self.superbonus_introduceViewHeight.constant + 335 + 64);

}

#pragma mark - UICollectionView datasource/delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _beforePeopleArrays.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BeforePeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBeforePeopleCellIdentifier forIndexPath:indexPath];
    RASuperbonus *superbonus = _beforePeopleArrays[indexPath.section];
    NSArray *images = superbonus.images;
    if (images.count > 0) {
        [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    }
    cell.superbonus_titleLabel.text = [NSString stringWithFormat:@"活动·%@",superbonus.event_name];
    cell.superbonus_moneyLabel.text = [NSString stringWithFormat:@"获奖金额¥%@",[NSString setNumLabelWithStr:superbonus.bonus_money]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(160, 110);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    RASuperbonus *superbonus = _beforePeopleArrays[indexPath.section];
//    BeforePrizeScanViewController *vc = [[BeforePrizeScanViewController alloc] init];
//    vc.superbonus = superbonus;
//    vc.title = superbonus.event_name;
//    [self.navigationController pushViewController:vc animated:YES];
    RASuperbonus *superbonus = _beforePeopleArrays[indexPath.section];
    SingleWebViewController *vc = [[SingleWebViewController alloc] init];
    vc.webUrl = superbonus.reward_page;
    vc.title = superbonus.event_name;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ButtonAction
- (void)peopleBeforeAction {
    [self.inputKeyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.inputFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.inputKeyField.text = nil;
    [self.joinView removeFromSuperview];
    self.peopleBeforeView.frame = CGRectMake(0, 20, UIScreenWidth, UIScreenHeight);
    [self.view.window addSubview:self.peopleBeforeView];
    
    [self getSuperbonusReport];
    
}

- (IBAction)removePeopleBeforeViewAction:(id)sender {
    [self.peopleBeforeView removeFromSuperview];
}

- (IBAction)joinAction:(id)sender {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if (_isOpenPrize) {
        [self superbonusReward];
        
    } else {
        if (_isJoin) {
            [self joinSuccessShow];
        } else {
            self.joinView.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
            self.inputKeyField.delegate = self;//设置代理
            self.inputKeyField.tintColor = [UIColor clearColor];//看不到光标
            self.inputKeyField.textColor = [UIColor clearColor];//看不到输入内容
            
            self.join_cancelButton.titleLabel.font = [UIFont fontWithName:@"HYYanLingJ" size:15];
            self.join_sureButton.titleLabel.font = [UIFont fontWithName:@"HYYanLingJ" size:15];
            
            [self setInputKeyViewData];
            [self.view addSubview:self.joinView];
            
            [self.inputKeyField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
            [self inputFieldViewAddLabel];
            
        }
    }
}

//立即兑奖
- (void)superbonusReward {
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"CONSUMER";
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    apiDic[@"event_id"] = self.event_id;
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetsuperbonusReward completed:^(id data, NSString *stringData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data) {
            if ([data[@"data"][@"reward_info"][@"joined"] boolValue] == NO) {
                SuperbonusStatusViewController *vc = [[SuperbonusStatusViewController alloc] init];
                vc.title = @"红包兑奖";
                vc.joinStatus = 1;//未参与
                
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([data[@"data"][@"reward_info"][@"joined"] boolValue] == YES) {
                if ([data[@"data"][@"reward_info"][@"reward_amount"] floatValue] > 0) {
                    SuperbonusStatusViewController *vc = [[SuperbonusStatusViewController alloc] init];
                    vc.title = @"红包兑奖";
                    vc.joinStatus = 0;//未参与
                    vc.prize = data[@"data"][@"reward_info"][@"reward_amount"];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    SuperbonusStatusViewController *vc = [[SuperbonusStatusViewController alloc] init];
                    vc.title = @"红包兑奖";
                    vc.joinStatus = 3;//未参与
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"兑奖失败，请重试"];
                [alert showTarget:self];
            }
        } else {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"兑奖失败，请重试"];
            [alert showTarget:self];
        }
        
    } failed:^(RAError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"兑奖失败，请重试"];
        [alert showTarget:self];
        
    }];
}

- (void)textFieldDidChange {
    [self showInputFeildViewData];
}

- (void)showInputFeildViewData {
    for (int i = 0; i < self.superbonus.keyword.length ; i++) {

        if (i < self.inputKeyField.text.length) {
            UILabel *label = self.inputFieldView.subviews[i];
            label.text = [self.inputKeyField.text substringWithRange:NSMakeRange(i,1)];
        } else {
            UILabel *label = self.inputFieldView.subviews[i];
            label.text = nil;
        }
    }
}

- (void)inputFieldViewAddLabel {
    [self.inputFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //字符间距
    int width = (self.inputFieldView.frame.size.width - (self.superbonus.keyword.length - 1)*4) / self.superbonus.keyword.length ;
    for (int i = 0; i < self.superbonus.keyword.length; i ++) {
        CGFloat x = i*(4 + width);
        CGFloat y = 0;
        
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 36, 36)];
        [keyLabel setTextAlignment:NSTextAlignmentCenter];
        keyLabel.font = [UIFont fontWithName:@"HYYanLingJ" size:20];
        keyLabel.textColor = [UIColor colorWithHex:0xdb413c];
        keyLabel.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        keyLabel.tag = i;
        
        [self.inputFieldView addSubview:keyLabel];
    }
}

- (IBAction)reloadJoinAction:(id)sender {
    [self.inputKeyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setInputKeyViewData];
}

- (void)setInputKeyViewData {
    //字符间距
    int width = self.inputKeyView.frame.size.width / self.superbonus.keyword.length;
    for (int i = 0; i < self.superbonus.keyword.length; i ++) {
        //随机一位数
        int arc = arc4random() % 100;
        
        CGFloat x = i*width;
        CGFloat y = MIN(arc, self.inputKeyView.frame.size.height - 60);
        
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 30, 30)];
        keyLabel.text = [self.superbonus.keyword substringWithRange:NSMakeRange(i,1)];
        keyLabel.font = [UIFont fontWithName:@"HYYanLingJ" size:30];
        keyLabel.textColor = [UIColor colorWithHex:0xdb413c];
        keyLabel.backgroundColor = [UIColor clearColor];

        CGFloat showX = (arc4random() % 100) - 50;
        keyLabel.transform = CGAffineTransformMakeRotation(MIN(M_PI*showX/360,M_PI*1/4));
        
        [self.inputKeyView addSubview:keyLabel];
    }
}

- (IBAction)cancelJoinAction:(id)sender {
    [self.inputKeyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.inputFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.inputKeyField.text = nil;
    [self.joinView removeFromSuperview];
}

- (IBAction)sureJoinAction:(id)sender {
    
    if ([self.inputKeyField.text isEqualToString:self.superbonus.keyword]) {
        [self joinSuperbonus];
    } else {
        [self.inputKeyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.inputFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.inputKeyField.text = nil;
        [self.joinView removeFromSuperview];
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请输入正确口令"];
        [alert showTarget:self];
    }

}

- (IBAction)peopleNewAction:(id)sender {
//    SuperbonusStatusViewController *vc = [[SuperbonusStatusViewController alloc] init];
//    
////    SingleWebViewController *vc = [[SingleWebViewController alloc] init];
////    vc.title = @"本期得主";
////    vc.webUrl = self.superbonus.reward_page;
//    
//    vc.title = @"红包兑奖";
//
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)prizeBeforeAction:(id)sender {
    BeforePrizeViewController *vc = [[BeforePrizeViewController alloc] init];
    vc.title = @"往期大奖";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)shareAction:(id)sender {
    Server *server = [Server shareInstance];
    if (server.promotion_share_info[@"content"]==nil) {
        [Tools getServerKeyConfig];
        
        return;
    }
    NSString *mbMonStr=[NSString setNumLabelWithStr:self.superbonus.bonus_money];
    NSString *shareText   = @"分享内容";
    NSString *tempStr = server.super_bonus_description;
    shareText = [tempStr stringByReplacingOccurrencesOfString:@"{BONUS_MONEY}" withString:mbMonStr];
    
    NSArray *images = self.superbonus.images;
    if (images.count > 0) {
        [RAShare presentSnsIconSheetView:self shareTitle:server.redpacket_share_title shareText:shareText shareImage:images[0] shareLinkURL:server.share_link delegate:nil];
        
    } else {
        [RAShare presentSnsIconSheetView:self shareTitle:server.redpacket_share_title shareText:shareText shareImage:nil shareLinkURL:server.share_link delegate:nil];
    }
}

#pragma mark - get superbonus data
//参与超级大红包
- (void)joinSuperbonus {
    [MBProgressHUD showMessag:nil toView:self.view];
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    
    NSMutableDictionary *programDic = [[NSMutableDictionary alloc]init];
    
    programDic[@"event_id"] = self.event_id;
    programDic[@"action"] = @"JOIN";
    programDic[@"keyword"] = self.superbonus.keyword;
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.isVlaueKey = YES;
    
    [request Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:GetSuperbonusDetail completed:^(id data, NSString *stringData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data) {
            [self.joinView removeFromSuperview];
            self.isJoinHeight.constant = 0;
            [self.joinButton setTitle:@"已参与" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
            [self.joinButton setBackgroundColor:[UIColor colorWithHex:0x43ADAC]];
            
            _ticket_id = data[@"data"][@"ticket_id"];
            
            
            _reward_users = data[@"data"][@"info"][@"reward_users"];
            
            
            NSDictionary *superbonus = @{@"event_id": _event_id, @"join_state": @"1",@"ticket_id": data[@"data"][@"ticket_id"]};
            
            [RADBTool putObject:superbonus withId:[NSString stringWithFormat:@"join%@",_event_id] intoTable:kSuperbonusTableName withComplete:nil];
            
            _isJoin = YES;
            
            [self joinSuccessShow];
        }
    } failed:^(RAError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错啦！" message:error.errorDetail];
        
        [alertView showTarget:self];
        
        [self.inputKeyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.inputFieldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.inputKeyField.text = nil;
        [self.joinView removeFromSuperview];
    }];
    
}

//获取超级大红包往期记录
- (void)getSuperbonusReport {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:kSuperbonusViewControllerSuperbonusReport withTableName:kSuperbonusTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:24]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetSuperbonusHistory completed:^(id data, NSString *stringData) {
            if (data) {
                [_beforePeopleArrays removeAllObjects];
                [_beforePeopleArrays addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                if (_beforePeopleArrays.count > 0) {
                    [self.beforePeopleCollectionView removeFromSuperview];
                    [self.peopleBeforeView addSubview:self.beforePeopleCollectionView];
                } else {
                    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, UIScreenWidth, 110)];
                    defaultLabel.text = @"暂无往期得主";
                    defaultLabel.textColor = [UIColor colorWithHex:0x333333];
                    defaultLabel.font = [UIFont systemFontOfSize:30];
                    defaultLabel.textAlignment = NSTextAlignmentCenter;
                    defaultLabel.backgroundColor = [UIColor colorWithHex:0xdddddd];
                    [self.peopleBeforeView addSubview:defaultLabel];
                }
                
                [self.beforePeopleCollectionView reloadData];
                
                [RADBTool putObject:data withId:kSuperbonusViewControllerSuperbonusReport intoTable:kSuperbonusTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            [_beforePeopleArrays removeAllObjects];
            [_beforePeopleArrays addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
            if (_beforePeopleArrays.count > 0) {
                [self.peopleBeforeView addSubview:self.beforePeopleCollectionView];
            } else {
                UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, UIScreenWidth, 110)];
                defaultLabel.text = @"暂无往期得主";
                defaultLabel.textColor = [UIColor colorWithHex:0x333333];
                defaultLabel.font = [UIFont systemFontOfSize:30];
                defaultLabel.textAlignment = NSTextAlignmentCenter;
                [self.peopleBeforeView addSubview:defaultLabel];
            }
            [self.beforePeopleCollectionView reloadData];
        }];
    } else {
        [_beforePeopleArrays removeAllObjects];
        [_beforePeopleArrays addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        if (_beforePeopleArrays.count > 0) {
            [self.peopleBeforeView addSubview:self.beforePeopleCollectionView];
        } else {
            UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, UIScreenWidth, 110)];
            defaultLabel.text = @"暂无往期得主";
            defaultLabel.textColor = [UIColor colorWithHex:0x333333];
            defaultLabel.font = [UIFont systemFontOfSize:30];
            defaultLabel.textAlignment = NSTextAlignmentCenter;
            [self.peopleBeforeView addSubview:defaultLabel];
        }
        [self.beforePeopleCollectionView reloadData];
    }
}

- (void)joinSuccessShow {
    self.joinSuccessBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    self.joinSuccessBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.joinSuccessBackView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
    [backButton setBackgroundColor:[UIColor colorWithHex:0x333333 alpha:0.7]];
    [backButton addTarget:self action:@selector(joinSuccessCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.joinSuccessBackView addSubview:backButton];
    
    self.joinSuccessView.frame = CGRectMake((UIScreenWidth - 315)/2, -140, 315, 350);
    [self.joinSuccessBackView addSubview:self.joinSuccessView];
    
    self.superbonus_join_ticketLabel.text = [NSString stringWithFormat:@"活动兑奖券:%@",_ticket_id];

    CABasicAnimation *animation = [self moveX:0.5 Y:[NSNumber numberWithInt:140]];
    [self.joinSuccessView.layer addAnimation:animation forKey:nil];
}

- (void)joinSuccessCancelAction {
    CABasicAnimation *animation = [self moveX:0.05 Y:[NSNumber numberWithInt:0]];
    [self.joinSuccessView.layer addAnimation:animation forKey:nil];
    [self.joinSuccessView removeFromSuperview];
    [self.joinSuccessBackView removeFromSuperview];
}

#pragma mark =====横向、纵向移动===========

-(CABasicAnimation *)moveX:(float)time Y:(NSNumber *)y

{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    
    animation.toValue = y;
    
    animation.duration = time;
    
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    
    animation.repeatCount = 0;
    
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
    
}

//判断状态
- (void)joinStatus {
    if ([self.superbonus.end_time integerValue] <= [_superbonus_current_time integerValue]) {//已结束
        if (_reward_users.count < 1) {//正在开奖
            [self.joinButton setTitle:@"正在开奖" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
            [self.joinButton setBackgroundColor:[UIColor colorWithHex:0xddde8f]];
            self.joinButton.enabled = NO;
        } else {//立即兑奖
            [self.joinButton setTitle:@"立即兑奖" forState:UIControlStateNormal];
            [self.joinButton setTitleColor:[UIColor colorWithHex:0x33333] forState:UIControlStateNormal];
            [self.joinButton setBackgroundColor:[UIColor colorWithHex:0xFBFD35]];
            self.joinButton.enabled = YES;
            
            _isOpenPrize = YES;
        }
    } 
}

@end
