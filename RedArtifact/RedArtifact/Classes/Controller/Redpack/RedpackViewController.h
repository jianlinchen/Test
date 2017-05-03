//
//  RedpackViewController.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/18.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    NotInvolved,//未参与
    Involved//已参与
} RedpackStatus;

@protocol TotalNumDelegate <NSObject>

- (void)reloadNojoinCount:(NSString *)count;

- (void)reloadJoinCount:(NSString *)count;

@end

@interface RedpackViewController : BaseViewController<AlertViewSureDelegate>

@property (nonatomic, assign) RedpackStatus status;

@property (nonatomic, assign) id<TotalNumDelegate>delegate;

@end
