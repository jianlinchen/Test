//
//  HomeButtonCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "HomeButtonCell.h"
#import "HomeButtonCollectionCell.h"

static NSString *const kHomeButtonCollectionCellIdentify = @"HomeButtonCollectionCellID";

@interface HomeButtonCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (nonatomic, copy) NSArray *items;

@end

@implementation HomeButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"HomeButtonCollectionCell" bundle:nil] forCellWithReuseIdentifier:kHomeButtonCollectionCellIdentify];
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.scrollEnabled = NO;
}

- (void)initItems:(NSArray *)items {
    self.items = items;
    [self.mainCollectionView reloadData];
}


#pragma mark - UICollectionViewDataSource/Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeButtonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeButtonCollectionCellIdentify forIndexPath:indexPath];
    RAPlugin *plugin = _items[indexPath.row];
    cell.appNameLabel.text = plugin.name;
    [cell.appImgView sd_setImageWithURL:[NSURL URLWithString:plugin.logo] placeholderImage:[UIImage imageNamed:@"bian_default_seating"]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(UIScreenWidth/4 - 20, 100);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RAPlugin *plugin = _items[indexPath.row];
    if (_cellClickBlock) {
        _cellClickBlock(plugin);
    }
}

@end
