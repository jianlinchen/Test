//
//  PoiAddressViewController.m
//  RedArtifact
//
//  Created by LiLu on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PoiAddressViewController.h"
#import "SearchPoiTableCell.h"

@interface PoiAddressViewController (){
    NSMutableArray *poiArray;//地名
    NSMutableArray *cityArray;//地名
     int dex;

    BMKPoiInfo *cirPoiInfo; //区分确认返回的数据
    NSUInteger  sbManger;  //区分SB产品经理
}
@end

@implementation PoiAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sbManger=0;
    dex=0;
    self.searchAddressTextField.delegate=self;
    
    self.headerNamelLabel.text=self.transmitPoiInfo.address;
    
    self.searchAdressTableView.tableHeaderView=self.poiHeaderView;
    
    poiArray= [NSMutableArray new];
    cityArray=[NSMutableArray new];
    _poisearch = [[BMKPoiSearch alloc]init];
    self.searchAdressTableView.tableFooterView=[[UIView alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(redTextFiledEditChanged:)
        name:@"UITextFieldTextDidChangeNotification"
        object:self.searchAddressTextField
     ];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [self.poiHeaderView addGestureRecognizer:singleTap];

}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    BMKPoiInfo* poi=[[BMKPoiInfo alloc]init];
    poi=self.transmitPoiInfo;
    if (self.poiBack) {
        self.poiBack(self.transmitPoiInfo);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)redTextFiledEditChanged:(NSNotification *)obj{
    
    [poiArray removeAllObjects];
    [cityArray removeAllObjects];
    [self.searchAdressTableView reloadData ];
     [self.cirfimButton setTitle:@"取消" forState:UIControlStateNormal];
     dex=0;
    UITextField *textField = (UITextField *)obj.object;
    
    BMKCitySearchOption *keyText = [[BMKCitySearchOption alloc]init];
    keyText.keyword =textField.text;
    BOOL flag = [_poisearch poiSearchInCity:keyText];
    if(flag)
    {
        DLog(@"城市内检索发送成功");
    }
    else
    {
        DLog(@"城市内检索发送失败");
    }

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _poisearch.delegate = nil; // 不用时，置nil
    self.navigationController.navigationBar.hidden = NO;
    
}
- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cirfimAction:(id)sender {
    dex=0;
    
    [self.searchAddressTextField resignFirstResponder];
    
    if ([self.cirfimButton.titleLabel.text isEqualToString:@"取消"]) {
        if (cirPoiInfo.address.length!=0) {
             if (self.poiBack) {
            
            self.poiBack(cirPoiInfo);
             }
        [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (self.poiBack) {
                
                self.poiBack(self.transmitPoiInfo);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
       
        
    }else if([self.cirfimButton.titleLabel.text isEqualToString:@"搜索"])  {
    }
    
}
- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    
}
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        if (dex< cityArray.count ) {
            
            [self loadcity];
        }
        if (result.poiInfoList.count!=0) {
            
            for (int i = 0; i < result.poiInfoList.count; i++) {
                BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
                [poiArray addObject:poi];
                
            }
            [self.searchAdressTableView reloadData ];
        }else{
            if (cityArray.count!=0) {
                return;
            }
            if (result.cityList.count!=0) {
                for (int i=0; i<result.cityList.count; i++) {
                    BMKCityListInfo  *listInfo=result.cityList[i];
                    NSString *str=[NSString stringWithFormat:@"%@",listInfo.city];
                    DLog(@"%@",str);
                    [cityArray addObject:str];
                    
                }
                [self loadcity];
                DLog(@"包含该字段的城市数组%@",cityArray);
            }
        }
        
    }
}
-(void) loadcity{
    NSString *cityStr=cityArray[dex];
    BMKCitySearchOption *keyText = [[BMKCitySearchOption alloc]init];
    keyText.keyword = self.searchAddressTextField.text;
    keyText.city=cityStr;
    keyText.pageCapacity=15;
    [_poisearch  poiSearchInCity:keyText];
    
    dex ++;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return poiArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SearchPoiTableCell";
    SearchPoiTableCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchPoiTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (poiArray.count!=0) {
        cell.selectButton.tag=indexPath.row;
        [cell.selectButton addTarget:self action:@selector(selectonRow:) forControlEvents:UIControlEventTouchUpInside];

        BMKPoiInfo* poi=poiArray[indexPath.row];
        cell.nameLabel.text=poi.name;
        cell.addressLabel.text=poi.address;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchAddressTextField resignFirstResponder];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     BMKPoiInfo* poi=poiArray[indexPath.row];
    
    if (self.poiBack) {
        self.poiBack(poi);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 选择点击➕按钮的调用方法
-(void)selectonRow:(UIButton *)btn{
     sbManger=2;
    BMKPoiInfo* poi=poiArray[btn.tag];
    cirPoiInfo=[[BMKPoiInfo alloc]init];
    cirPoiInfo=poi;
    NSString *str=poi.name;
    
    // 防止闪退做的判断
    if (poi.name.length!=0) {
     [poiArray removeAllObjects];
     [cityArray removeAllObjects];
    [self.searchAdressTableView reloadData ];
     dex=0;
     BMKCitySearchOption *keyText = [[BMKCitySearchOption alloc]init];
     keyText.keyword =str;
     BOOL flag = [_poisearch poiSearchInCity:keyText];
    if(flag)
    {
        DLog(@"城市内检索发送成功");
    }
    else
    {
        DLog(@"城市内检索发送失败");
    }
   
    self.searchAddressTextField.text=str;
     [self.cirfimButton setTitle:@"取消" forState:UIControlStateNormal];
    }
   

}
-(void)getData:(NSString *)textStr{
    [poiArray removeAllObjects];
    [cityArray removeAllObjects];
    [self.searchAdressTableView reloadData ];
    dex=0;
    
    BMKCitySearchOption *keyText = [[BMKCitySearchOption alloc]init];
    keyText.keyword =textStr;
    BOOL flag = [_poisearch poiSearchInCity:keyText];
    if(flag)
    {
        DLog(@"城市内检索发送成功");
    }
    else
    {
        DLog(@"城市内检索发送失败");
    }
 
}
- (IBAction)headerButtonAction:(id)sender {
     sbManger=1;

    NSString *str=self.transmitPoiInfo.address;
    
    [poiArray removeAllObjects];
    [cityArray removeAllObjects];
    [self.searchAdressTableView reloadData ];
    dex=0;
    BMKCitySearchOption *keyText = [[BMKCitySearchOption alloc]init];
    keyText.keyword =str;
    BOOL flag = [_poisearch poiSearchInCity:keyText];
    if(flag)
    {
        DLog(@"城市内检索发送成功");
    }
    else
    {
        DLog(@"城市内检索发送失败");
    }
    
    self.searchAddressTextField.text=str;
    [self.cirfimButton setTitle:@"取消" forState:UIControlStateNormal];
    
}
@end
