//
//  LBTabBar.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBar.h"
#import <objc/runtime.h>
#import "UIImage+Image.h"

static NSString *AssociatedButtonKey;

#define LBMagin 10
@interface LBTabBar ()

/** plus按钮 */
@property (nonatomic, weak) UIButton *plusBtn ;

@end

@implementation LBTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];

        UIButton *plusBtn = objc_getAssociatedObject(self, &AssociatedButtonKey);
        if (!plusBtn) {
            plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            objc_setAssociatedObject(self, &AssociatedButtonKey, plusBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
            [plusBtn setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateHighlighted];
        }
        
        self.plusBtn = plusBtn;


        [plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:plusBtn];
    }
    
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
    
    centerButton.bounds = CGRectMake(0, 0, centerButton.currentBackgroundImage.size.width, centerButton.currentBackgroundImage.size.height);
    CGFloat buttonW = self.frame.size.width / (self.items.count + 1);
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    int index = 0;
    
    centerButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5 - 2*LBMagin+8);
    for (UIView *chidView in self.subviews) {
        if ([chidView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            buttonX = index *buttonW;
            index++;
            if (index == 2) {
                index++;
            }
            chidView.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        }
    }
    
    [self bringSubviewToFront:self.plusBtn];
}

//点击了发布按钮
- (void)plusBtnDidClick
{
    //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
    if ([self.delegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }

}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {

        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.plusBtn];

        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.plusBtn pointInside:newP withEvent:event]) {
            return self.plusBtn;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了

            return [super hitTest:point withEvent:event];
        }
    }

    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
