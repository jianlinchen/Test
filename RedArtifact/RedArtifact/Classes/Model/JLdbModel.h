//
//  JLdbModel.h
//  RedArtifact
//
//  Created by LiLu on 16/9/29.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLdbModel : NSObject
@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;
@end
