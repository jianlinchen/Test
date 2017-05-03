//
//  SuperbonusStatusViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/10/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "SuperbonusStatusViewController.h"

@interface SuperbonusStatusViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *litterImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bitImgView;
@property (weak, nonatomic) IBOutlet UILabel *litterLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidthLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;

@end

@implementation SuperbonusStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self showData];
}

- (void)showData {
    self.bigLabel.font = [UIFont fontWithName:@"迷你简综艺" size:45];
    self.litterLabel.font = [UIFont fontWithName:@"迷你简综艺" size:20];
    if (self.joinStatus == 0) {//获奖
        self.litterImgView.image = [UIImage imageNamed:@"superbonus_duijiang_yes_litter"];
        self.bitImgView.image = [UIImage imageNamed:@"superbonus_duijiang_yes_big"];
        self.litterLabel.text = @"恭喜您获得了";
        NSString *priceStr = [NSString stringWithFormat:@"%@元",[NSString setNumLabelWithStr:[NSString stringWithFormat:@"%@",self.prize]]];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:priceStr];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:16.0]
         
                              range:NSMakeRange(priceStr.length - 1, 1)];
        
        self.bigLabel.attributedText = AttributedStr;
        
        self.viewWidthLayout.constant = 170;
    } else if (self.joinStatus == 1) {//未参与
        self.litterImgView.image = [UIImage imageNamed:@"superbonus_duijiang_no_litter"];
        self.bitImgView.image = [UIImage imageNamed:@"superbonus_duijiang_no_big"];
        self.bigLabel.text = @"您没参与";
        self.litterLabel.text = @"很遗憾";
        self.viewWidthLayout.constant = 120;
        
    } else {//未得奖
        self.litterImgView.image = [UIImage imageNamed:@"superbonus_duijiang_no_litter"];
        self.bitImgView.image = [UIImage imageNamed:@"superbonus_duijiang_no_big"];
        
        self.bigLabel.text = @"谢谢参与";
        if (UIScreenWidth > 320) {
            self.litterLabel.text = @"很遗憾！您没有得奖";
            self.viewWidthLayout.constant = 230;
        } else {
            self.litterLabel.text = @"您没有得奖";
            self.viewWidthLayout.constant = 160;
            
           
        }
    }
    
    if (UIScreenWidth == 320) {
        self.topLayout.constant = 10;
        self.bottomLayout.constant = 5;
    }
}

@end
