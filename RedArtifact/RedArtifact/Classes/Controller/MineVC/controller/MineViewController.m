//
//  MineViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/17.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#define WNXCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#import "MineViewController.h"
#import "MySectionZeroCell.h"
#import "MySectionOneCell.h"
#import "User.h"
#import "RAUserInfo.h"
#import "LoginViewController.h"
#import "QRCodeViewController.h"
#import "PersonCenterViewController.h"
#import "SingleWebViewController.h"
#import "RAUserInfo.h"
#import "WithDrawMoeyViewController.h"
#import "YTKKeyValueStore.h"
#import "JLdbModel.h"
#import "RADBTool.h"

@interface MineViewController (){
    RAUserInfo *userinfo;
    NSString   *moneyStr;//金额
    NSString   *memoryStr;// 缓存字符串
    YTKKeyValueStore *personStore;
 
    NSString *versionStr;  //版本号

}
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic,strong) NSMutableArray *sectionZeroImageViewArray;//第一组
@property (nonatomic,strong) NSMutableArray *sectionZeroNameArray;//第一组

@property (nonatomic,strong) NSMutableArray *sectionZeroRightArray;//第一组

@property (nonatomic,strong) NSMutableArray *sectionOneImageViewArray;//第二组
@property (nonatomic,strong) NSMutableArray *sectionOneNameLabelArray;//第二组

@property (nonatomic,strong) NSMutableArray *sectionOneRightLabelArray;//第二组

@end

