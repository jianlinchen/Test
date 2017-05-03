//
//  RedPacketTableCell.h
//  RedArtifact
//
//  Created by LiLu on 16/8/30.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedPacketTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)deleteAction:(id)sender;

@end
