//
//  AdvertDetailSetupCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/1.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "AdvertDetailSetupCell.h"
#import "AddressSetupCell.h"
#import "RAAdvert.h"

static NSString *const kAddressSetupCellIdentify = @"AddressSetupCellID";

@interface AdvertDetailSetupCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation AdvertDetailSetupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"AddressSetupCell" bundle:nil] forCellReuseIdentifier:kAddressSetupCellIdentify];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UITableViewDataSource/Deleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addressArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressSetupCell *setupCell = [tableView dequeueReusableCellWithIdentifier:kAddressSetupCellIdentify];
    if (indexPath.row == 0) {
        setupCell.addressTitleLabel.hidden = NO;
    } else {
        setupCell.addressTitleLabel.hidden = YES;
    }
    
    RAAdvert *advert = _addressArrays[indexPath.row];
    NSString *addressStr = advert.pub_address;
    NSString *distanceStr = [NSString stringWithFormat:@"<%@米",advert.pub_range];
    NSString *showStr = [NSString stringWithFormat:@"%@空格%@",addressStr,distanceStr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:showStr];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor whiteColor]
     
                          range:NSMakeRange(addressStr.length, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithHex:0xfea000]
     
                          range:NSMakeRange(addressStr.length + 2, distanceStr.length)];
    
    // 调整行间距
    CGFloat height = [showStr sizeOfStringFont:[UIFont systemFontOfSize:13] width:tableView.frame.size.width - 64].height;
    if (height > 16) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:9];
        
        [AttributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [showStr length])];
    }
    
    setupCell.addressLabel.attributedText = AttributedStr;
    
    return setupCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RAAdvert *advert = _addressArrays[indexPath.row];
    NSString *addressStr = advert.pub_address;
    NSString *distanceStr = [NSString stringWithFormat:@"<%@米",advert.pub_range];
    NSString *showStr = [NSString stringWithFormat:@"%@空格%@",addressStr,distanceStr];
    
    CGFloat width = UIScreenWidth - 64 - 24;
    
    CGFloat height = [showStr sizeOfStringFont:[UIFont systemFontOfSize:13] width:width].height;
    
    if (height > 16) {
    
        return height  + 24 + 9;
    } else {
        return height  + 24;
    }
    
}
@end
