//
//  RAHomeViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/9.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RAHomeViewController.h"
#import "SDCycleScrollView.h"
#import "HomeButtonCell.h"
#import "HomeRunLabelCell.h"
#import "HomeTimerCell.h"
#import "RAAdvpos.h"
#import "HomeRedCell.h"
#import "MapLocation.h"
#import "RARedpacket.h"
#import "SingleWebViewController.h"
#import "CustomAlertView.h"
#import "SuperbonusViewController.h"
#import "RASuperbonus.h"
#import "RedpackDetailViewController.h"
#import "PlugViewController.h"
#import "GuideImageView.h"

static NSString *const homeButtonCellIdentifier = @"HomeButtonCellID";
static NSString *const homeRunLabelCellIndentifier = @"HomeRunLabelCellID";
static NSString *const homeTimerCellIndentifier = @"HomeTimerCellID";
static NSString *const homeRedCellIndentifier = @"HomeRedCellID";

@interface RAHomeViewController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, UIScrollViewDelegate>
{
    //广告轮播
    NSMutableArray *_advertItems;
    
    //插件数据
    NSMutableArray *_pluginItems;
    
    //消息轮播
    NSMutableArray *_cycleMessages;
    
    //红包
    NSMutableArray *_redpackets;
    
    NSString *_locationLng;//经度
    NSString *_locationLat;//纬度
    
    //超级大红包当前时间
    NSString *_superbonus_current_time;
}

@property (nonatomic,strong) UIView *bgView;//灰色背景

@property (nonatomic,strong) UIImageView *guideImageView;//灰色背景

@property (nonatomic,strong) UIImageView *bgAboveImageView;//广播弹出照片

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
/** tableView header */
@property (strong, nonatomic) UIView *tableViewHeader;

/** 头部轮播图 */
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) RASuperbonus  *superbonus;
@property (nonatomic, strong) UIButton      *removeButton;

@property (weak, nonatomic) IBOutlet UIImageView *mainGuideImg;

@end

@implementation RAHomeViewController

-(UIImageView *)bgAboveImageView{
    if (!_bgAboveImageView) {
        CGFloat w= kScreenWidth-70;
        _bgAboveImageView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 100,w, w*4/3)];
    }
    return _bgAboveImageView;
}

-(UIButton *)removeButton{
    if (!_removeButton) {
        CGFloat w= kScreenWidth-70;
        _removeButton=[[UIButton alloc]initWithFrame:CGRectMake(35, 100+20+w*4/3,w, 44)];
        _removeButton.titleLabel.font=[UIFont systemFontOfSize:30];
        [_removeButton setTitle:@"X" forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(buttonRemove) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}
-(void)buttonRemove{
    [self.bgView removeFromSuperview];
    [self.bgAboveImageView removeFromSuperview ];
    [self.removeButton removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BroadcastNSdufalut];

}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
        _bgView.backgroundColor=[UIColor blackColor];
        
        _bgView.alpha=0.7;
//        UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissFormView:)];
//        [_bgView addGestureRecognizer:panRecognizer];
    }
    return _bgView;
}
-(void)dissFormView:(UIPanGestureRecognizer *)recognizer{
  
    [self.bgView removeFromSuperview];
    [self.bgAboveImageView removeFromSuperview ];
    [self.removeButton removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BroadcastNSdufalut];
    
}
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.bounces=NO;
    _advertItems = [NSMutableArray array];
    _pluginItems = [NSMutableArray array];
    _cycleMessages = [NSMutableArray array];
    _redpackets = [NSMutableArray array];
    
    _locationLat = @"1";
    _locationLng = @"1";
    [self initTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TimerInvalid) name:@"SuperbonusTimerInvalid" object:nil];
    
