//
//  SearchPoiTableCell.h
//  RedArtifact
//
//  Created by LiLu on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPoiTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end
