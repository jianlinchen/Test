//
//  AdvertMineHostController.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/30.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertMineHostController.h"
#import "AdvertMineViewController.h"

@interface AdvertMineHostController () <ViewPagerDelegate, ViewPagerDataSource>
{
    NSArray *_titleArrays;
}

@end

@implementation AdvertMineHostController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的广告";
    
    self.delegate = self;
    self.dataSource = self;
    _titleArrays = @[@"编辑中",@"准备中",@"发送中",@"已完成"];
    self.itemArray = _titleArrays;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (TabSelect) name:@"AdvertMineHostControllerTabSelect" object:nil];

}

//- (void)TabSelect {
//    [self selectTabAtIndex:1];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:AdvertListIndex];
    
    
    if ([indexStr isEqualToString:@"1"]) {
        [self selectTabAtIndex:1];
        
    } else if ([indexStr isEqualToString:@"0"]){
        [self selectTabAtIndex:0];
        
    } else if ([indexStr isEqualToString:@"2"]){
        
    } else {
        [self selectTabAtIndex:0];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AdvertListIndex];
}

#pragma mark - ViewPageDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _titleArrays.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *titleLabel        = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font            = [UIFont systemFontOfSize:15.0];
    titleLabel.text            = [NSString stringWithFormat:@"%@",_titleArrays[index]];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.textColor       = [UIColor colorWithHex:0x666666];
    [titleLabel sizeToFit];
    return titleLabel;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    AdvertMineViewController *vc = [[AdvertMineViewController alloc] init];
    switch (index) {
        case 0:
        {
            vc.status = Editing;
            break;
        }
        case 1:
        {
            vc.status = Prepareing;
            break;
        }
        case 2:
        {
            vc.status = Sending;
            break;
        }
//        case 3:
//        {
//            vc.status = Refunding;
//            break;
//        }
        case 3:
        {
            vc.status = Finished;
            break;
        }
        default:
            break;
    }
    return vc;
}

#pragma mark - ViewPageDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionTabHeight:
        {
            return 35.0;
            break;
        }
          case ViewPagerOptionTabWidth:
        {
            return UIScreenWidth / 4;
        }
        default:
            return value;
            break;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator: {
            return [UIColor colorWithHex:0xeb6564];
            break;
        }
        case ViewPagerContent: {
            return [UIColor whiteColor];
            break;
        }
        case ViewPagerTabsView: {
            return [UIColor whiteColor];
            break;
        }
        default: {
            return color;
        }
    }
}

@end
