//
//  HomeTimerCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/15.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "HomeTimerCell.h"

@interface HomeTimerCell()

@property (nonatomic, strong) NSTimer *changeTimer;

@property (nonatomic, assign) NSInteger secondCount;
@end

@implementation HomeTimerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
}

- (IBAction)joinAction:(id)sender {
    if (self.joinblock) {
        self.joinblock(YES);
    }
}

- (void)initWithServerCurrentTime:(NSString *)currentTime withSuperbonusBeginTime:(NSString *)beginTime withSuperbonusEndTime:(NSString *)endTime {
    [self.changeTimer invalidate];
    self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    if ([beginTime integerValue] - [currentTime integerValue] > 0) {
        _secondCount = [beginTime integerValue] - [currentTime integerValue];
    } else {
        _secondCount = [endTime integerValue] - [currentTime integerValue];
    }
    
    if (_secondCount > 0) {
        NSDictionary *dic = [Tools timeAfterWithInterval:[NSString stringWithFormat:@"%ld",_secondCount]];
        
        int day = [dic[@"day"] intValue];
        [self.day1Label setTitle:[NSString stringWithFormat:@"%d",day/10] forState:UIControlStateNormal];
        [self.day2Label setTitle:[NSString stringWithFormat:@"%d",day%10] forState:UIControlStateNormal];
        
        int hour = [dic[@"hour"] intValue];
        [self.hour1Label setTitle:[NSString stringWithFormat:@"%d",hour/10] forState:UIControlStateNormal];
        [self.hour2Label setTitle:[NSString stringWithFormat:@"%d",hour%10] forState:UIControlStateNormal];
        
        int minute = [dic[@"minute"] intValue];
        [self.minite1Label setTitle:[NSString stringWithFormat:@"%d",minute/10] forState:UIControlStateNormal];
        [self.minite2Label setTitle:[NSString stringWithFormat:@"%d",minute%10] forState:UIControlStateNormal];
        
        int second = [dic[@"second"] intValue];
        [self.second1Label setTitle:[NSString stringWithFormat:@"%d",second/10] forState:UIControlStateNormal];
        [self.second2Label setTitle:[NSString stringWithFormat:@"%d",second%10] forState:UIControlStateNormal];
    } else {
        [self.changeTimer invalidate];
        [self.day1Label setTitle:@"0" forState:UIControlStateNormal];
        [self.day2Label setTitle:@"0" forState:UIControlStateNormal];
        
        [self.hour1Label setTitle:@"0" forState:UIControlStateNormal];
        [self.hour2Label setTitle:@"0" forState:UIControlStateNormal];
        
        [self.minite1Label setTitle:@"0" forState:UIControlStateNormal];
        [self.minite2Label setTitle:@"0" forState:UIControlStateNormal];
        
        [self.second1Label setTitle:@"0" forState:UIControlStateNormal];
        [self.second2Label setTitle:@"0" forState:UIControlStateNormal];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SuperbonusTimerInvalid"
                                                            object:self];
    }
}

- (void)timeFireMethod {
    _secondCount --;
    
    if (_secondCount == 0) {
        [self.changeTimer invalidate];
    }
    
    NSDictionary *dic = [Tools timeAfterWithInterval:[NSString stringWithFormat:@"%ld",_secondCount]];
    int day = [dic[@"day"] intValue];
    [self.day1Label setTitle:[NSString stringWithFormat:@"%d",day/10] forState:UIControlStateNormal];
    [self.day2Label setTitle:[NSString stringWithFormat:@"%d",day%10] forState:UIControlStateNormal];
    
    int hour = [dic[@"hour"] intValue];
    [self.hour1Label setTitle:[NSString stringWithFormat:@"%d",hour/10] forState:UIControlStateNormal];
    [self.hour2Label setTitle:[NSString stringWithFormat:@"%d",hour%10] forState:UIControlStateNormal];
    
    int minute = [dic[@"minute"] intValue];
    [self.minite1Label setTitle:[NSString stringWithFormat:@"%d",minute/10] forState:UIControlStateNormal];
    [self.minite2Label setTitle:[NSString stringWithFormat:@"%d",minute%10] forState:UIControlStateNormal];
    
    int second = [dic[@"second"] intValue];
    [self.second1Label setTitle:[NSString stringWithFormat:@"%d",second/10] forState:UIControlStateNormal];
    [self.second2Label setTitle:[NSString stringWithFormat:@"%d",second%10] forState:UIControlStateNormal];
   
}


@end
