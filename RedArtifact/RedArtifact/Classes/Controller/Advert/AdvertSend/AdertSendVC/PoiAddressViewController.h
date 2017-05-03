//
//  PoiAddressViewController.h
//  RedArtifact
//
//  Created by LiLu on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef void (^PoiBackModel) (BMKPoiInfo *poi);

@interface PoiAddressViewController : UIViewController<BMKPoiSearchDelegate,UIScrollViewDelegate,UITextFieldDelegate>{
    BMKPoiSearch* _poisearch;
    int curPage;
}
@property (nonatomic,strong) BMKPoiInfo *transmitPoiInfo;
@property (weak, nonatomic) IBOutlet UITableView *searchAdressTableView;
- (IBAction)popView:(id)sender;
- (IBAction)cirfimAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchAddressTextField;
@property (nonatomic,strong) NSString *selectStr;
@property (copy,nonatomic) PoiBackModel poiBack;

@property (weak, nonatomic) IBOutlet UILabel *headerNamelLabel;

- (IBAction)headerButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *poiHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *cirfimButton;


@end
