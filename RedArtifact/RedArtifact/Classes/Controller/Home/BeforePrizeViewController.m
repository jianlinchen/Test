//
//  BeforePrizeViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/23.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "BeforePrizeViewController.h"
#import "BeforePrizeCell.h"
#import "SingleWebViewController.h"

static NSString *const kBeforePrizeCellIdentifier = @"BeforePrizeCellID";

@interface BeforePrizeViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_showArrays;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation BeforePrizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showArrays = [NSMutableArray array];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"BeforePrizeCell" bundle:nil] forCellReuseIdentifier:kBeforePrizeCellIdentifier];
    
    [self getSuperbonusReport];
}

#pragma mark - UITableView DataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _showArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BeforePrizeCell *cell = [tableView dequeueReusableCellWithIdentifier:kBeforePrizeCellIdentifier];
    RASuperbonus *superbonus = _showArrays[indexPath.section];
    NSArray *images = superbonus.images;
    if (images.count > 0) {
        [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    }
    cell.superbonus_titleLabel.text = superbonus.event_name;
    cell.superbonus_companylabel.text = superbonus.merchant_name;
    cell.superbonus_beginTimeLabel.text = [NSString stringWithFormat:@"时间：%@～%@",superbonus.begin_time_str,superbonus.end_time_str];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithHex:0xeeeeee];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RASuperbonus *superbonus = _showArrays[indexPath.section];
    SingleWebViewController *vc = [[SingleWebViewController alloc] init];
    vc.webUrl = superbonus.reward_page;
    vc.title = superbonus.event_name;
    [self.navigationController pushViewController:vc animated:YES];
}

//获取超级大红包往期记录
- (void)getSuperbonusReport {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:kSuperbonusViewControllerSuperbonusReport withTableName:kSuperbonusTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:24]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:GetSuperbonusHistory completed:^(id data, NSString *stringData) {
            if (data) {
                [_showArrays addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:kSuperbonusViewControllerSuperbonusReport intoTable:kSuperbonusTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
        }];
    } else {
        [_showArrays addObjectsFromArray:[RASuperbonus mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        
        [self.mainTableView reloadData];
    }
}

@end
