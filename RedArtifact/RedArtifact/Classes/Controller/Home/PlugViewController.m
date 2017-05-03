//
//  PlugViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/10/26.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "PlugViewController.h"
#import "PlugCell.h"

static NSString *const kPlugCellIdentify = @"PlugCellID";

@interface PlugViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _clickItem;//点击的row
    
    NSMutableArray *_itemArrays;
}

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@end

@implementation PlugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _clickItem = 0;
    _itemArrays = [NSMutableArray array];
    
    //_mainCollectionView
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing           = 0;
    flowLayout.minimumInteritemSpacing      = 0;
    
    _mainCollectionView.collectionViewLayout = flowLayout;
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"PlugCell" bundle:nil] forCellWithReuseIdentifier:kPlugCellIdentify];
    self.mainCollectionView.delegate = self;
    
    self.mainCollectionView.dataSource = self;
    
    //mainWebView
//    self.mainWebView.delegate=self;
    [self.mainWebView setScalesPageToFit:YES];
    self.mainWebView.backgroundColor = [UIColor whiteColor];
    self.mainWebView.opaque = NO;
    
    [self getPluginData];
    
}

#pragma mark - UICollectionViewDataSource/Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlugCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPlugCellIdentify forIndexPath:indexPath];
    RAPlugin *plugin = _itemArrays[indexPath.row];
    [cell.plugImgView sd_setImageWithURL:[NSURL URLWithString:plugin.logo] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    cell.plugNameLabel.text = plugin.name;
    
    if (_clickItem == indexPath.row) {
        cell.bottmLineView.hidden = NO;
    } else {
        cell.bottmLineView.hidden = YES;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RAPlugin *plugin = _itemArrays[indexPath.row];
    CGFloat width = [plugin.name sizeOfStringFont:[UIFont systemFontOfSize:13] width:UIScreenWidth].width;
    CGFloat returnWidth = width + 8 + 8 + 20 + 5;
    return CGSizeMake(returnWidth, 40);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _clickItem = indexPath.row;
    [self.mainCollectionView reloadData];
    
    RAPlugin *plugin = _itemArrays[indexPath.row];
    
    if (plugin.target) {
        [self changeWebUrl:plugin.target];
    } else {
        [self changeWebUrl:plugin.link];
    }
//    if ([plugin.target containsString:@"http"]) {
//        [self changeWebUrl:plugin.target];
//    } else {
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:plugin.target]])
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:plugin.target]];
//        } else {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:plugin.link]];
//        }
//    }
}

- (void)changeWebUrl:(NSString *)url {
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - GET DATA 
//获取插件数据
-(void)getPluginData {
//    YTKKeyValueItem *item = [[YTKKeyValueItem alloc] init];
//    item = [RADBTool getObjectItemDataWithObjectID:kRAHomeViewControllerPlugin withTableName:kHomeTableName];
//    if ([RADBTool isInvalidWithObjectID:item withExpirydate:0]) {
        NSMutableDictionary *headerDic=[[NSMutableDictionary alloc]init];
        headerDic[@"ACCESS-TOKEN"]=[User sharedInstance].accesstoken;
        
        NSMutableDictionary *apiDic = [[NSMutableDictionary alloc]init];
        apiDic[@"plugin_id"] = self.lastPlugin.plugin_id;
        
        [GLOBLHttp Method:GET withTransmitHeader:headerDic withApiProgram:apiDic withBodyProgram:nil withPathApi:GetPluginDetail completed:^(id data, NSString *stringData) {
            if (data) {
                [_itemArrays removeAllObjects];
                [_itemArrays addObjectsFromArray:[RAPlugin mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]]];
                
                if (_itemArrays.count > 0) {
                    
                    [self.mainCollectionView reloadData];
                    
                    RAPlugin *plugin = _itemArrays[0];
                    
                    if (plugin.target) {
                        [self changeWebUrl:plugin.target];
                    } else {
                        [self changeWebUrl:plugin.link];
                    }
                }
                
                
                
//                [RADBTool putObject:data withId:kRAHomeViewControllerPlugin intoTable:kHomeTableName withComplete:nil];
            }
            
        } failed:^(RAError *error) {
            if (error) {
                DLog(@"%@",error.errorDetail);
            }
//            [_itemArrays removeAllObjects];
//            [_itemArrays addObjectsFromArray:[RAPlugin mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
//            [self.mainCollectionView reloadData];
//            
//            RAPlugin *plugin = _itemArrays[0];
//            if ([plugin.target containsString:@"http"]) {
//                [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:plugin.target]]];
//            }
            
        }];
//    } else {
//        [_itemArrays removeAllObjects];
//        [_itemArrays addObjectsFromArray:[RAPlugin mj_objectArrayWithKeyValuesArray:item.itemObject[@"data"][@"list"]]];
//        [self.mainCollectionView reloadData];
//        
//        RAPlugin *plugin = _itemArrays[0];
//        if ([plugin.target containsString:@"http"]) {
//            [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:plugin.target]]];
//        }
        
//    }
}

@end
