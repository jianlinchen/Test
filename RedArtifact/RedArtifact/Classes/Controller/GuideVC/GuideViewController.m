//
//  GuideViewController.m
//  bianLianEnterprise
//
//  Created by 王金玉 on 16/5/23.
//  Copyright © 2016年 王金玉. All rights reserved.
//

#import "GuideViewController.h"
//#import "LoginController.h"
//#import "CusGuideView.h"
#import "MCPagerView.h"
@implementation GuideViewController
#define     kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define     kScreenHeight           [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    //IOS7以上的版本和低版本显示出来的导航栏高度位置有差别，这个差别就是状态栏的高度20，为了兼容低版本，必须统一
    //7.0以上版本通过一句代码解决高度上升问题
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    [self initGuide];   //加载新用户指导页面
}


- (void)initGuide
 {
     self.navigationController.navigationBarHidden = YES;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_scrollView setContentSize:CGSizeMake(kScreenWidth*3, -10)];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;//打开点击事件
    [_scrollView setPagingEnabled:YES];  //视图整页显示
    [_scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
     _scrollView.showsHorizontalScrollIndicator = NO;//是否显示水平方向的滚动条
//    创建三个引导页的image
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [imageview setImage:[UIImage imageNamed:@"引导页新1"]];
     [_scrollView addSubview:imageview];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
    [imageview1 setImage:[UIImage imageNamed:@"引导页新2"]];
    [_scrollView addSubview:imageview1];
    
    imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight)];
    [imageview2 setImage:[UIImage imageNamed:@"引导页新3"]];
     imageview2.userInteractionEnabled = YES;
    [_scrollView addSubview:imageview2];

     //在imageview2上加载一个透明的button
    button = [UIButton buttonWithType:UIButtonTypeCustom];   [button setTitle:nil forState:UIControlStateNormal];
    [button setFrame:CGRectMake(kScreenWidth/2-84, kScreenHeight-76-37+20, 167, 38)];
     [button setTitleColor:RGBHex(0xfea000) forState:UIControlStateNormal];
     [button setTitle:@"立即进入" forState:UIControlStateNormal];
     button.layer.cornerRadius=19.0f; //设置为图片宽度的一半出来为圆形
     button.layer.borderWidth=1.0f; //边框宽度
     button.layer.borderColor=[RGBHex(0xfea000) CGColor];//边框颜色
     
//    button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"按钮.png"]];
    button.alpha = 0.1;
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    [imageview2 addSubview:button];
    [self.view addSubview:_scrollView];
//   //带图片的自定义pager点点
//         if (kScreenWidth>320) {
//       pagerView = [[MCPagerView alloc] initWithFrame:CGRectMake(kScreenWidth/2.5, kScreenHeight-50, 40, 10)];
//         
//     }else{
//          pagerView = [[MCPagerView alloc] initWithFrame:CGRectMake(kScreenWidth/2.8, kScreenHeight-50, 40, 10)];
//
//     }
//     // Pager
//     [pagerView setImage:[UIImage imageNamed:@"pointAfter.png"]
//        highlightedImage:[UIImage imageNamed:@"poinNowShow.png"]
//                  forKey:@"a"];
//     [pagerView setImage:[UIImage imageNamed:@"pointAfter.png"]
//        highlightedImage:[UIImage imageNamed:@"poinNowShow.png"]
//                  forKey:@"b"];
//     [pagerView setImage:[UIImage imageNamed:@"pointAfter.png"]
//        highlightedImage:[UIImage imageNamed:@"poinNow.png"]
//                  forKey:@"c"];
//     [pagerView setPattern:@"abc"];//点点个数
//     pagerView.delegate = self;
//     [self.view addSubview:pagerView];
}
- (void)updatePager
{
    pagerView.page = floorf(_scrollView.contentOffset.x / _scrollView.frame.size.width);
}
//scrollView结束滑动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePager];
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    if ( page == 2) {
        //滑到最后一页button颜色渐变出来
        [UIView animateWithDuration:2.0 animations:^{
            button.alpha = 1;
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self updatePager];
    }
}

- (void)pageView:(MCPagerView *)pageView didUpdateToPage:(NSInteger)newPage
{
    CGPoint offset = CGPointMake(_scrollView.frame.size.width * pagerView.page, 0);
    [_scrollView setContentOffset:offset animated:YES];
}

- (void)viewDidUnload
{
    pagerView = nil;
    _scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//点击进入
- (void)firstpressed{
////    //设置一个图片;
////    UIImageView *niceView = [[UIImageView alloc] initWithFrame:button.frame];
////    button.alpha = 0;
////    niceView.image = [UIImage imageNamed:@"按钮.png"];
////    //添加到场景
////    [imageview2 addSubview:niceView];
////    //放到最顶层;
////    [self.view bringSubviewToFront:niceView];
//    //开始设置动画;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
//    [UIView setAnimationDelegate:self];
//    //這裡還可以設置回調函數;
////    niceView.alpha = 0.0;
////    niceView.frame = self.view.frame;
//    self.view.alpha = 0.0;
//    self.view.frame = self.view.frame;
//    [UIView commitAnimations];
    [UIView animateWithDuration:1.5 animations:^{
        self.view.transform = CGAffineTransformMakeScale(2, 2);
        self.view.alpha = 0.4;
    }];
    //GCD延时执行
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        //执行事件
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"quitToLoginVC" object:nil];
    });
}
-(void)changePage:(UIPageControl *)contrl
{
    //    当点击这个点点框的时候，显示的视图的位置跟着改变
    CGPoint offset = CGPointMake(_scrollView.bounds.size.width*contrl.currentPage,_scrollView.contentOffset.y);
    [_scrollView setContentOffset:offset animated:YES];
    
}

@end