//    NSString *keyStr=responseObject[@"data"][@"privateKey"];
//    [[NSUserDefaults standardUserDefaults]setObject:devicedStr forKey:DeviceId];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showGuideImageView:1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint offset = self.mainTableView.contentOffset;
    
    
    CGRect bounds = self.mainTableView.bounds;
    
    
    CGSize size = self.mainTableView.contentSize;
    
    
    UIEdgeInsets inset = self.mainTableView.contentInset;
    
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    
    
    CGFloat maximumOffset = size.height;
    
    if (maximumOffset > 170*RateHeight + 220 + 40 + 180 + 30) {
        if(currentOffset >= maximumOffset)
            
        {
            [self showGuideImageView:2];
            
        }
    }
}

- (void)showGuideImageView:(int)showPage {
    if (showPage == 1) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"home-send-guideImg"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"home-send-guideImg"];
        } else {
            return;
        }
    } else if (showPage == 2) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"home-getRedpacket-guideImg"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"home-getRedpacket-guideImg"];
            
        } else {
            return;
        }
    } else {
        return;
    }
    
    if (showPage == 1) {
        GuideImageView *imageview = [[GuideImageView alloc] initWithImageName:@"home-send-guideImg" withVerticalDirection:directionBottom];
        [imageview showTarget:self];
    } else {
        GuideImageView *imageview = [[GuideImageView alloc] initWithImageName:@"home-getRedpacket-guideImg" withVerticalDirection:directionBottom];
        [imageview showTarget:self];
    }
}

- (void)tapGuideImageView {
    [self.guideImageView removeFromSuperview];
}

