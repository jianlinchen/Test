//
//  AdvertArriveViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertArriveViewController.h"
#import "AdvertArriveCell.h"
#import "RAConsumer.h"

static NSString *const kAdvertArriveCellIdentifier = @"AdvertArriveCellID";

@interface AdvertArriveViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_acceptArrays;
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *begin_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *end_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accept_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *total_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *accept_amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *total_amountLabel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_viwheight;
@end

@implementation AdvertArriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"到达统计";
    
    _acceptArrays = [NSMutableArray array];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AdvertArriveCell" bundle:nil] forCellReuseIdentifier:kAdvertArriveCellIdentifier];
    
    [self getBonusStatisticsData];
    
    [self setRedpacketInfo];
    
    if (UIScreenWidth > 320) {
        _top_viwheight.constant = 38;
    }
}

- (void)setRedpacketInfo {
    NSArray *images = self.advert.advert_content[@"images"];
    if (images.count != 0) {
        [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    }
    self.begin_timeLabel.text = [NSDate dateWithTimeIntervalString:self.advert.pub_begin_time withDateFormatter:nil];
    self.end_timeLabel.text = [NSDate dateWithTimeIntervalString:self.advert.pub_end_time withDateFormatter:nil];
    self.accept_numLabel.text = self.advert.bonus_accepted_num;
    self.total_numLabel.text = [NSString stringWithFormat:@"/%@",self.advert.bonus_total_num];
    self.accept_amountLabel.text = [NSString setNumLabelWithStr:self.advert.bonus_accepted_amount];
    self.total_amountLabel.text = [NSString stringWithFormat:@"/%@",[NSString setNumLabelWithStr:self.redpacket.prize_total_money]];
}
#pragma mark - UITableviewDataSouece/Deleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _acceptArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdvertArriveCell *cell = [tableView dequeueReusableCellWithIdentifier:kAdvertArriveCellIdentifier];
    
    RAConsumer *consumer = _acceptArrays[indexPath.row];
    [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:consumer.user_heading] placeholderImage:[UIImage imageNamed:@"person"]];
    if (consumer.user_nickname.length == 11) {
        NSScanner* scan = [NSScanner scannerWithString:consumer.user_nickname];
        int val;
        if ([scan scanInt:&val] && [scan isAtEnd]) {
            cell.user_nickeLabel.text = [Tools phoneNumberSecret:consumer.user_nickname];
        } else {
            
            cell.user_nickeLabel.text = consumer.user_nickname;
        }
    } else {
        
        cell.user_nickeLabel.text = consumer.user_nickname;
    }
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@元",[NSString setNumLabelWithStr:consumer.money]];
    cell.user_telLabel.text = [Tools phoneNumberSecret:consumer.user_telphone];
    cell.timeLabel.text = [NSDate dateWithTimeIntervalString:consumer.create_time withDateFormatter:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
// 	发布者-获取红包配置
-(void)getBonusStatisticsData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:self.advert.advert_id withTableName:kBonusStatisticsTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        headerDic[@"IDENTITY"] =@"PRODUCER";
        NSMutableDictionary *apiDic=[[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = self.advert.advert_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetBonusStatistics completed:^(id data, NSString *stringData) {
            if (data) {
                [_acceptArrays addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:data[@"data"][@"acccepted_list"]]];
                
                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:self.advert.advert_id intoTable:kBonusStatisticsTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            [_acceptArrays addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"acccepted_list"]]];
            
            [self.mainTableView reloadData];
        }];
    } else {
        [_acceptArrays addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"acccepted_list"]]];
        
        [self.mainTableView reloadData];
    }
}

@end
