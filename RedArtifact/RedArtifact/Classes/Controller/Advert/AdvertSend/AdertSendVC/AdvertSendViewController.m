//
//  AdvertSendViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "AdvertSendViewController.h"
#import "AdvertMainTextViewCell.h"
#import "RedPacketSetViewController.h"
#import "PoiAddressViewController.h"
#import "RangMap.h"
#import "CropImageViewController.h"
#import "RAAdvert.h"
#import "MapLocation.h"
#import "SetCustomerAddressController.h"
#import "TestView.h"
@interface AdvertSendViewController (){
    
    int          imgDex;      //选择imageview的索引
    NSUInteger   titleNSUInteger;    // titleButton,
    NSUInteger   detailNSUInteger;   // detailButton,点击详情
    
    BOOL          haveValue;//主要是判断保存草稿跳转 返回问题的bug修复
    
    NSString      *jianLin_begin_time; //上传开始时间
    NSString      *jianLin_end_time;   //上传结束时间
    
    BMKPoiInfo    *sellerPoi;// 商家地址
    
    
    RAAdvert *  contentAdvert ;
    
    TestView *  testBaseView;
}
@property (nonatomic,strong)NSMutableArray *pictureArray;//图片容器
@property (nonatomic,strong)NSMutableArray *textViewArray;

@property(nonatomic,strong)UIImageView *oneImageView;
@property(nonatomic,strong)UIImageView *twoImageView;
@property(nonatomic,strong)UIImageView *threeImageView;

@end

@implementation AdvertSendViewController

-(NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray=[[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];

        }
    return _pictureArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    sellerPoi=[[BMKPoiInfo alloc]init];
     titleNSUInteger=1;
     detailNSUInteger=1;
     self.view.backgroundColor=RGBHex(0xeeeeee);
     [self.view addSubview:self.advertSendTableview];
     self.advertSendTableview.backgroundColor=RGBHex(0xeeeeee);
     self.advertSendTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
     self.advertSendTableview.dataSource=self;
     self.advertSendTableview.delegate=self;
    [self.view addSubview:self.advertSendTableview];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.advertSendTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
     self.searchAddressButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    jianLin_end_time     =@"0";
    jianLin_begin_time   =@"0";
    
    self.title = @"广告信息";
    
//    NSLog(@"===%@",self.adv_id);
    
    
    if (self.adv_id == nil||[self.adv_id isEqualToString:@""]) {
        [self setUpNav];
        
        haveValue=YES;

    }else{
        [self getEvaluate];//获得正确的数据
    }
   
    [self loadTableHeader];
    [self pacleor];
    
    [self SetNSMutableAttributedString];//代码添加红色*，为必填项
    [self getLoactionDoubleStr];
    [self setNotice];
    
    NSString * firstStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstAdvertSend"];
    
    if (![firstStr isEqualToString:@"isFirst"]) {
         [self addNewPersonImageView];
         [[NSUserDefaults standardUserDefaults]setObject:@"isFirst"forKey:@"firstAdvertSend"];
    }
    
   
    
   }
