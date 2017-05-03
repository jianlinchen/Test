//
//  GuideImageView.m
//  RedArtifact
//
//  Created by xiaoma on 16/11/3.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "GuideImageView.h"

@interface GuideImageView ()

@end

@implementation GuideImageView
- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGuideImageView:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName withVerticalDirection:(Direction)direction {
    self = [self init];
    if (direction == directionTop) {
        if (UIScreenWidth > 375) {
            self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        } else {
            self.frame = CGRectMake((UIScreenWidth - 375)/2, 0, 375, 667);
        }
    } else if (direction == directionBottom) {
        if (UIScreenWidth > 375) {
            self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
        } else {
            self.frame = CGRectMake((UIScreenWidth - 375)/2, (UIScreenHeight - 667), 375, 667);
        }
    }
    
    self.image = [UIImage imageNamed:imageName];
    
    
    return self;
}

- (void)tapGuideImageView:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

- (void)showTarget:(UIViewController *)target {
    [target.view.window addSubview:self];
}
@end
