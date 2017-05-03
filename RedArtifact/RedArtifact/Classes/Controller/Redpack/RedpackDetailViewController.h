//
//  RedpackDetailViewController.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RARedpacket.h"
#import "RAConsumer.h"
#import "RedpackViewController.h"

@interface RedpackDetailViewController : UIViewController

@property (nonatomic, strong) RARedpacket *redpacket;

@property (nonatomic, strong) RAConsumer *consumer;

@property (nonatomic, assign) RedpackStatus status;

//预览广告ID
@property (nonatomic, copy) NSString *scanAdv_id;

//是否是预览
@property (nonatomic, assign) BOOL isScan;

@end
