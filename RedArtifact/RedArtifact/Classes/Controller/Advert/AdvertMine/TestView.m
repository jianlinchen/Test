//
//  TestView.m
//  RedArtifact
//
//  Created by LiLu on 16/11/3.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (void)drawRect:(CGRect)rect {
    
    // Start by filling the area with the blue color
//    
//    CGRect holeRect = CGRectMake(0, 100, kScreenWidth, 50);
    
    
    [[UIColor colorWithWhite:0.0f alpha:0.5f] setFill];//阴影效果 根据透明度来设计
    
    UIRectFill( rect );
    
    CGRect holeRectIntersection = CGRectIntersection( self.needRect, rect );
    
    [[UIColor clearColor] setFill];
    
    UIRectFill( holeRectIntersection );
    
}

@end
