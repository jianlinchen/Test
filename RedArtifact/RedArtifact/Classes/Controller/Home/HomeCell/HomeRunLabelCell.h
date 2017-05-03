//
//  HomeRunLabelCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AdvertLabelClickBlock)(NSInteger item);

@interface HomeRunLabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *changeView;

@property (nonatomic, copy) AdvertLabelClickBlock advertLabelClickBlock;

- (void)initWithItems:(NSMutableArray *)itemArrays WithAdvertLabelClickBlock:(AdvertLabelClickBlock)advertLabelClickBlock;

@end
