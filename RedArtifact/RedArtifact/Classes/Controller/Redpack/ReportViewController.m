//
//  ReportViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/14.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "ReportViewController.h"
#import "Server.h"
#import "ReportCell.h"

static NSString *kCellID = @"ReportCellID";

@interface ReportViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_itemArrays;
    
    NSInteger _currentItem;
}

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"举报";
    
    _itemArrays = [NSArray arrayWithArray:[Server shareInstance].accusation_options];
    
    _currentItem = 0;
    
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"ReportCell" bundle:nil] forCellWithReuseIdentifier:kCellID];
}

#pragma mark - UICollectionViewDataSource/delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (_currentItem == indexPath.row) {
        cell.contentView.backgroundColor = [UIColor colorWithHex:0xdb413c];
        cell.itemLabel.textColor = [UIColor colorWithHex:0xffffff];
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.itemLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    
    cell.itemLabel.text = _itemArrays[indexPath.row];
    
    return cell;
}

#pragma mark-- UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UIScreenWidth - 10) / 3 - 10, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentItem = indexPath.row;
    
    [self.mainCollectionView reloadData];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)commitAction:(id)sender {
    if (_currentItem > _itemArrays.count) {
//        [self.hudManager showMessage:@"请选择举报原因"];
    } else {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"] = [User sharedInstance].accesstoken;
        
        NSMutableDictionary *programDic = [[NSMutableDictionary alloc]init];
        
        programDic[@"adv_id"] = self.redpacket.adv_id;
        
        programDic[@"reason"] = _itemArrays[_currentItem];
        
        HttpRequest *request = [[HttpRequest alloc] init];
        request.isVlaueKey = YES;
        
        [request Method:POST withTransmitHeader:headerDic withApiProgram:nil withBodyProgram:programDic withPathApi:PostAdvertisementAccusation completed:^(id data, NSString *stringData) {
            if (data) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"举报失败,请重试"];
                [alertView showTarget:self];
            }
        } failed:^(RAError *error) {
            CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:@"出错了！" message:@"举报失败,请重试"];
            [alertView showTarget:self];
        }];
    }
}

@end
