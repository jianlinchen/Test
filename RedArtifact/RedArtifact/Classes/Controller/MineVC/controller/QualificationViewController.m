//
//  QualificationViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/13.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "QualificationViewController.h"
#import "QualificationPickCell.h"
#import <AVFoundation/AVFoundation.h>
#import "YTKKeyValueStore.h"
@interface QualificationViewController (){
    NSUInteger imgInter;
    NSString *topImageStr;
    NSString *bottomImageStr;
    
    NSString *companyTopImageStr;
    NSString *companyBottomImageStr;
}
@end
@implementation QualificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"实名认证";
    imgInter=0;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.quanlificationTableView.tableHeaderView=self.hederView;
    self.quanlificationTableView.tableFooterView=[[UIView alloc]init];
    self.quanlificationTableView.backgroundColor=RGBHex(0xeeeeee);
    
    self.mainTopView.layer.cornerRadius = 5;
    self.mainTopView.layer.masksToBounds = YES;
    self.mainTopView.layer.borderWidth=1.0f; //边框宽度
    self.mainTopView.layer.borderColor=[RGBHex(0xFEA000) CGColor];

    self.commitButton.layer.cornerRadius = 5;
    self.commitButton.layer.masksToBounds = YES;
    [self addGesture];
    [self judgePersonOrComapnyOrNull];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditQuailication:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.nameTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textVeray:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.numberTextfield];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditQuailication:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.companyNameTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textVeray:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.companyNumberTextField];
    
    
    [self.personButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
    [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
    
}
-(void)textVeray:(NSNotification *)obj{
    
    [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
    [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
}
-(void)textFiledEditQuailication:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    DLog(@"+++++++++++++++++++++++%@",lang);
    if ([lang isEqualToString:@"zh-Hans"]||[lang isEqualToString:@"zh-Hant"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写zh-Hant（繁体中午）
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 6) {
                textField.text = [toBeString substringToIndex:6];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:6];
        }
    }
    [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
    [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
    [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
    [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nameTextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.companyNameTextField];
}

-(void)judgePersonOrComapnyOrNull{
    
    if ([self.qualiRAUserInfo.type isEqualToString:@"0"]) {
        self.reasonLabel.hidden=YES;
        
    }else if ([self.qualiRAUserInfo.type isEqualToString:@"1"]){
        self.personButton.enabled=NO;
        self.companyButton.enabled=NO;
        [self.personButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.personButton.backgroundColor=RGBHex(0xFEA000);
        
        [self.companyButton setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
        self.companyButton.backgroundColor=RGBHex(0xEFEFF4);
        
        self.quanlificationTableView.tableHeaderView=self.hederView;
        [self getPersoninfo];
        if ([self.qualiRAUserInfo.verify_status isEqualToString:@"3"]) {
            self.reasonLabel.hidden=NO;
            self.reasonLabel.text=[NSString stringWithFormat:@"注：%@",self.qualiRAUserInfo.verify_reason];
        }else{
            self.reasonLabel.hidden=YES;

        }
        
    }else if ([self.qualiRAUserInfo.type isEqualToString:@"2"]){
        self.personButton.enabled=NO;
        self.companyButton.enabled=NO;
        [self.companyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.companyButton.backgroundColor=RGBHex(0xFEA000);
        
        [self.personButton setTitleColor:RGBHex(0x333333) forState:UIControlStateDisabled];
        self.personButton.backgroundColor=RGBHex(0xEFEFF4);        self.quanlificationTableView.tableHeaderView=self.companyHeaderView;
        if ([self.qualiRAUserInfo.verify_status isEqualToString:@"3"]) {
            self.reasonLabel.hidden=NO;
//            self.reasonLabel.text=self.qualiRAUserInfo.verify_reason;
         self.reasonLabel.text=[NSString stringWithFormat:@"注：%@",self.qualiRAUserInfo.verify_reason];
        }else{
            self.reasonLabel.hidden=YES;
            
        }
         [self getCompanyinfo];
    }
}
//获取个人认证信息
-(void)getPersoninfo{
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetcitizenInfo completed:^(id data, NSString *stringData) {
        if (data) {
            
            self.nameTextField.text=[NSString stringWithFormat:@"%@", data[@"data"][@"info"][@"name"]];
            self.numberTextfield.text=[NSString stringWithFormat:@"%@", data[@"data"][@"info"][@"iden_id"]];
            NSArray *arr=data[@"data"][@"info"][@"extra_content"][@"images"];
            topImageStr=arr[0];
            bottomImageStr=arr[1];
             [self.personButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.topImageView sd_setImageWithURL:[NSURL URLWithString:topImageStr] placeholderImage:[UIImage imageNamed:@"my_pick_celebrity"]];
            
            [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:bottomImageStr] placeholderImage:[UIImage imageNamed:@"my_pick_celebrity"]];
            
            [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
           
            
          
        }
    } failed:^(RAError *error) {
        DLog(@"%@",error.errorDescription);
    }];

}
// 获取公司认证信息
-(void)getCompanyinfo{
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetCompanyInfo completed:^(id data, NSString *stringData) {
        if (data) {
            self.companyNameTextField.text=[NSString stringWithFormat:@"%@", data[@"data"][@"info"][@"name"]];
            self.companyNumberTextField.text=[NSString stringWithFormat:@"%@", data[@"data"][@"info"][@"iden_id"]];
            NSArray *arr=data[@"data"][@"info"][@"extra_content"][@"images"];
            companyTopImageStr      =arr[0];
            companyBottomImageStr   =arr[1];
            
            [self.companyTopImageView sd_setImageWithURL:[NSURL URLWithString:companyTopImageStr] placeholderImage:[UIImage imageNamed:@"my_pick_celebrity"]];
            
            [self.companyBottomImageView sd_setImageWithURL:[NSURL URLWithString:companyBottomImageStr] placeholderImage:[UIImage imageNamed:@"my_pick_celebrity"]];
            
            
             [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
            
          }
    } failed:^(RAError *error) {
        DLog(@"%@",error.errorDescription);
    }];
 
}
-(void)addGesture{

    UITapGestureRecognizer *panRecognizer1= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage1:)];

    [self.topImageView addGestureRecognizer:panRecognizer1];
    
    UITapGestureRecognizer *panRecognizer2= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage2:)];
    
    [self.bottomImageView addGestureRecognizer:panRecognizer2];
    
    UITapGestureRecognizer *panRecognizer3= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage3:)];
    [self.companyTopImageView addGestureRecognizer:panRecognizer3];
    
    
    UITapGestureRecognizer *panRecognizer4= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage4:)];
    
    [self.companyBottomImageView addGestureRecognizer:panRecognizer4];

}
- (void)tapImage1:(UITapGestureRecognizer *)tapGetsure