-(void)addNewPersonImageView{
    
    CGFloat heightHight;
    if (kScreenWidth==320) {
        heightHight=100;
    }else{
        heightHight=140;
    }

    testBaseView = [[TestView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
    testBaseView.backgroundColor = [UIColor clearColor];
    testBaseView.opaque =NO;
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testBaseView:)];
    [testBaseView addGestureRecognizer:singleTap];
    
    testBaseView.needRect=CGRectMake(0, 64, kScreenWidth, heightHight);
    UIImageView *naImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, heightHight+64, kScreenWidth, 80)];
    naImageView.center=CGPointMake(kScreenWidth/2, heightHight+64+170);
    naImageView.image=[UIImage imageNamed:@"advert_basic"];
    naImageView.contentMode=UIViewContentModeCenter;
    [testBaseView addSubview:naImageView];
    [self.navigationController.view addSubview:testBaseView];
    
}
// 时间
-(void)testBaseView:(UITapGestureRecognizer*)recognizer
{
    [testBaseView removeFromSuperview];
    
}
////添加新的图层消息
//-(void)addNewView{
//    UIImageView *newIMageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KScreenHeight)];
//    
//    newIMageView.image=[UIImage imageNamed:@"advert_basic"];
//    newIMageView.userInteractionEnabled=YES;
//    [self.navigationController.view addSubview:newIMageView];
//    
//}
#pragma 限制textfield的输入字数
- (void) setNotice{

    self.nameTextField.delegate=self;
    self.titleTextField.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(advertNameTextField:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.self.nameTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(advertNameTextField:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.titleTextField];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

-(void)advertNameTextField:(NSNotification *)obj{
    int p;
    if (obj.object==self.nameTextField) {
        p=18;
    }else{
        p=36;
    }
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    NSLog(@"+++++++++++++++++++++++%@",lang);
    if ([lang isEqualToString:@"zh-Hans"]||[lang isEqualToString:@"zh-Hant"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写zh-Hant（繁体中午）
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > p) {
                textField.text = [toBeString substringToIndex:p];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > p) {
            textField.text = [toBeString substringToIndex:p];
        }
    }
    
}

 - (void) textFieldDidChange:(UITextField *) TextField{
 
     if (TextField==self.nameTextField) {
         if (self.nameTextField.text.length>18) {
             self.nameTextField.text = [ self.nameTextField.text substringToIndex:18];

         }
     }else{
         if (self.titleTextField.text.length>36) {
             self.titleTextField.text = [self.titleTextField.text substringToIndex:36];
             
         }
 
     }
 
}
-(void)getLoactionDoubleStr{
    
    MapLocation *locationManager = [MapLocation sharedInstance];
    locationManager.isGeocoder = NO;
    [locationManager startGetLocation:^(CLLocationCoordinate2D currentCoordinate, double userLatitude, double userLongitude, NSString *city) {
        
//        NSLog(@"当前定位当前定位%f===%f===%@",userLatitude,userLongitude,city);

        
    } failureBlock:^(NSString *errorMsg, NSUInteger errorCode) {
        
    }];
    
}
#pragma 设置富文本
-(void)SetNSMutableAttributedString{
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:@"商家名称 *"];
    [nameStr addAttribute:NSForegroundColorAttributeName value:RGBHex(0x333333) range:NSMakeRange(0,4)];
    
    self.nameLabel.attributedText=nameStr;
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"广告标题 *"];
    [titleStr addAttribute:NSForegroundColorAttributeName value:RGBHex(0x333333) range:NSMakeRange(0,4)];
    
    self.titleLabel.attributedText=titleStr;
    
}

