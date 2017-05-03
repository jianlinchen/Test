//
//  PaymentBanlanceViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PaymentBanlanceViewController.h"
#import "PaymentBanlanceCell.h"
#import "RABlanceBarGain.h"
@interface PaymentBanlanceViewController (){
    NSInteger _offset;
    NSInteger _page;
}
@property (nonatomic,strong) NSMutableArray *balanceArray;//model数组
@end

@implementation PaymentBanlanceViewController
-(NSMutableArray *)balanceArray{
    if (!_balanceArray) {
        _balanceArray=[[NSMutableArray alloc]init];
        
    }
    return _balanceArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收支明细";
    self.paymentBlanceTableView.backgroundColor=RGBHex(0xeeeeee);
    self.paymentBlanceTableView.tableFooterView=[[UIView alloc]init];
    self.paymentBlanceTableView.rowHeight=60;
 
    self.paymentBlanceTableView.mj_header = self.header;
       _offset = 0;
    _page = 0;
    
    self.paymentBlanceTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        _offset = (_page + 1) * 10;
        
        _page++;
        [self getBlanceData];
    }];
    [self getBlanceData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)loadNewData{
    [super loadNewData];
    [self.paymentBlanceTableView.mj_footer resetNoMoreData];
    _page = 0;
    _offset = 0;
    [self getBlanceData];
    
}
-(void)getBlanceData{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        [self.balanceArray  removeAllObjects];
        YTKKeyValueItem*  ppitem = [[YTKKeyValueItem alloc] init];
        ppitem = [[AppDelegate appDelegate].fmdbStore getYTKKeyValueItemById:PaymentBanlance fromTable:personCacheTableName];
        
         NSDictionary *data=ppitem.itemObject;
          [self.balanceArray addObjectsFromArray:[RABlanceBarGain mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
        [self.paymentBlanceTableView reloadData];
        [self.paymentBlanceTableView.mj_header endRefreshing];
        [self.paymentBlanceTableView.mj_footer endRefreshing];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
//       [alertView showTarget:self.navigationController];
        [self.navigationController.view addSubview:alertView];
        return;
        
    }else{
    
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    NSMutableDictionary *apiDic=[[NSMutableDictionary alloc]init];
     apiDic[@"offset"]=[NSString stringWithFormat:@"%ld" ,(long)_offset];
    
     apiDic[@"limit"]=@"10";
    
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:apiDic withBodyProgram:nil withPathApi:GetuserTransactionRecords completed:^(id data, NSString *stringData) {
        if (data) {
            if (_offset==0) {
                [self.balanceArray removeAllObjects];
            }
                
        [self.balanceArray addObjectsFromArray:[RABlanceBarGain mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
            
            if(self.balanceArray.count > 0){
                [self.paymentBlanceTableView reloadData];
            }
            if(_offset == 0 && self.balanceArray.count == 0){
                [self showNoDataViewWithString:@"您还未有交易记录" andImage:nil];
                
            }else{
                [self removeNoDataView];
                [[AppDelegate appDelegate].fmdbStore putObject:data withId:PaymentBanlance intoTable:personCacheTableName withComplete:^(RAError *error) {
                    if (error) {
                        
                    }
                }];
                
            }

            if(_offset != 0){
                NSArray *array = data[@"data"][@"list"];
                if(array.count < 10){
                    [self.paymentBlanceTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.paymentBlanceTableView.mj_footer endRefreshing];
                }
            }else{
                [self.paymentBlanceTableView.mj_header endRefreshing];
            }
 
            [self.paymentBlanceTableView reloadData];
            
        }
    } failed:^(RAError *error) {
        
        [self.paymentBlanceTableView.mj_header endRefreshing];
        [self.paymentBlanceTableView.mj_footer endRefreshing];
        DLog(@"%@",error.errorDescription);
//         [self.hudManager showMessage:error.errorDetail duration:1.0];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.self.navigationController];
    }];
  }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PaymentBanlanceCell";
    PaymentBanlanceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentBanlanceCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    RABlanceBarGain *rabBargain=[[RABlanceBarGain alloc]init];
    rabBargain =self.balanceArray[indexPath.row];
    [cell get:rabBargain];
    
      return cell ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.balanceArray.count;
}

@end
