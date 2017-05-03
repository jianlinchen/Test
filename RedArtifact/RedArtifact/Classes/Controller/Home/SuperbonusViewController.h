//
//  SuperbonusViewController.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/21.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RASuperbonus.h"

@interface SuperbonusViewController : UIViewController

@property (nonatomic, copy) NSString *event_id;

@property (nonatomic, strong) RASuperbonus *lastSuperbonus;

@end
