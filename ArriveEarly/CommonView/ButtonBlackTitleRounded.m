//
//  ButtonBlackTitleRounded.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ButtonBlackTitleRounded.h"

@implementation ButtonBlackTitleRounded
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 22.0;
    self.clipsToBounds = YES;
    [self setBackgroundColor:CUS_Nav_bgColor forState:UIControlStateNormal];
    [self setTitleColor:UIColorFromRGBA(0x492b00, 1) forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