#pragma 得到赋值
-(void)getEvaluate{
    
     [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;headerDic[@"IDENTITY"] =@"PRODUCER";
    
    NSMutableDictionary *apidic=[[NSMutableDictionary alloc]init];
    apidic[@"adv_id"]=self.adv_id;
    
[GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apidic withBodyProgram:nil withPathApi:GetAdvertisementdetail completed:^(id data, NSString *stringData) {
    
     contentAdvert = [RAAdvert mj_objectWithKeyValues:data[@"data"][@"info"]];
    self.nameTextField.text=contentAdvert.pub_user_name;
    self.titleTextField.text=contentAdvert.advert_title;
    self.detailTextView.text=contentAdvert.advert_description;
    self.phoneTextField.text=contentAdvert.advert_content[@"contact_phone"];
    self.webClickUrlTextField.text=contentAdvert.advert_content[@"link"];
    self.webClikNameTextField.text=contentAdvert.advert_content[@"link_label"];
    
       sellerPoi.address=contentAdvert.contact_address;
    
    float sendLat=[contentAdvert.contact_lat floatValue];
    float sendLng=[contentAdvert.contact_lng floatValue];
    
      CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(sendLat,sendLng);
    
       sellerPoi.pt=loc;
//    sellerPoi.pt.latitude=[contentAdvert.contact_lat floatValue];

    if (contentAdvert.contact_address&&contentAdvert.contact_address.length!=0) {
        [self.searchAddressButton setTitle:contentAdvert.contact_address forState:UIControlStateNormal];
    }else{
         [self.searchAddressButton setTitle:@"商家定位" forState:UIControlStateNormal];
    }
    
    jianLin_begin_time=contentAdvert.pub_begin_time;
    jianLin_end_time  =contentAdvert.pub_end_time;
    NSArray *arr=contentAdvert.advert_content[@"images"];
    if (arr.count==1) {
        [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"] ];
         
    }else if (arr.count==2){
        [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"] ];
        [self.twoImageView sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"] ];
        
    }else if (arr.count==3){
        [self.oneImageView sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"] ];
        [self.twoImageView sd_setImageWithURL:[NSURL URLWithString:arr[1]] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"] ];
         [self.threeImageView sd_setImageWithURL:[NSURL URLWithString:arr[2]] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"] ];
        
    }
    for (int i=0; i<arr.count; i++) {
        
        [self.pictureArray replaceObjectAtIndex:i withObject:arr[i]];
    }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
 

} failed:^(RAError *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail];
    [alertView showTarget:self.navigationController];
    
}];
    
}
#pragma 设置默认值
-(void)pacleor{
    self.detailTextView.placeholder = @"请输入广告内容";
    self.detailTextView.returnKeyType = UIReturnKeySend;
    self.detailTextView.delegate = self;
    self.detailTextView.maxTextLength=200;
}

-(void)loadTableHeader{
    CGFloat heightHight;
    if (kScreenWidth==320) {
        heightHight=100;
    }else{
        heightHight=140;
    }
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, heightHight)];
    headerView.backgroundColor=[UIColor whiteColor];
    CGFloat  leftDistance=15;
    CGFloat  middleDistance=20;
    CGFloat  W =(kScreenWidth-2*leftDistance-3*middleDistance)/4;
    CGFloat  H=W*4/3;
    CGFloat  Top=(heightHight-H)/2;
    
   
    for (int i=0; i<4; i++) {
                UIImageView *pictureImageView=[[UIImageView alloc]init];
        
        if (i==0) {
            self.oneImageView=pictureImageView;
        }else if (i==1){
           self. twoImageView=pictureImageView;
        }else if(i==2) {
           self.threeImageView=pictureImageView;
        }

        if (i!=3) {
            pictureImageView.userInteractionEnabled=YES;
            pictureImageView.image=[UIImage imageNamed:@"send_advert_normal_picture"];
        }else{
            pictureImageView.image=[UIImage imageNamed:@"send_advert__extra_picture"];
        }
        pictureImageView.tag=i;
        [pictureImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        pictureImageView.frame=CGRectMake(W*i+leftDistance+middleDistance *i, Top, W, H);
        [headerView addSubview: pictureImageView];
        
    }
    self.advertSendTableview.tableHeaderView=headerView;
    
}
- (void)tapImage:(UITapGestureRecognizer *)tapGetsure
{
    NSLog(@"输出的tag是%ld",tapGetsure.view.tag);
    if (tapGetsure.view.tag==0) {
        imgDex=1;
    }else if (tapGetsure.view.tag==1){
        imgDex=2;
    }else if (tapGetsure.view.tag==2){
        imgDex=3;
    }
    [self actionOne];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"AdvertMainTextViewCell";
    AdvertMainTextViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AdvertMainTextViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textViewBack=^(NSString *text){
        DLog(@"输出的是%@",text);
        
    };
    
    return cell  ;
    
}

-(void)actionOne{
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
            picker.allowsEditing = NO;  //是否可编辑
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
            picker.allowsEditing = NO;
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
  
    
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *scaleImage;
    
    if (originImage.size.width>2000||originImage.size.height>2000) {
      scaleImage = [self scaleImage:originImage toScale:0.5];
    }
    if (originImage.size.width<2000&&originImage.size.width>1000) {
          scaleImage = [self scaleImage:originImage toScale:0.8];
    }
    if (originImage.size.height<2000&&originImage.size.height>1000) {
        scaleImage = [self scaleImage:originImage toScale:0.8];
    }
    if (originImage.size.height<1000||originImage.size.width>1000) {
        scaleImage = [self scaleImage:originImage toScale:0.8];
    }

    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
//        [OverAllManager alertView:@"网络异常,请检查网络连接!"];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"网络异常,请检查网络连接!"];
        [alertView showTarget:self.navigationController];
        return;
    }
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
//    if (UIImagePNGRepresentation(originImage) == nil) {
//        //将图片转换为JPG格式的二进制数据
//        data = UIImageJPEGRepresentation(originImage, 1);
////    } else {
//        //将图片转换为PNG格式的二进制数据
////        data = UIImagePNGRepresentation(originImage);
//    }
    
    //将二进制数据生成UIImage
//    UIImage *image = [UIImage imageWithData:data];
    
    CropImageViewController  *imageEditVc = [CropImageViewController getCropImageWithImage:scaleImage];

   
    imageEditVc.imageEditBlock = ^(UIImage *image1){
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"type"]=@"adv_img";
    dic[@"ext"]=@"jpg";
     [MBProgressHUD showMessag:@"" toView:self.view];
    [GLOBLHttp PutImageData:dic  addImage:image1 dataApi:PutFileImage completed:^(id data, NSString *stringData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSDictionary *dic=data;
        NSString *imgStr=dic[@"data"][@"advimg"];
        if (imgDex==1) {
            [self.pictureArray replaceObjectAtIndex:0 withObject:imgStr];
//            [self.oneImageView sd_setImageWithURL:[NSURL URLWithString: imgStr] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"]];
            
            self.oneImageView.image=image1;
            
        }else if (imgDex==2){
            [self.pictureArray replaceObjectAtIndex:1 withObject:imgStr];
            self.twoImageView.image=image1;
//            [self.twoImageView sd_setImageWithURL:[NSURL URLWithString: imgStr] placeholderImage:[UIImage imageNamed:@"send_advert_normal_picture"]];
        }else{
            [self.pictureArray replaceObjectAtIndex:2 withObject:imgStr];
            self.threeImageView.image=image1;

        }
        DLog(@"%@",stringData);
        
        
    } failed:^(RAError *error) {
        DLog(@"%@",error.description);
  
        [MBProgressHUD hideHUDForView:self.view animated:YES];
   
        
    }];
        
        
    };
     [picker pushViewController:imageEditVc animated:YES];
    
    
//    
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    
  //    [self dismissViewControllerAnimated:YES completion:^{
//    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark--menu_tabledatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 380;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 390;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *sectionHeaderView=[[UIView alloc]init];
    sectionHeaderView=self.adverMiddleView;
    return sectionHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc]init];
    sectionHeaderView=self.adverBottomView;
    return sectionHeaderView;
}
//
- (void)setUpNav
{
      UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-black-return-icon"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)pop
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"TabSelect" object:nil];
    
}

