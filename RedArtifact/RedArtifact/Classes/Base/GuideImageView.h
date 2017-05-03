//
//  GuideImageView.h
//  RedArtifact
//
//  Created by xiaoma on 16/11/3.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    directionTop,
    directionBottom,
} Direction;

@interface GuideImageView : UIImageView

- (instancetype)initWithImageName:(NSString *)imageName withVerticalDirection:(Direction)direction;

- (void)showTarget:(UIViewController *)target;

@end
