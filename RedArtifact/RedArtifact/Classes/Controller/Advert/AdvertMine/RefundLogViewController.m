//
//  RefundLogViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/7.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RefundLogViewController.h"
#import "RefundLogCell.h"
#import "RARefundlog.h"
#import "Server.h"

static NSString *const kRefundLogCellIndentifier = @"RefundLogCellID";

@interface RefundLogViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_logArrays;
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *pub_detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *sataus_strLabel;
@property (weak, nonatomic) IBOutlet UILabel *server_telLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation RefundLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"结算进度";
    
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = [UIColor colorWithHex:0xdb413c].CGColor;
    self.bottomView.layer.cornerRadius = 5;
    _logArrays = [NSMutableArray array];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"RefundLogCell" bundle:nil] forCellReuseIdentifier:kRefundLogCellIndentifier];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.scrollEnabled = NO;
    [self gerRefundLogData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - button Aciton
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:AdvertListIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)callPhoneAction:(id)sender {
    Server *server = [Server shareInstance];
    NSString *telStr = @"010-65585859";
    if (server.server_tel) {
        telStr = server.server_tel;
    }
    
    [Tools callPhoneWithTel:telStr];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _logArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RefundLogCell *cell = [tableView dequeueReusableCellWithIdentifier:kRefundLogCellIndentifier];
    RARefundlog *refundlog = _logArrays[indexPath.row];
    if (indexPath.row == 0) {
        cell.log_status_imgVIew.image = [UIImage imageNamed:@"refund_log_line_current"];
        cell.log_timeLabel.textColor = [UIColor colorWithHex:0xdb413c];
        cell.log_detailLabel.textColor = [UIColor colorWithHex:0xdb413c];
    } else {
        cell.log_status_imgVIew.image = [UIImage imageNamed:@"refund_log_line"];
        cell.log_timeLabel.textColor = [UIColor colorWithHex:0x999999];
        cell.log_detailLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    cell.log_timeLabel.text = [NSDate dateWithTimeIntervalString:refundlog.create_time withDateFormatter:nil];
    cell.log_detailLabel.text = refundlog.refund_status_str;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - https
- (void)gerRefundLogData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:self.advert.advert_id withTableName:kRefundLogTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        NSMutableDictionary *apiDic=[[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = self.advert.advert_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetRefundLog completed:^(id data, NSString *stringData) {
            if (data) {
                
                [_logArrays addObjectsFromArray:[RARefundlog mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                RARefundlog *refundlog = _logArrays[0];
                self.sataus_strLabel.text = refundlog.refund_status_str;
                self.tableViewHeight.constant = 50*_logArrays.count;
                self.pub_detailLabel.text = [NSString stringWithFormat:@"%@|%@",[NSString setNumLabelWithStr:refundlog.refund_total_amount],data[@"data"][@"pub_name"]];
                
                Server *server = [Server shareInstance];
                if (server.server_tel) {
                    self.server_telLabel.text = [NSString stringWithFormat:@"拨打客服电话%@",server.server_tel];
                } else {
                    self.server_telLabel.text = [NSString stringWithFormat:@"拨打客服电话010-65585859"];
                }
                
                
                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:self.advert.advert_id intoTable:kRefundLogTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            [_logArrays addObjectsFromArray:[RARefundlog mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
            
            RARefundlog *refundlog = _logArrays[0];
            self.sataus_strLabel.text = refundlog.refund_status_str;
            self.tableViewHeight.constant = 50*_logArrays.count;
            self.pub_detailLabel.text = [NSString stringWithFormat:@"%@|%@",[NSString setNumLabelWithStr:refundlog.refund_total_amount],item.itemObject[@"data"][@"pub_name"]];
            
            Server *server = [Server shareInstance];
            if (server.server_tel) {
                self.server_telLabel.text = [NSString stringWithFormat:@"拨打客服电话%@",server.server_tel];
            } else {
                self.server_telLabel.text = [NSString stringWithFormat:@"拨打客服电话010-65585859"];
            }
            
            
            [self.mainTableView reloadData];
        }];
    } else {
        [_logArrays addObjectsFromArray:[RARefundlog mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        
        RARefundlog *refundlog = _logArrays[0];
        self.sataus_strLabel.text = refundlog.refund_status_str;
        self.tableViewHeight.constant = 50*_logArrays.count;
        self.pub_detailLabel.text = [NSString stringWithFormat:@"%@|%@",[NSString setNumLabelWithStr:refundlog.refund_total_amount],item.itemObject[@"data"][@"pub_name"]];
        
        Server *server = [Server shareInstance];
        if (server.server_tel) {
            self.server_telLabel.text = [NSString stringWithFormat:@"拨打客服电话%@",server.server_tel];
        } else {
            self.server_telLabel.text = [NSString stringWithFormat:@"拨打客服电话010-65585859"];
        }
        
        
        [self.mainTableView reloadData];
    }

}


@end
