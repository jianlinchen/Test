//
//  CatchCrash.h
//  RedArtifact
//
//  Created by LiLu on 16/8/10.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatchCrash : NSObject

void uncaughtExceptionHandler(NSException *exception);

@end
