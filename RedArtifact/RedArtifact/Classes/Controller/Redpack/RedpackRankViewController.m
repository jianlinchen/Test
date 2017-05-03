//
//  RedpackRankViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/14.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RedpackRankViewController.h"
#import "RankCell.h"
#import "RAConsumer.h"

static NSString *const kRankCellIdentifier = @"RankCellID";

@interface RedpackRankViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_rankArryas;
    NSString *_rankItem;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHieght;

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation RedpackRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"排行榜";
    
    _rankItem = @"0";
    
    _rankArryas = [NSMutableArray array];
    
    self.mainTableView.tableHeaderView = self.headerView;
    
    self.mainTableView.bounces = NO;
    
    [self showConsumerData];
    
    [self getRankData];
    
    if (UIScreenWidth == 320) {
        _topHieght.constant = 1;
    }
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"RankCell" bundle:nil] forCellReuseIdentifier:kRankCellIdentifier];
}

- (void)showConsumerData {
    User *user = [User sharedInstance];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:user.userAvatar] placeholderImage:[UIImage imageNamed:@"person"]];
    self.logoImgView.layer.borderWidth = 1;
    self.logoImgView.layer.borderColor = [UIColor colorWithHex:0xde413c].CGColor;
    self.nicknameLabel.text = user.nickName;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[NSString setNumLabelWithStr:_bonus_money]];
    self.timeLabel.text = [NSDate dateWithTimeIntervalString:_bonus_time withDateFormatter:nil];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rankArryas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:kRankCellIdentifier];
    switch (indexPath.row) {
        case 0:
        {
            cell.rank_imgView.image = [UIImage imageNamed:@"rank-red-iocns"];
            break;
        }
        case 1:
        {
            cell.rank_imgView.image = [UIImage imageNamed:@"rank-yellow-iocns"];
            break;
        }
        case 2:
        {
            cell.rank_imgView.image = [UIImage imageNamed:@"rank-Green-iocns"];
            break;
        }
        default:
        {
            cell.rank_imgView.image = [UIImage imageNamed:@"rank-gray-iocns"];
            break;
        }
    }
    cell.rank_label.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    RAConsumer *consumer = _rankArryas[indexPath.row];
    
    if (consumer.user_nickname.length == 11) {
        NSScanner* scan = [NSScanner scannerWithString:consumer.user_nickname];
        int val;
        if ([scan scanInt:&val] && [scan isAtEnd]) {
            cell.nicknameLabel.text = [Tools phoneNumberSecret:consumer.user_nickname];
        } else {
            
            cell.nicknameLabel.text = consumer.user_nickname;
        }
    } else {
        
        cell.nicknameLabel.text = consumer.user_nickname;
    }
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@元",[NSString setNumLabelWithStr:consumer.money]];
    cell.phoneLabel.text = [Tools phoneNumberSecret:consumer.user_telphone];
    
    if ([consumer.user_telphone isEqualToString:[User sharedInstance].userNmae]) {
        [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:[User sharedInstance].userAvatar] placeholderImage:[UIImage imageNamed:@"person"]];
    } else {
        [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:consumer.user_heading] placeholderImage:[UIImage imageNamed:@"person"]];
    }
    
    cell.timeLabel.text = [NSDate dateWithTimeIntervalString:consumer.create_time withDateFormatter:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

#pragma mark - HTTP
- (void)getRankData {
    YTKKeyValueItem *item = [RADBTool getObjectItemDataWithObjectID:_adv_id withTableName:kRedpacketRankTableName];
    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"adv_id"] = _adv_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetBonusRank completed:^(id data, NSString *stringData) {
            if (data) {
                
                [_rankArryas addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                if (_rankArryas.count <= 25) {
                    for (int i = 0; i < _rankArryas.count; i++) {
                        RAConsumer *consumer = _rankArryas[i];
                        if ([consumer.user_telphone isEqualToString:[User sharedInstance].userNmae]) {
                            _rankItem = [NSString stringWithFormat:@"%d",i + 1];
                            break;
                        } else {
                            _rankItem = data[@"data"][@"rank"];
                            if ([_rankItem intValue] == 0) {
                                _rankItem = @"26";
                            }
                        }
                    }
                } else {
                    _rankItem = data[@"data"][@"rank"];
                }
                
                self.rankLabel.text = [NSString stringWithFormat:@"第%d位",[_rankItem intValue]];

                [self.mainTableView reloadData];
                
                [RADBTool putObject:data withId:_adv_id intoTable:kRedpacketRankTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            _rankItem = item.itemObject[@"data"][@"rank"];
            self.rankLabel.text = [NSString stringWithFormat:@"第%d位",[_rankItem intValue]];
            [_rankArryas addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
            [self.mainTableView reloadData];
        }];
    } else {
        _rankItem = item.itemObject[@"data"][@"rank"];
        self.rankLabel.text = [NSString stringWithFormat:@"第%d位",[_rankItem intValue]];
        [_rankArryas addObjectsFromArray:[RAConsumer mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
        [self.mainTableView reloadData];
    }
    
}


@end
