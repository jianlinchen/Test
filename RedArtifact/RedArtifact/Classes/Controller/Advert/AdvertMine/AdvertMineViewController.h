//
//  AdvertMineViewController.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    Editing,     //编辑中
    Prepareing,  //准备中
    Sending,     //发送中
    Finished,    //已完成
}AdvertMineStatus;


@interface AdvertMineViewController : BaseViewController

@property (nonatomic, assign) AdvertMineStatus status;

@end