@implementation MineViewController
-(NSMutableArray *)sectionZeroImageViewArray{
    if (!_sectionZeroImageViewArray) {
        _sectionZeroImageViewArray=[NSMutableArray arrayWithObjects:@"my_ withdraw_cash",@"my_ spread_publish", nil];
    }
    return _sectionZeroImageViewArray;
}
-(NSMutableArray *)sectionOneImageViewArray{
    if (!_sectionOneImageViewArray) {
        _sectionOneImageViewArray=[NSMutableArray arrayWithObjects:@"my_ clean_memory",@"my_now_version",@"my_about_company", nil];
    }
    return _sectionOneImageViewArray;
}
-(NSMutableArray *)sectionZeroNameArray{
    if (!_sectionZeroNameArray) {
        _sectionZeroNameArray=[NSMutableArray arrayWithObjects:@"账户提现",@"我的推广", nil];
    }
    return _sectionZeroNameArray;
}
-(NSMutableArray *)sectionZeroRightArray{
    if (!_sectionZeroRightArray) {
        _sectionZeroRightArray=[NSMutableArray arrayWithObjects:@"立即提现",@"二维码", nil];
    }
    return _sectionZeroRightArray;
}
-(NSMutableArray *)sectionOneNameLabelArray{
    if (!_sectionOneNameLabelArray) {
        _sectionOneNameLabelArray=[NSMutableArray arrayWithObjects:@"清理内存",@"当前版本",@"关于便联生活", nil];
    }
    return _sectionOneNameLabelArray;
}
-(NSMutableArray *)sectionOneRightLabelArray{
    if (!_sectionOneRightLabelArray) {
        
        _sectionOneRightLabelArray=[NSMutableArray arrayWithObjects:@"550k",@"点击可更新版本",@"", nil];
    }
    return _sectionOneRightLabelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"";
    self.myNewsTableView.rowHeight=60;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.personImageView.layer.masksToBounds=YES;
    self.personImageView.layer.cornerRadius=90/2.0f; //设置为图片宽度的一半出来为圆形
    self.personImageView.layer.borderWidth=1.0f; //边框宽度
    self.personImageView.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    self.myNewsTableView.backgroundColor=RGBHex(0xeeeeee);
    self.myNewsTableView.tableFooterView=[[UIView alloc]init];
    versionStr=[NSString stringWithFormat:@"%@", [GLOBARMANAGER getverson]];
    moneyStr=@"￥0.00";
    memoryStr=@"0.00kb";

    
    if (![[AppDelegate appDelegate].fmdbStore isTableExists:personCacheTableName]) {
        [[AppDelegate appDelegate].fmdbStore createTableWithName:personCacheTableName withComplete:^(RAError *error) {
            DLog(@"创建%@表成功",personCacheTableName);
        }];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    YTKKeyValueItem*  ppitem = [[YTKKeyValueItem alloc] init];
    ppitem = [[AppDelegate appDelegate].fmdbStore getYTKKeyValueItemById:[User sharedInstance].userId fromTable:personCacheTableName];
        if (ppitem.itemObject) {
            [self getChacePerson :ppitem];

        }else{
            [self getPersonInfo];
        }
    self.navigationController.navigationBarHidden=YES;
//   [self getPersonInfo];//获取个人信息
    [self getMoney];
    [self countMM];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
     self.navigationController.navigationBarHidden=NO;
}
-(void) getChacePerson :(YTKKeyValueItem *)item{
    
    DLog(@"走了没有啊走了没有啊");

     NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval timeStr = [date timeIntervalSinceDate:item.createdTime];
    int seconds=[[NSString stringWithFormat:@"%f",timeStr]intValue];

    
    NSDictionary *dic;
    if (item.itemObject[@"data"][@"result"]) {
        dic=item.itemObject[@"data"][@"result"];
    }else{
        dic=item.itemObject[@"data"];
        
    }
    NSString *statusStr=[NSString stringWithFormat:@"%@",dic[@"verify_status"]];
    
        Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        if (![reach isReachable]) {
            NSDictionary *dataDic=item.itemObject;
            [self send:dataDic];

        }else{
        // 判断是否请求网络
        if (item.itemObject==nil || seconds>= 3600*24|| ![statusStr isEqualToString:@"2"])
         {
          [self getPersonInfo];
       
       }else{
           NSDictionary *dataDic=item.itemObject;
          [self send:dataDic];
    }

        }
    
}
-(void)send:(NSDictionary *)dataDic{
    
    if (dataDic[@"data"][@"result"]) {
        userinfo = [RAUserInfo mj_objectWithKeyValues:dataDic[@"data"][@"result"]];
  
    }else{
          userinfo = [RAUserInfo mj_objectWithKeyValues:dataDic[@"data"]];

    }
      self.nameLabel.text=userinfo.nickname;
    
    [self.personImageView sd_setImageWithURL:[NSURL URLWithString:userinfo.headimg ] placeholderImage:[UIImage imageNamed:@"person"]];
    if ([userinfo.verify_status isEqualToString:@"0"]) {
        self.changLabel.text=@"未认证";
    }else if ([userinfo.verify_status isEqualToString:@"1"]){
        self.changLabel.text=@"审核中";
    }else if ([userinfo.verify_status isEqualToString:@"2"]){
        self.changLabel.text=@"已认证";
    }else {
        self.changLabel.text=@"认证失败";
    }
    User *user = [User sharedInstance];
    user.nickName = userinfo.nickname;
    user.userAvatar=userinfo.headimg;
    [user save];

}
#pragma 账号提现
-(void)getMoney{
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetUserBalance completed:^(id data, NSString *stringData) {
        if (data) {
            
            NSString *transtStr=[NSString stringWithFormat:@"%@",data[@"data"][@"balance"][@"wallet_balance"]];
            NSString *transtStr2=[NSString setNumLabelWithStr:transtStr];

            moneyStr=[NSString stringWithFormat:@"￥%@",transtStr2];
            [self.myNewsTableView reloadData];
            
        }
    } failed:^(RAError *error) {
        DLog(@"%@",error.errorDescription);
    }];
    
}
#pragma 获取个人信息
-(void)getPersonInfo{
    
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetUserInfo completed:^(id data, NSString *stringData) {
        if (data) {
    
       [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        [[AppDelegate appDelegate].fmdbStore putObject:data withId:[User sharedInstance].userId intoTable:personCacheTableName withComplete:^(RAError *error) {
            if (error) {
                
                
            }
            }];
            [self send:data];
            
        }
    } failed:^(RAError *error) {
        DLog(@"%@",error.errorDescription);
        

            [MBProgressHUD hideHUDForView:self.view animated:YES];


    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"MySectionZeroCell";
        MySectionZeroCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySectionZeroCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.leftCanshImageView.image=[UIImage imageNamed:self.sectionZeroImageViewArray[indexPath.row]];
        cell.sectionZeroRightLabel.text=self.sectionZeroRightArray[indexPath.row];
        cell.sectionZeroNameLabel.text=self.sectionZeroNameArray[indexPath.row];
        if (indexPath.row==0) {
            cell.sectionZeroMoneyLabel.hidden=NO;
            cell.sectionZeroMoneyLabel.text=moneyStr;
        }else{
            cell.sectionZeroMoneyLabel.hidden=YES;
        }
        
        return cell ;
    }else{
      static NSString *CellIdentifier = @"MySectionOneCell";
      MySectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySectionOneCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
     }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        cell.sectionOneImageView.image=[UIImage imageNamed:self.sectionOneImageViewArray[indexPath.row]];
        cell.sectionOneNameLabel.text=self.sectionOneNameLabelArray[indexPath.row];

        if (indexPath.row==0) {
            cell.sectionOneRightLabel.text=memoryStr;
        }else if (indexPath.row==1){
//             cell.sectionOneRightLabel.text=@"点击更新版本";
             cell.sectionOneRightLabel.text=versionStr;

        }else{
            cell.sectionOneRightLabel.text=@"";

        }
        
        return cell ;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.000000000001;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    sectionHeaderView.backgroundColor=RGBHex(0xeeeeee);
    return sectionHeaderView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return 3;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if ([userinfo.verify_status isEqualToString:@"0"]||[userinfo.verify_status isEqualToString:@"1"]||[userinfo.verify_status isEqualToString:@"3"]) {

                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"未认证！" message:@"请打开“我的”->“个人中心”去完成实名认证"];

                [alertView showTarget:self.tabBarController];
                
            }else{
                
              WithDrawMoeyViewController *VC=[[WithDrawMoeyViewController alloc]init];
              VC.withDrawUserInfo=userinfo;
            [self.navigationController pushViewController:VC animated:YES];
            }
            
        }else{
            
//            if ([userinfo.verify_status isEqualToString:@"0"]||[userinfo.verify_status isEqualToString:@"1"]||[userinfo.verify_status isEqualToString:@"3"]||[userinfo.type isEqualToString:@"1"]) {
//                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"未认证！" message:@"暂不支持个人推广"];
//                [alertView showTarget:self.tabBarController];
//                
//            }else{
               QRCodeViewController *VC=[[QRCodeViewController alloc]init];
                VC.nameStr=userinfo.nickname;
               [self.navigationController pushViewController:VC animated:YES];
//            }
        }
        
    }else{
        if (indexPath.row==0) {
            
            if ([memoryStr isEqualToString:@"0.00kb"]) {
                return;
            }else{
                [self clearHC];
            }
            
        }else if (indexPath.row==1){
            
        }else{
            SingleWebViewController *VC=[[SingleWebViewController alloc]init];
            VC.title=@"关于便联生活";
            VC.webUrl=AboutUs;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
- (IBAction)edictPersonInfoAcction:(id)sender {
    PersonCenterViewController *VC=[[PersonCenterViewController alloc]init];
//    VC.nowUserInfo=userinfo;
    [self.navigationController pushViewController:VC animated:YES];
}
-(void)countMM{
    NSString *path = WNXCachesPath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        //拿到算有文件的数组
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        //拿到每个文件的名字,如有有不想清除的文件就在这里判断
        for (NSString *fileName in childerFiles) {
            //将路径拼接到一起
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fullPath];
        }
    }
    DLog(@"=================%f",folderSize);
    if (folderSize *1000<1000) {
       memoryStr=[NSString stringWithFormat:@"%.2fkb",folderSize *1000     ];
    }else{
        memoryStr=[NSString stringWithFormat:@"%.2fM", folderSize];
 
    }
}
-(void)clearHC{
    NSString *path = WNXCachesPath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        //拿到算有文件的数组
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        //拿到每个文件的名字,如有有不想清除的文件就在这里判断
        for (NSString *fileName in childerFiles) {
            //将路径拼接到一起
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fullPath];
        }
        
        CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"清理缓存" message:memoryStr cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        alertView.delegate=self;
        [alertView showTarget:self.navigationController];
//      self.alertView.delegate = self;
    }
    
}
- (void)cancelAcion{
    
    
}
- (void)sureAcion{
    //点击了确定,遍历整个caches文件,将里面的缓存清空
    NSString *path = WNXCachesPath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
     
    [RADBTool clearTable:nil withComplete:nil];
    
//   [MBProgressHUD showSuccess:@"清除成功" toView:self.view];
    memoryStr=@"0.00kb";

   [self.myNewsTableView reloadData];

}
//计算单个文件夹的大小
-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
#pragma 分割线修正
-(void)viewDidLayoutSubviews

{
    [super viewDidLayoutSubviews];
    
    if ([self.myNewsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.myNewsTableView setSeparatorInset:UIEdgeInsetsMake(0,-5,0,10)];
        
    }
    if ([self.myNewsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.myNewsTableView setLayoutMargins:UIEdgeInsetsMake(0,-5,0,10)];
    }
}

@end
