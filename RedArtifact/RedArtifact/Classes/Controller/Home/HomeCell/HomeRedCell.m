//
//  HomeRedCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "HomeRedCell.h"
#import "HomeRedCollectionCell.h"

static NSString *const kHomeRedCollectionCellIdentify = @"HomeRedCollectionCellID";
@interface HomeRedCell () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray *_items;
}
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *nodataLabel;

@end

@implementation HomeRedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _items = [NSMutableArray array];
    
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing           = 0;
    flowLayout.minimumInteritemSpacing      = 0;
    
    _mainCollectionView.collectionViewLayout = flowLayout;
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"HomeRedCollectionCell" bundle:nil] forCellWithReuseIdentifier:kHomeRedCollectionCellIdentify];
    self.mainCollectionView.delegate = self;
    
    self.mainCollectionView.dataSource = self;
    
}
- (void)initWithItems:(NSMutableArray *)items {
    _items = items;
    if (_items.count > 0) {
        self.nodataLabel.hidden = YES;
        [self.mainCollectionView reloadData];
    } else {
        self.nodataLabel.hidden = NO;
    }
    
}
#pragma mark - UICollectionViewDataSource/Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_items.count > 0) {
        return 3;
    } else {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     HomeRedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeRedCollectionCellIdentify forIndexPath:indexPath];
    if (indexPath.row < _items.count) {
        cell.timeLabel.hidden = NO;
        cell.statusLabel.hidden = NO;
        RARedpacket *redpacket = _items[indexPath.row];
        [Tools getServerTimeSuccess:^(NSInteger servertime) {
            if ([redpacket.pub_end_time integerValue] <= servertime) {
                cell.statusLabel.text = @"已结束";
                cell.timeLabel.text = [NSDate dateWithTimeIntervalString:redpacket.pub_end_time withDateFormatter:nil];
                redpacket.status = 1;
            } else if ([redpacket.pub_begin_time integerValue] > servertime) {
                cell.statusLabel.text = @"准备中";
                cell.timeLabel.text = [NSDate dateWithTimeIntervalString:redpacket.pub_begin_time withDateFormatter:nil];
                redpacket.status = 2;
            } else if ([redpacket.bonus_remain_num integerValue] == 0) {
                cell.statusLabel.text = @"已抢光";
                cell.timeLabel.text = [NSDate dateWithTimeIntervalString:redpacket.pub_begin_time withDateFormatter:nil];
                redpacket.status = 3;
            } else {
                cell.statusLabel.text = @"进行中";
                cell.timeLabel.text = [NSDate dateWithTimeIntervalString:redpacket.pub_begin_time withDateFormatter:nil];
                redpacket.status = 4;
            }
        }];
        
        cell.background_imgView.image = [UIImage imageNamed:@"home-red-bg-icon"];
        cell.red_titleLabel.text = [NSString stringWithFormat:@"¥ %@",[NSString setNumLabelWithStr:redpacket.prize_top_money]];
    } else {
        cell.statusLabel.text = @"敬请期待";
        cell.statusLabel.hidden = YES;
        cell.timeLabel.hidden = YES;
        cell.background_imgView.image = [UIImage imageNamed:@"home-redpacket-no"];
    }
    
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UIScreenWidth/3, 120);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 0, 15, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RARedpacket *redpacket = _items[indexPath.row];
    _redPacketClickBlock(redpacket);
}

#pragma mark - action
- (IBAction)reloadDataAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn.layer addAnimation:[self rotation:0.4 degree:90 direction:2 repeatCount:5] forKey:nil];
    
    _redPacketReloadBlock(YES);
}

#pragma mark ====旋转动画======

-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount

{
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    
    animation.duration  =  dur;
    
    animation.autoreverses = NO;
    
    animation.cumulative = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    animation.repeatCount = repeatCount;
    
    animation.delegate = self;
    
    
    
    return animation;
    
    
    
}

@end
