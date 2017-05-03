//
//  MineViewController.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/17.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MineViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,AlertViewSureDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myNewsTableView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)edictPersonInfoAcction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *changLabel;

@end
