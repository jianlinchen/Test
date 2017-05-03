//
//  RAError.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RAError.h"

@implementation RAError
- (instancetype)initWithDescription:(NSString *)aDescription
                               code:(RAErrorCode)aCode
                        errorDetail:(NSString *)aErrorDetail {
    self = [super self];
    if (self) {
        self.errorDescription = aDescription;
        self.code = aCode;
        self.errorDetail = aErrorDetail;
    }
    return self;
}


@end
