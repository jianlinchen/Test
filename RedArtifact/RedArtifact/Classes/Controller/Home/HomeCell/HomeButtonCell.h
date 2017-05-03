//
//  HomeButtonCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/11.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAPlugin.h"

typedef void(^HomeButtonCellClickBlock)(RAPlugin *plugin);

@interface HomeButtonCell : UITableViewCell

@property (nonatomic, copy) HomeButtonCellClickBlock cellClickBlock;

- (void)initItems:(NSArray *)items;

@end
