//
//  AdvertStoreCell.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *advert_store_linkLabel;

@property (weak, nonatomic) IBOutlet UILabel *advert_store_addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *advert_store_telLabel;

@property (weak, nonatomic) IBOutlet UILabel *link_labelLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkTapButton;


@end
