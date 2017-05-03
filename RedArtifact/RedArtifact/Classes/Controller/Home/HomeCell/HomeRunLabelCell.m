//
//  HomeRunLabelCell.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/12.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "HomeRunLabelCell.h"

@interface HomeRunLabelCell()

@property (nonatomic, copy) NSMutableArray *itemArrays;

@property (nonatomic, strong) NSTimer *changeTimer;

@property (nonatomic, assign) NSInteger  index;

@property (nonatomic, assign) CGRect firstFrame;

@property (nonatomic, assign) CGRect secondFrame;

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, copy)   NSString *currentStr;

@end

@implementation HomeRunLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _itemArrays = [NSMutableArray array];
    self.index = 0;
    _changeView.clipsToBounds = YES;
    
    _firstButton = [[UIButton alloc] init];
    _firstButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    [_firstButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    _firstButton.titleLabel.textColor = [UIColor colorWithHex:0xff3b65];
    _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _secondButton = [[UIButton alloc] init];
    _secondButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    [_secondButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    _secondButton.titleLabel.textColor = [UIColor colorWithHex:0xff3b65];
    _secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _firstFrame = _changeView.bounds;
    self.firstButton.frame = _firstFrame;
    _secondFrame = _changeView.bounds;
    self.secondButton.frame = _secondFrame;
    [_firstButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [_firstButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_secondButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [_secondButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_changeView addSubview:_firstButton];
    [_changeView addSubview:_secondButton];
    
    self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(repeadFuntion) userInfo:self repeats:YES];

}

- (void)clickButton {
//    NSLog(@"=================%@",_currentStr);
}

- (void)repeadFuntion {
    if (_itemArrays.count > 1) {
        if (self.index + 2 > _itemArrays.count) {
            self.index = 0;
        } else {
            self.index ++;
        }
        
        [self setButtonTitle:_itemArrays[self.index]];
    }
    
}

- (void)setButtonTitle:(NSString *)message {
    
    _currentStr = message;
    if (_firstButton.hidden == YES) {
        
        [self.firstButton setTitle:message forState:UIControlStateNormal];
        
        _firstButton.hidden = NO;
        
        _firstFrame.origin.y = self.changeView.frame.size.height;
        _firstFrame.size.height = self.changeView.frame.size.height;
        _firstFrame.size.width = self.changeView.frame.size.width;
        self.firstButton.frame = _firstFrame;
        
        _secondFrame.origin.y = 0;
        _secondFrame.size.height = self.changeView.frame.size.height;
        _secondFrame.size.width = self.changeView.frame.size.width;
        self.secondButton.frame = _secondFrame;
        [UIView animateWithDuration:0.2 animations:^{
            _firstFrame.origin.y = 0;
            _firstFrame.size.height = self.changeView.frame.size.height;
            _firstFrame.size.width = self.changeView.frame.size.width;
            self.firstButton.frame = _firstFrame;
            
            _secondFrame.origin.y = 0;
            _secondFrame.size.height = 0;
            self.secondButton.frame = _secondFrame;
        } completion:^(BOOL finished) {
            self.secondButton.hidden = YES;
        }];
    } else {
        [_secondButton setTitle:message forState:UIControlStateNormal];
        
        
        self.secondButton.hidden = NO;
        
        _firstFrame.origin.y = 0;
        _firstFrame.size.height = self.changeView.frame.size.height;
        _firstFrame.size.width = self.changeView.frame.size.width;
        self.firstButton.frame = _firstFrame;
        
        _secondFrame.origin.y = self.changeView.frame.size.height;
        _secondFrame.size.height = self.changeView.frame.size.height;
        _secondFrame.size.width = self.changeView.frame.size.width;
        self.secondButton.frame = _secondFrame;
        [UIView animateWithDuration:0.2 animations:^{
            _secondFrame.origin.y = 0;
            _secondFrame.size.height = self.changeView.frame.size.height;
            self.secondButton.frame = _secondFrame;
            
            _firstFrame.origin.y = 0;
            _firstFrame.size.height = 0;
            self.firstButton.frame = _firstFrame;
        } completion:^(BOOL finished) {
            self.firstButton.hidden = YES;
        }];
    }
}

- (void)initWithItems:(NSMutableArray *)itemArrays WithAdvertLabelClickBlock:(AdvertLabelClickBlock)advertLabelClickBlock {
    if (itemArrays.count > 0) {
        if (itemArrays.count > 2) {
            _itemArrays = itemArrays;
            
        } else if (itemArrays.count == 1) {
            NSString *str = itemArrays[0];
            _itemArrays = [NSMutableArray arrayWithObjects:str,str,str, nil];
        } else {
            NSString *str1 = itemArrays[0];
            NSString *str2 = itemArrays[1];
            _itemArrays = [NSMutableArray arrayWithObjects:str1,str2,str1, nil];
        }
        
        [_firstButton setTitle:_itemArrays[0] forState:UIControlStateNormal];
        _currentStr = _itemArrays[0];
    }
    
    
    _advertLabelClickBlock = advertLabelClickBlock;
}

@end