- (void)TimerInvalid{
    NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
    [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self judgeData];
    
}
-(void)judgeData{
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BroadcastNSdufalut]) {
        NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:BroadcastNSdufalut];
        
     [self.bgAboveImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"notify_image"]] placeholderImage:[UIImage imageNamed:@"person"]];

        [self.tabBarController.view  addSubview:self.bgView];
        [self.tabBarController.view  addSubview:self.bgAboveImageView];
         [self.tabBarController.view  addSubview:self.removeButton];
    };
    
}
- (void)loadData {
    //获取广告位数据
    [self getAdvertImageUrlsData];
    
    //获取插件数据
    [self getPluginData];
    
    //获取滚动消息
    [self getCycleMessageData];
    
    //定位并获取红包数据
    [self getLocation];
    
    //获取超级大红包数据
    [self getSuperbonusData];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeButtonCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:homeButtonCellIdentifier];
        [buttonCell initItems:_pluginItems];
        buttonCell.cellClickBlock = ^(RAPlugin *plugin) {
            PlugViewController *vc = [[PlugViewController alloc] init];
            vc.lastPlugin = plugin;
            vc.title = plugin.name;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return buttonCell;
        
    } else if (indexPath.section == 1) {
        HomeRunLabelCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:homeRunLabelCellIndentifier];
        
        [buttonCell initWithItems:_cycleMessages WithAdvertLabelClickBlock:^(NSInteger item) {
            DLog(@"============%ld",item);
        }];
        return buttonCell;
        
    } else if (indexPath.section == 2) {
        
        HomeTimerCell *timerCell = [tableView dequeueReusableCellWithIdentifier:homeTimerCellIndentifier];
        
        if (self.superbonus.event_id) {
            timerCell.contentView.alpha = 1;
        } else {
            timerCell.contentView.alpha = 0;
        }
        
        timerCell.bonus_moneyLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:self.superbonus.bonus_money]];
        
        [timerCell initWithServerCurrentTime:_superbonus_current_time withSuperbonusBeginTime:self.superbonus.begin_time withSuperbonusEndTime:self.superbonus.end_time];
        
        NSString *titleStr;//
        NSString *event_nameStr;
        
        if (UIScreenWidth > 320) {
            if (self.superbonus.event_name.length > 25) {
                event_nameStr = [NSString stringWithFormat:@"%@...",[self.superbonus.event_name substringToIndex:25]];
            } else {
                event_nameStr = self.superbonus.event_name;
            }
            
        } else {
            if (self.superbonus.event_name.length > 18) {
                event_nameStr = [NSString stringWithFormat:@"%@...",[self.superbonus.event_name substringToIndex:18]];
            } else {
                event_nameStr = self.superbonus.event_name;
            }
        }
        
        
        if ([_superbonus_current_time integerValue] <= [self.superbonus.begin_time integerValue]){
            titleStr = [NSString stringWithFormat:@"%@【开始倒计时】",event_nameStr];
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
            CGFloat length = event_nameStr.length + 1;
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorWithHex:0xdb413c]
             
                                  range:NSMakeRange(length, 2)];
            timerCell.superbonus_titleLabel.attributedText = AttributedStr;
        } else if ([_superbonus_current_time integerValue] <= [self.superbonus.end_time integerValue]) {
            titleStr = [NSString stringWithFormat:@"%@【结束倒计时】",event_nameStr];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
            CGFloat length = event_nameStr.length + 1;
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorWithHex:0xdb413c]
             
                                  range:NSMakeRange(length, 2)];
            timerCell.superbonus_titleLabel.attributedText = AttributedStr;
        } else {
            if ([self.superbonus.end_time integerValue] <= [_superbonus_current_time integerValue]) {//已结束
                if (self.superbonus.reward_users.count < 1) {//正在开奖
                    titleStr = [NSString stringWithFormat:@"%@【正在开奖】",event_nameStr];
                    
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
                    CGFloat length = event_nameStr.length + 1;
                    [AttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                          value:[UIColor colorWithHex:0xdb413c]
                     
                                          range:NSMakeRange(length, 4)];
                    timerCell.superbonus_titleLabel.attributedText = AttributedStr;

                } else {//立即兑奖
                    titleStr = [NSString stringWithFormat:@"%@【立即兑奖】",event_nameStr];
                    
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
                    CGFloat length = event_nameStr.length + 1;
                    [AttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                          value:[UIColor colorWithHex:0xdb413c]
                     
                                          range:NSMakeRange(length, 4)];
                    timerCell.superbonus_titleLabel.attributedText = AttributedStr;
                }
            }
            
        }
        
        timerCell.joinblock = ^(BOOL isClick) {
            if (isClick) {
                SuperbonusViewController *vc = [[SuperbonusViewController alloc] init];
                vc.title = @"超级大红包";
                vc.event_id = self.superbonus.event_id;
                vc.lastSuperbonus = self.superbonus;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return timerCell;
        
    } else if (indexPath.section == 3) {
        HomeRedCell *redCell = [tableView dequeueReusableCellWithIdentifier:homeRedCellIndentifier];
        [redCell initWithItems:_redpackets];
        redCell.redPacketReloadBlock = ^(BOOL reload) {
            if (reload) {
                
                //定位并获取红包数据
                [self getLocation];
            }
        };
        redCell.redPacketClickBlock = ^(RARedpacket *redpacket) {
            if (redpacket.status == 1) {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"结束了！" message:@"下次早点来"];
                
                [alertView showTarget:self];
            } else if (redpacket.status == 2) {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"准备中！" message:@"马上开始喽"];
                
                [alertView showTarget:self];
            } else if (redpacket.status == 3) {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"结束了！" message:@"下次早点来"];
                
                [alertView showTarget:self];
            } else {
                RedpackDetailViewController *vc = [[RedpackDetailViewController alloc] init];
                vc.redpacket = redpacket;
                vc.status = NotInvolved;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return redCell;

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

#pragma mark - UTTableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithHex:0xeeeeee];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSInteger num = _pluginItems.count / 4;
        int remainder = _pluginItems.count % 4;
        if (remainder > 0) {
            return 100 * (num + 1) + 20;
        } else {
            return 100 * num + 20;
        }
    } else if (indexPath.section == 1) {
        return 40;
    } else if (indexPath.section == 2) {
        if (self.superbonus.event_id) {
            return 147;
        } else {
            return 0;
        }
        
    } else if (indexPath.section == 3) {
        return 180;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        if (self.superbonus.event_id) {
            return 10.0f;
        } else {
            return 0.0f;
        }
    }
    return 10.0f;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    RAAdvpos *advpos = _advertItems[index];
    SingleWebViewController *webVC = [[SingleWebViewController alloc] init];
    webVC.webUrl = advpos.adv_target;
    webVC.title = advpos.adv_merchant_name;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - view