{
   
        imgInter=0;
        [self popComera];

}
- (void)tapImage2:(UITapGestureRecognizer *)tapGetsure

{
    
    imgInter=1;
    [self popComera];
    
}
- (void)tapImage3:(UITapGestureRecognizer *)tapGetsure

{
    
    imgInter=3;
    [self popComera];
    
}
- (void)tapImage4:(UITapGestureRecognizer *)tapGetsure

{
    
    imgInter=4;
    [self popComera];
    
}


-(void)popComera{
    
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
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"type"]=@"user_idenimg";
    dic[@"ext"]=@"jpg";

    [GLOBLHttp PutImageData:dic  addImage:image dataApi:PutFileImage completed:^(id data, NSString *stringData) {
        NSDictionary *dic=data;
         NSString *imgStr=[NSString stringWithFormat:@"%@",dic[@"data"][@"idenimg"]];
        if (imgInter==0) {
            topImageStr=imgStr;
            [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
//            [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
            
            self.topImageView.image=image;
        }else if (imgInter==1) {
            bottomImageStr=imgStr;
            [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
//            [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
            self.bottomImageView.image=image;
        }else if (imgInter==3){
            companyTopImageStr=imgStr;
            self.companyTopImageView.image=image;
//            [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
            [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
            
        }else if (imgInter==4){
            companyBottomImageStr=imgStr;
            self.companyBottomImageView.image=image;
//            [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
            [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
        }
        
        
       
       
        DLog(@"%@",stringData);
    } failed:^(RAError *error) {
        DLog(@"%@",error.description);
        
    }];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *CellIdentifier = @"QualificationPickCell";
        QualificationPickCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QualificationPickCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        return cell ;
   }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (IBAction)personAction:(id)sender {
    [self.personButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.personButton.backgroundColor=RGBHex(0xFEA000);
    
    [self.companyButton setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
    self.companyButton.backgroundColor=RGBHex(0xEFEFF4);
    
    self.quanlificationTableView.tableHeaderView=self.hederView;
    [self.quanlificationTableView reloadData];
    
    // 调用的方法
    [self fieldName:self.nameTextField andfieldInditify:self.numberTextfield andTop:topImageStr andBottom:bottomImageStr];
    
}
- (IBAction)companyAction:(id)sender {
    [self companyFieldName:self.companyNameTextField andfieldInditify:self.companyNumberTextField andTop:companyTopImageStr andBottom:companyBottomImageStr];
    
    [self.companyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.companyButton.backgroundColor=RGBHex(0xFEA000);
    
    [self.personButton setTitleColor:RGBHex(0x333333) forState:UIControlStateNormal];
    self.personButton.backgroundColor=RGBHex(0xEFEFF4);
    self.quanlificationTableView.tableHeaderView=self.companyHeaderView;
    [self.quanlificationTableView reloadData];
    
}
//个人
-(void)fieldName:(UITextField*)nameTextFiedl andfieldInditify:(UITextField *)numberTextfield andTop:(NSString *)topStr andBottom:(NSString *)bottomStr{
    
    if (topStr.length==0) {
        self.personOneHidenLabel.hidden=NO;
    }else{
        self.personOneHidenLabel.hidden=YES;
        
    }
    
    if (bottomStr.length==0) {
        self.personTwoHidenLabel.hidden=NO;
    }else{
        self.personTwoHidenLabel.hidden=YES;
    }
    if (nameTextFiedl.text.length==0|| numberTextfield.text.length==0||topStr.length==0||bottomStr.length==0) {
        self.commitButton.enabled=NO;
        self.commitButton.backgroundColor=RGBHex(0xfcb5b3);
    }else{
        self.commitButton.enabled=YES;
        self.commitButton.backgroundColor=RGBHex(0xdb413c);
    }
    
}

// 添加企业
-(void)companyFieldName:(UITextField*)companyNameTextFied andfieldInditify:(UITextField *)companyNumberTextfield andTop:(NSString *)companyTopStr andBottom:(NSString *)companyBottomStr{
    
    if (companyTopStr.length==0) {
        self.companyOneHidenLabel.hidden=NO;
    }else{
        self.companyOneHidenLabel.hidden=YES;

    }

    if (companyBottomStr.length==0) {
        self.companyTwoHidenLabel.hidden=NO;
    }else{
        self.companyTwoHidenLabel.hidden=YES;
    }
    if (companyNameTextFied.text.length==0|| companyNumberTextfield.text.length==0||companyTopStr.length==0||companyBottomStr.length==0) {
        self.companyCommitButton.enabled=NO;
        self.companyCommitButton.backgroundColor=RGBHex(0xfcb5b3);
    }else{
        self.companyCommitButton.enabled=YES;
        self.companyCommitButton.backgroundColor=RGBHex(0xdb413c);
        
    }
}
- (IBAction)commitAction:(id)sender {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    
    [self updatePersonAndCompany];
    
}

#pragma 更新公民信息
-(void)updatePersonAndCompany{
    
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if (self.nameTextField.text.length==0||self.numberTextfield.text.length==0) {
        [MBProgressHUD showError:@"请完善个人内容" toView:self.view];
        return;
    }
    
    if (topImageStr.length==0||bottomImageStr.length==0) {
        [MBProgressHUD showError:@"请添加身份证照片" toView:self.view];
        return;
    }
    NSMutableArray *imageArray=[[NSMutableArray alloc]initWithObjects:topImageStr,bottomImageStr, nil];
    NSMutableDictionary *imageDic=[[NSMutableDictionary alloc]init];
    imageDic[@"images"]=imageArray;
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    programDic[@"name"]=self.nameTextField.text;
    programDic[@"iden_id"]=self.numberTextfield.text;
    programDic[@"extra_content"]=imageDic;
    [GLOBLHttp Method:PUT withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PutCitizenInfo completed:^(id data, NSString *stringData) {
        
        [self commitPersonAndCompany];
    } failed:^(RAError *error) {
        
    }];
}
#pragma 提交公民信息认证
-(void)commitPersonAndCompany{
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    [GLOBLHttp Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:PostCitizenIdentification completed:^(id data, NSString *stringData) {
//        [[AppDelegate appDelegate].fmdbStore deleteObjectById:[User sharedInstance].userId fromTable:@"personCache" withComplete:^(RAError *error) {
//            
//        }];
        [self .navigationController popViewControllerAnimated:YES];

    } failed:^(RAError *error) {
        
    }];
}
#pragma 更新提交公司信息
- (IBAction)commitCompanyAction:(id)sender {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    [self updateCompany ];
}

-(void)updateCompany{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    if (self.companyNameTextField.text.length==0||self.companyNumberTextField.text.length==0) {
        [MBProgressHUD showError:@"请完善内容企业" toView:self.view];
        return;
    }
    
    if (companyTopImageStr.length==0||companyBottomImageStr.length==0) {
        [MBProgressHUD showError:@"请添加执照照片" toView:self.view];
        return;
    }
    NSMutableArray *imageArray=[[NSMutableArray alloc]initWithObjects:companyTopImageStr,companyBottomImageStr, nil];
    
    NSMutableDictionary *imageDic=[[NSMutableDictionary alloc]init];
    imageDic[@"images"]=imageArray;
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    programDic[@"name"]=self.companyNameTextField.text;
    programDic[@"iden_id"]=self.companyNumberTextField.text;
    
    programDic[@"extra_content"]=imageDic;
    
    [GLOBLHttp Method:PUT withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PutCompanyInfo completed:^(id data, NSString *stringData) {
        [self commitCompany];
    } failed:^(RAError *error) {
        
    }];

}
#pragma 提交公司信息认证
-(void)commitCompany{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
    [GLOBLHttp Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:nil withPathApi:PostCompanyIdentification completed:^(id data, NSString *stringData) {
        [[AppDelegate appDelegate].fmdbStore deleteObjectById:[User sharedInstance].userId fromTable:@"personCache" withComplete:^(RAError *error) {
            
        }];
        [self .navigationController popViewControllerAnimated:YES];
    } failed:^(RAError *error) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了" message:error.errorDetail];
        [alertView showTarget:self.self.navigationController];
//        [self.hudManager showMessage:error.errorDetail duration:1.0];
        
    }];
    
}
@end