- (IBAction)nextCreatAdverID:(id)sender {
    
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请检查网络设置"];
        [alertView showTarget:self];
        return;
        
    }
    NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
    headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;headerDic[@"IDENTITY"] =@"PRODUCER";
    NSMutableArray *arrMut=[[NSMutableArray alloc]init];
    
    for (int i=0; i<self.pictureArray.count; i++) {
        NSString *exsitStr=self.pictureArray[i];
        if (![exsitStr isEqualToString:@""]) {
            [arrMut addObject:exsitStr];
        }
    }
    if (arrMut.count==0) {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未上传广告图片"];
        [alertView showTarget:self.navigationController];
//        [MBProgressHUD showError:@"请至少添加一张图片" toView:self.view];
        return;
    }
    if (self.nameTextField.text.length==0) {
//        [MBProgressHUD showError:@"请添加商家名称" toView:self.view];
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未填写商家名称"];
        [alertView showTarget:self.navigationController];
        return;
    }
    if (self.titleTextField.text.length==0) {
//         [MBProgressHUD showError:@"请输入广告标题" toView:self.view];
        
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"未填写广告标题"];
        [alertView showTarget:self.navigationController];
        return;
    }

    
    if (self.webClickUrlTextField.text.length>0) {
        
        if ([self.webClickUrlTextField.text rangeOfString:@"http://"].location != NSNotFound|| [self.webClickUrlTextField.text rangeOfString:@"https://"].location != NSNotFound) {
            
        }else{
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"请添加http或https前缀有效链接"];
            [alertView showTarget:self.navigationController];
            DLog(@"这个字符串中没有a");
            return;
        }
  
    }
    NSMutableDictionary *jsonDic =[[NSMutableDictionary alloc]init];
    jsonDic[@"images"]           =arrMut;
    
    DLog(@"图片的数组是多少%lu",(unsigned long)arrMut.count);
    
    jsonDic[@"link"]             =self.webClickUrlTextField.text;

    jsonDic[@"link_label"]       =self.webClikNameTextField.text;
    jsonDic[@"contact_phone"]    =self.phoneTextField.text;
    NSMutableDictionary *programDic=[[NSMutableDictionary alloc]init];
    programDic[@"name"]             =self.nameTextField.text;
    programDic[@"title"]            =self.titleTextField.text;
    programDic[@"description"]      =self.detailTextView.text;
    programDic[@"begin_time"]       =jianLin_begin_time;
    programDic[@"end_time"]         =jianLin_end_time;
    programDic[@"content"]          =jsonDic;
    
    
    if (sellerPoi.address.length==0||sellerPoi.pt.latitude==0|| sellerPoi.pt.longitude==0|| sellerPoi.address==nil) {
        
    }else{
    programDic[@"contact_address"]  =sellerPoi.address;
    programDic[@"contact_lng"]     = [NSString stringWithFormat:@"%f", sellerPoi.pt.longitude];
    programDic[@"contact_lat"]     = [NSString stringWithFormat:@"%f", sellerPoi.pt.latitude];
    
    }

    
    int sendway = 0;
    
    if (self.adv_id == nil||[self.adv_id isEqualToString:@""]||self.adv_id.length==0){
        sendway = POST;
    }else{
       if (self.jianlinsSatus== Editing) {
           
          programDic[@"adv_id"]=self.adv_id;
           
          sendway = PUT;
           
       } else {
           
         sendway = POST;
      }
}
  [MBProgressHUD showMessag:@"" toView:self.view];
    [GLOBLHttp Method:sendway withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PublishAdDetail completed:^(id data, NSString *stringData) {
      
            [MBProgressHUD hideHUDForView:self.view animated:YES];
      
         NSDictionary *dic=data[@"data"][@"info"];
        RedPacketSetViewController *VC=[[RedPacketSetViewController alloc]init];
        VC.adv_id=dic[@"adv_id"];
        VC.haveValue=haveValue;
        
        if (self.adv_id == nil||[self.adv_id isEqualToString:@""]||self.adv_id.length==0){
            VC.passStartTimeStr=[NSString stringWithFormat:@"%@",dic[@"pub_begin_time"]];
            VC.passEndtTimeStr=[NSString stringWithFormat:@"%@",dic[@"pub_end_time"]];
            
            
        }else{
            if (self.jianlinsSatus== Editing) {
                
              VC.passStartTimeStr=[NSString stringWithFormat:@"%@",dic[@"pub_begin_time"]];
              VC.passEndtTimeStr=[NSString stringWithFormat:@"%@",dic[@"pub_end_time"]];
            }else{
                VC.passStartTimeStr   =@"0";
                VC.passEndtTimeStr    =@"0";
                
            }
        }

        VC.BackId=^(NSString *ad_id,NSString *startStr,NSString * endStr){
            self.adv_id=ad_id;
        };
        [self.navigationController pushViewController:VC animated:YES];
        VC.imgUrl=arrMut[0];
        VC.advertTitle=self.titleTextField.text;


        DLog(@"%@",stringData);
      } failed:^(RAError *error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
//          [self.hudManager showMessage:error.errorDetail duration:1.0];
          
          CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:error.errorDetail];
          [alertView showTarget:self.navigationController];
    }];
    
}
- (IBAction)searchAddressAction:(id)sender {
    SetCustomerAddressController *vc=[[SetCustomerAddressController alloc]init];
    vc.sendPoi=sellerPoi;
    DLog(@"%@==%f===%f",sellerPoi.address,sellerPoi.pt.latitude,sellerPoi.pt.longitude);
    
    vc.addressDataBack =^(BMKPoiInfo *poi){
     DLog(@"输出的是返回的地址是啥一i %@",poi.address);
         sellerPoi=poi;
         
         [self.searchAddressButton setTitle:poi.address forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:NO];
    
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
