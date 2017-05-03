//
//  GuideViewController.h
//  bianLianEnterprise
//
//  Created by 王金玉 on 16/5/23.
//  Copyright © 2016年 王金玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPagerView.h"
@interface GuideViewController : UIViewController<UIScrollViewDelegate,MCPagerViewDelegate>
{
    UIScrollView *_scrollView;
//    UIScrollView *scrollView;
//    MyPageControl * pageControl;
    MCPagerView * pagerView;
    UIPageControl * pageControl;

    UIButton *button;
    UIImageView *imageview2;
}
@end
