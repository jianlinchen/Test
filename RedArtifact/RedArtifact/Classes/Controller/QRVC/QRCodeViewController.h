//
//  QRCodeViewController.h
//  advert_shop
//
//  Created by LiLu on 16/6/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface QRCodeViewController : BaseViewController
@property (nonatomic,strong) NSString *nameStr;
//@property (nonatomic,strong) NSString *name;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLayoutTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saoLayoutTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perImageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgLayoutHeight;

@end
