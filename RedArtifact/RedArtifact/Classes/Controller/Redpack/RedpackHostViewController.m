//
//  RedpackHostViewController.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RedpackHostViewController.h"
#import "RedpackViewController.h"

@interface RedpackHostViewController () <UIScrollViewDelegate,TotalNumDelegate>
{
    BOOL _isDetailPush;//是否是详情页返回
    
    UIButton *_currentButton;
}
/** 指示器  */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorLeading;
@property (weak, nonatomic) IBOutlet UILabel *nojoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *nojoin_numLabel;
@property (weak, nonatomic) IBOutlet UIButton *nojoinButton;

@property (weak, nonatomic) IBOutlet UILabel *joinLabel;
@property (weak, nonatomic) IBOutlet UILabel *join_numLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

/** 内容ScrollView  */
@property(nonatomic,weak)UIScrollView * contentView;


@end

@implementation RedpackHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的红包";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.nojoinButton addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.joinButton addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (RedpackDetailViewControllerPush:) name:@"RedpackHostViewController" object:nil];
    
    //初始化子控制器
    [self setupChildVCes];
    
    //初始化内容ScrollView
    [self setupScrollView];
}

- (void)RedpackDetailViewControllerPush:(NSNotificationCenter *)center {
    _isDetailPush = YES;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_isDetailPush) {
        UIButton * btn = [[UIButton alloc] init];
        btn.tag = 101;
        [self titleSelect:btn];
    } else {
        [self titleSelect:_currentButton];
        _isDetailPush = NO;
    }
    
}
#pragma mark - <初始化>
/**
 *  初始化子控制器
 */
-(void)setupChildVCes
{
    RedpackViewController *noJoinVC = [[RedpackViewController alloc]init];
    noJoinVC.status = NotInvolved;
    noJoinVC.delegate = self;
    [self addChildViewController:noJoinVC];
    
    RedpackViewController *joinVC = [[RedpackViewController alloc]init];
    joinVC.status = Involved;
    joinVC.delegate = self;
    [self addChildViewController:joinVC];
}

/**
 *  初始化内容ScrollView
 */
-(void)setupScrollView
{
    //告诉系统不要给我调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建ScrollView
    UIScrollView * contentView = [[UIScrollView alloc]init];
    contentView.frame = [UIScreen mainScreen].bounds;
    CGRect frame = contentView.frame;
    frame.origin.y = 35;
    frame.size.height = UIScreenHeight - 35 - 50 - 64;
    contentView.frame = frame;
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * UIScreenWidth, 0);
    self.contentView = contentView;
    contentView.delegate = self;
    //放到最底部
    [self.view insertSubview:contentView atIndex:0];
    //创建第一个控制器其实掉一下ScrollView的代理方法就OK
    [self scrollViewDidEndScrollingAnimation:contentView];
    self.contentView.pagingEnabled = YES;
    
}
#pragma mark - reloadCount delegate
- (void)reloadNojoinCount:(NSString *)count {
    self.nojoin_numLabel.text = [NSString stringWithFormat:@"%@",count];
}

- (void)reloadJoinCount:(NSString *)count {
    self.join_numLabel.text = [NSString stringWithFormat:@"%@",count];
}
#pragma mark - button Aciton
/**
 *  标题栏选中调用
 */
-(void)titleSelect:(UIButton *)sender
{
    //滚动我的contentView
    CGPoint offset = self.contentView.contentOffset;
    if (sender.tag == 101) {//未参与
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorLeading.constant = 0;
        }];
        self.nojoinLabel.textColor = [UIColor colorWithHex:0xeb6564];
        self.nojoin_numLabel.backgroundColor = [UIColor colorWithHex:0xfea000];
        self.joinLabel.textColor = [UIColor colorWithHex:0x999999];
        self.join_numLabel.backgroundColor = [UIColor colorWithHex:0x999999];
        
        offset.x = 0;
        
    } else {
        //改变指示器
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorLeading.constant = UIScreenWidth*1/2;
        }];
        self.joinLabel.textColor = [UIColor colorWithHex:0xeb6564];
        self.join_numLabel.backgroundColor = [UIColor colorWithHex:0xfea000];
        self.nojoinLabel.textColor = [UIColor colorWithHex:0x999999];
        self.nojoin_numLabel.backgroundColor = [UIColor colorWithHex:0x999999];
        
        offset.x = UIScreenWidth;
    }
    
    [self.contentView setContentOffset:offset animated:YES];
    
    _currentButton = sender;

}

#pragma mark - <代理>
/*
 * 滚动动画完毕调用(人为拖拽不会调用)
 * 添加子控制器的View
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //获取当前索引
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    //根据角标取出我们的子控制器
    UIViewController * vc = self.childViewControllers[index];
    vc.view.backgroundColor = [UIColor clearColor];
    
    CGRect frame = vc.view.frame;
    frame.origin.x = scrollView.contentOffset.x;
    frame.size.height = scrollView.frame.size.height;
    vc.view.frame = frame;
    //添加View
    [scrollView addSubview:vc.view];
}

//用户拖拽结束就调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //点击对应按钮
    //取出对应的角标
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIButton * btn = [[UIButton alloc] init];
    btn.tag = index + 101;
    _currentButton = btn;
    [self titleSelect:btn];
    //主动调用滚动完毕的方法
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


@end