- (void)initTableView {
    self.mainTableView.tableHeaderView = self.tableViewHeader;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UIScreenWidth, 170*RateHeight) imageNamesGroup:nil];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner_default"];
    cycleScrollView.placeholderImage = [UIImage imageWithContentsOfFile:@"banner_default"];
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView = cycleScrollView;
    [self.tableViewHeader addSubview:cycleScrollView];
    
    //register cell
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HomeButtonCell" bundle:nil]
    forCellReuseIdentifier:homeButtonCellIdentifier];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HomeRunLabelCell" bundle:nil]
             forCellReuseIdentifier:homeRunLabelCellIndentifier];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HomeTimerCell" bundle:nil] forCellReuseIdentifier:homeTimerCellIndentifier];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HomeRedCell" bundle:nil] forCellReuseIdentifier:homeRedCellIndentifier];
    [self.mainTableView reloadData];
    
    
    
}

#pragma mark - get data
//获取广告轮播图
-(void)getAdvertImageUrlsData{
    YTKKeyValueItem *item = [[YTKKeyValueItem alloc] init];
    item = [RADBTool getObjectItemDataWithObjectID:kRAHomeViewControllerAdverts withTableName:kHomeTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:12]) {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetAdvposTurns completed:^(id data, NSString *stringData) {
            if (data) {
                NSArray *dataArray = data[@"data"][@"list"];
                if (dataArray.count > 0) {
                    [_advertItems removeAllObjects];
                    [_advertItems addObjectsFromArray:[RAAdvpos mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                    NSMutableArray *imageURls = [NSMutableArray array];
                    [_advertItems enumerateObjectsUsingBlock:^(RAAdvpos *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj) {
                            [imageURls addObject:obj.adv_image];
                        }
                    }];
                    
                    [RADBTool putObject:data withId:kRAHomeViewControllerAdverts intoTable:kHomeTableName withComplete:nil];
    
                    self.cycleScrollView.imageURLStringsGroup = imageURls;
                }
                
            }
            
        } failed:^(RAError *error) {
            NSArray *dataArray = item.itemObject[@"data"][@"list"];
            if (dataArray.count > 0) {
                
                [_advertItems removeAllObjects];
                
                [_advertItems addObjectsFromArray:[RAAdvpos mj_objectArrayWithKeyValuesArray:dataArray]];
                
                NSMutableArray *imageURls = [NSMutableArray array];
                
                [_advertItems enumerateObjectsUsingBlock:^(RAAdvpos *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj) {
                        [imageURls addObject:obj.adv_image];
                    }
                }];
                
                self.cycleScrollView.imageURLStringsGroup = imageURls;
            }
        }];

    } else {
        NSArray *dataArray = item.itemObject[@"data"][@"list"];
        if (dataArray.count > 0) {
            
            [_advertItems removeAllObjects];
            
            [_advertItems addObjectsFromArray:[RAAdvpos mj_objectArrayWithKeyValuesArray:dataArray]];
            
            NSMutableArray *imageURls = [NSMutableArray array];
            
            [_advertItems enumerateObjectsUsingBlock:^(RAAdvpos *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj) {
                    [imageURls addObject:obj.adv_image];
                }
            }];
            
            self.cycleScrollView.imageURLStringsGroup = imageURls;
        }
    }
}

