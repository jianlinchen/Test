//
//  HomeRedCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RARedpacket.h"

typedef void(^RedPacketReloadBlock)(BOOL reload);

typedef void(^RedPacketClickBlock)(RARedpacket *redpacket);

@interface HomeRedCell : UITableViewCell

@property (nonatomic, copy) RedPacketReloadBlock redPacketReloadBlock;

@property (nonatomic, copy) RedPacketClickBlock redPacketClickBlock;

- (void)initWithItems:(NSMutableArray *)items;

@end
