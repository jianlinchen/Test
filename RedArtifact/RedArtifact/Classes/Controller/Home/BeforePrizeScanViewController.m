//
//  BeforePrizeScanViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/23.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "BeforePrizeScanViewController.h"

@interface BeforePrizeScanViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nav_titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *showImgView;

@property (weak, nonatomic) IBOutlet UILabel *superbonus_titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end

@implementation BeforePrizeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showData];
}

- (void)showData {
    NSArray *images = self.superbonus.images;
    if (images.count > 0) {
        [self.showImgView sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    }
    self.nav_titleLabel.text = [NSString stringWithFormat:@"活动·%@",self.superbonus.event_name];
    self.superbonus_titleLabel.text = [NSString stringWithFormat:@"活动·%@",self.superbonus.event_name];
    self.moneyLabel.text = [NSString stringWithFormat:@"获奖人：¥%@",self.superbonus.max_join_user_num];
    self.moneyLabel.text = [NSString stringWithFormat:@"获奖金额：¥%@",self.superbonus.max_join_user_num];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - button action
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