//获取插件数据
-(void)getPluginData{
    YTKKeyValueItem *item = [[YTKKeyValueItem alloc] init];
    item = [RADBTool getObjectItemDataWithObjectID:kRAHomeViewControllerPlugin withTableName:kHomeTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:12*3]) {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        
        headerDic[@"ACCESS-TOKEN"]=[User sharedInstance].accesstoken;
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetPluginList completed:^(id data, NSString *stringData) {
            if (data) {
                [_pluginItems removeAllObjects];
                [_pluginItems addObjectsFromArray:[RAPlugin mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
                [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [RADBTool putObject:data withId:kRAHomeViewControllerPlugin intoTable:kHomeTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            [_pluginItems removeAllObjects];
            [_pluginItems addObjectsFromArray:[RAPlugin mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
            
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
            [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    } else {
        [_pluginItems removeAllObjects];
        [_pluginItems addObjectsFromArray:[RAPlugin mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:0];
        [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//获取滚动消息
- (void)getCycleMessageData {
    YTKKeyValueItem *item = [[YTKKeyValueItem alloc] init];
    item = [RADBTool getObjectItemDataWithObjectID:kRAHomeViewControllerCyclemessage withTableName:kHomeTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:1]) {
        
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        
        headerDic[@"ACCESS-TOKEN"]=[User sharedInstance].accesstoken;
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetMessageCycle completed:^(id data, NSString *stringData) {
            if (data) {
                _cycleMessages = [NSMutableArray arrayWithArray:data[@"data"][@"messages"]];
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:1];
                [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [RADBTool putObject:data withId:kRAHomeViewControllerCyclemessage intoTable:kHomeTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            _cycleMessages = [NSMutableArray arrayWithArray:item.itemObject[@"data"][@"messages"]];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:1];
            [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];

        }];
        
    } else {
        _cycleMessages = [NSMutableArray arrayWithArray:item.itemObject[@"data"][@"messages"]];
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:1];
        [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//获取红包数据
- (void)getRedpacketData {
    if ([_locationLng isEqualToString:@"1"]||[_locationLng isEqualToString:@"1"]) {
        
        [self getLocation];
        return;
    }
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    headerDic[@"IDENTITY"] = @"CONSUMER";
    NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
    apiDic[@"lng"] = _locationLng;
    apiDic[@"lat"] = _locationLat;
    apiDic[@"limit"] = @"3";
    apiDic[@"offset"] = @"0";
    
    [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetNearbyAdvertisementList completed:^(id data, NSString *stringData) {

        if (data) {
            [_redpackets removeAllObjects];
            [_redpackets addObjectsFromArray:[RARedpacket mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:3];
            
            [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failed:^(RAError *error) {
        
    }];
}


#pragma mark - 获取超级大红包数据
- (void)getSuperbonusData {
    YTKKeyValueItem *item = [[YTKKeyValueItem alloc] init];
    item = [RADBTool getObjectItemDataWithObjectID:kRAHomeViewControllerSuperbonus withTableName:kHomeTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetSuperbonusList completed:^(id data, NSString *stringData) {
            NSMutableArray *bonuss = [NSMutableArray array];
            [bonuss addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
            if (bonuss.count > 0) {
                _superbonus_current_time = data[@"data"][@"current_time"];
                self.superbonus = bonuss[0];
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
                [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [RADBTool putObject:data withId:kRAHomeViewControllerSuperbonus intoTable:kHomeTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            NSMutableArray *bonuss = [NSMutableArray array];
            [bonuss addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
            if (bonuss.count > 0) {
                _superbonus_current_time = item.itemObject[@"data"][@"current_time"];
                self.superbonus = bonuss[0];
                NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
                [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    } else {
        NSMutableArray *bonuss = [NSMutableArray array];
        [bonuss addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        if (bonuss.count > 0) {
            _superbonus_current_time = item.itemObject[@"data"][@"current_time"];
            self.superbonus = bonuss[0];
            NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:2];
            [self.mainTableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Property
- (UIView *)tableViewHeader{
    if (_tableViewHeader == nil) {
        _tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 170*RateHeight)];
    }
    return _tableViewHeader;
}

#pragma mark - 定位获取经纬度
- (void)getLocation {
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"请到手机设置中开启定位服务" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置"];
        alertView.delegate=self;
        
        [alertView showTarget:self.navigationController];
        
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
        DLog(@"%@",errorMsg);
    }];
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
