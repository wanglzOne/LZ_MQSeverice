//
//  NoteButtton.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/3.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "NoteButtton.h"

@implementation NoteButtton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 15.0;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:UIColorFromRGBA(0x333333, 1) forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
