//
//  PersonCenterViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PerCenterOtherCell.h"
#import "PerCenterGenterCell.h"
#import "PerCenterNiChenCell.h"
#import "QualificationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RestPasswordViewController.h"
#import "YTKKeyValueStore.h"

@interface PersonCenterViewController ()
@property (nonatomic,strong) NSMutableArray *sectionOneLeftLabelArray;
@property (nonatomic,strong) UIView *bgView;//黑色背景view

@end

@implementation PersonCenterViewController
-(UIView *)bgView{
    if (!_bgView ) {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
        _bgView.backgroundColor=[UIColor blackColor];
        _bgView.alpha=0.4;
        
    }
    return _bgView;
}
-(NSMutableArray *)sectionOneLeftLabelArray{
    if (!_sectionOneLeftLabelArray) {
        _sectionOneLeftLabelArray=[NSMutableArray arrayWithObjects:@"重置密码",@"实名认证",@"退出登录", nil];
    }
    return _sectionOneLeftLabelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人中心";
    
    
    self.personCenterTableView.tableFooterView=[[UIView alloc]init];
    self.personCenterTableView.tableHeaderView=self.headerView;
    UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [_bgView addGestureRecognizer:panRecognizer];
    self.birthdayDataPicker.maximumDate=[NSDate date];

    self.userinfoImageView.layer.masksToBounds=YES;
    self.userinfoImageView.layer.cornerRadius=80/2.0f; //设置为图片宽度的一半出来为圆形
    self.userinfoImageView.layer.borderWidth=3.0f; //边框宽度
    self.userinfoImageView.layer.borderColor=[[UIColor whiteColor] CGColor];//边框颜色
    //设置导航栏
    [self.userinfoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    if (![[AppDelegate appDelegate].fmdbStore isTableExists:personCacheTableName]) {
        [[AppDelegate appDelegate].fmdbStore createTableWithName:personCacheTableName withComplete:^(RAError *error) {
            DLog(@"创建%@表成功",personCacheTableName);
        }];
    }
    [self setupNav];
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
    
    
}
-(void) getChacePerson :(YTKKeyValueItem *)item{
//    NSLog(@"走了没有啊走了没有啊");
    
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
        self.nowUserInfo = [RAUserInfo mj_objectWithKeyValues:dataDic[@"data"][@"result"]];
        
    }else{
        self.nowUserInfo = [RAUserInfo mj_objectWithKeyValues:dataDic[@"data"]];
        
    }
    [self.userinfoImageView sd_setImageWithURL:[NSURL URLWithString:self.nowUserInfo.headimg] placeholderImage:[UIImage imageNamed:@"person"]];
    [self.personCenterTableView reloadData];
    User *user = [User sharedInstance];
    user.nickName = self.nowUserInfo.nickname;
    user.userAvatar=self.nowUserInfo.headimg;
    [user save];
    
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
        NSLog(@"%@",error.errorDescription);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

#pragma 设置右边提交
-(void)setupNav
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    rightButton.titleLabel.font=[UIFont systemFontOfSize :14.0];
    [rightButton addTarget:self action:@selector(click)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
}

-(void)click{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
     [MBProgressHUD showMessag:@"" toView:self.view];
     NSMutableDictionary *bodyDic=[[NSMutableDictionary alloc]init];
     bodyDic[@"headimg"]   =self.nowUserInfo.headimg;
     bodyDic[@"nickname"]  =self.nowUserInfo.nickname;
     bodyDic[@"gender"]    =self.nowUserInfo.gender;
     bodyDic[@"birthday"]  =self.nowUserInfo.birthday;
         
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    [GLOBLHttp Method:PUT withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:bodyDic withPathApi:PutUserInfo completed:^(id data, NSString *stringData) {
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
   
        [[AppDelegate appDelegate].fmdbStore putObject:data withId:[User sharedInstance].userId intoTable:personCacheTableName withComplete:^(RAError *error) {
            
        }];
    } failed:^(RAError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.hudManager showMessage:error.errorDetail duration:1.0];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.self.navigationController];
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"PerCenterNiChenCell";
        PerCenterNiChenCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerCenterNiChenCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
//          cell.niChenTextField.text=self.nowUserInfo.nickname;
            [cell post:self.nowUserInfo.nickname];
            cell.textFieldBack = ^(NSString *str){
               
                self.nowUserInfo.nickname=str;
                
//                NSLog(@"+++++++++++++++++++%@",str);
            };
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell ;
            //性别
        }else if (indexPath.row==1){
            static NSString *CellIdentifier = @"PerCenterGenterCell";
            PerCenterGenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerCenterGenterCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            cell.genderBack = ^(NSString *str){
                
                self.nowUserInfo.gender=str;
            };
            [cell getGender:self.nowUserInfo.gender];
            return cell ;

        }else{
            // 生日
            static NSString *CellIdentifier = @"PerCenterOtherCell";
            PerCenterOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerCenterOtherCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.hidenImageView.hidden=YES;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if ([self.nowUserInfo.birthday isEqualToString:@"0"]) {
                NSString *timeStr=[NSDate  getCurrentDateInterval];
                [cell getBirthday:timeStr];
                
            }else{
                [cell getBirthday:self.nowUserInfo.birthday];
            }
            return cell ;

        }
    return nil;
        
    }else{
        static NSString *CellIdentifier = @"PerCenterOtherCell";
        PerCenterOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerCenterOtherCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.leftLabel.text=self.sectionOneLeftLabelArray[indexPath.row];

        if (indexPath.row==0) {
            cell.hidenImageView.hidden=NO;
            cell.rightLabel.text=@"";
        
        }else if (indexPath.row==1){
            cell.hidenImageView.hidden=NO;
            [cell getCertification:self.nowUserInfo.verify_status];

        }else{
            cell.hidenImageView.hidden=YES;
            cell.rightLabel.text=@"";
        }
        
        return cell ;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
        return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    sectionHeaderView.backgroundColor=RGBHex(0xeeeeee);
    return sectionHeaderView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else{
        return 3;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            [self .view addSubview:self.bgView];
            [self.aboveDataView setFrame:CGRectMake(0, KScreenHeight-64-190, kScreenWidth, 190)];
            
            
             NSString *birStr= [NSDate dateWithTimeIntervalString: self.nowUserInfo.birthday withDateFormatter:@"yyyy-MM-dd"];
            NSDate *nowDate=[NSDate dateFromString:birStr withDateFormatter:@"yyyy-MM-dd"];
            self.birthdayDataPicker.date=nowDate;

            [self.view addSubview:self.aboveDataView];
        }
        
    }
    //第二组
    else{
        if (indexPath.row==0) {
            RestPasswordViewController *VC=[[RestPasswordViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if (indexPath.row==1){
            if ([self.nowUserInfo.verify_status isEqualToString:@"2"]||[self.nowUserInfo.verify_status isEqualToString:@"1"]) {
//                QualificationViewController *VC=[[QualificationViewController  alloc]init];
//                VC.qualiRAUserInfo=self.nowUserInfo;
//                [self.navigationController pushViewController:VC animated:YES];
            }else{
              QualificationViewController *VC=[[QualificationViewController  alloc]init];
                VC.qualiRAUserInfo=self.nowUserInfo;
              [self.navigationController pushViewController:VC animated:YES];
            }
            
        }else{
            
            CustomAlertView *alertView=[[CustomAlertView alloc]initWithTitle:@"确认退出" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
            alertView.delegate=self;
            [alertView showTarget:self.navigationController];
                       
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"quitToLoginVC" object:nil];
        }
    }
}
- (void)cancelAcion{
    
    
}
- (void)sureAcion{
    [User sharedInstance].accesstoken=nil;
    [[User sharedInstance] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"quitToLoginVC" object:nil];
}
- (void)tapImage:(UITapGestureRecognizer *)tapGetsure
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction * photographAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSString *errorStr = @"应用相机权限受限,请在设置中启用";
            [MBProgressHUD showError:errorStr toView:self.view];
            return;
        }else{
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;  //是否可编辑
            //摄像头
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
    }];
    
    UIAlertAction *albumsAction = [UIAlertAction actionWithTitle:@"手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.delegate = self;
            picker.allowsEditing = YES;
            if (!IOS7) {
                picker.navigationItem.rightBarButtonItem.tintColor = MAIN_COLOR;
            }
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }else{
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"调用相册出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:photographAction];
    [alertController addAction:albumsAction];
    [self presentViewController:alertController animated:YES completion:nil];


}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (image.size.width>800||image.size.height>800) {
        CGSize size=CGSizeMake(800, 800);
        image=[GLOBARMANAGER imageWithImageSimple:image scaledToSize:size];
    }
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"type"]=@"user_headimg";
    dic[@"ext"]=@"jpg";
    
    [GLOBLHttp PutImageData:dic  addImage:image dataApi:PutFileImage completed:^(id data, NSString *stringData) {
        NSDictionary *dic=data;
        NSString *imgStr=dic[@"data"][@"headimg"];
        self.nowUserInfo.headimg=imgStr;
        self.userinfoImageView.image=image;
        
        DLog(@"%@",stringData);
    } failed:^(RAError *error) {
        DLog(@"%@",error.description);
        
        
    }];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    [self.aboveDataView removeFromSuperview];
    [self.bgView removeFromSuperview];
}
#pragma 判读生日选择的
- (IBAction)cancelAction:(id)sender {
    [self.aboveDataView removeFromSuperview];
    [self.bgView removeFromSuperview];
}

- (IBAction)cirfimAction:(id)sender {
    [self.aboveDataView removeFromSuperview];
    [self.bgView removeFromSuperview];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd "];
    NSString *yy = [dateFormatter stringFromDate:self.birthdayDataPicker.date];
    
     NSString *timeSp1 = [NSDate intervalTimeWithTimeString:yy withDateFormatter:@"yyyy-MM-dd" ]; //时间戳的值
    
    self.nowUserInfo.birthday=timeSp1;
    [self.personCenterTableView reloadData];
    DLog(@"%@",yy);

}
@end
