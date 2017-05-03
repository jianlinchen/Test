//
//  AdvertDetailViewController.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertMineViewController.h"
#import "RAAdvert.h"

@interface AdvertDetailViewController : UIViewController

@property (nonatomic, assign) BOOL isFinished;//是否彻底完成

@property (nonatomic, strong) RAAdvert *temAdvert;//上层advert

@property (nonatomic, copy) NSString *adv_id;

@property (nonatomic, assign) AdvertMineStatus status;

/** 是否是预览 */
@property (nonatomic, assign) BOOL isScan;

@end
