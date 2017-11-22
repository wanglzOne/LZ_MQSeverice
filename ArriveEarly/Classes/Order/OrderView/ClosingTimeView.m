//
//  ClosingTimeView.m
//  ArriveEarly
//
//  Created by 王立志 on 2017/2/18.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "ClosingTimeView.h"

@implementation ClosingTimeView


+(instancetype)initCustomView
{
    ClosingTimeView *vi = [[NSBundle mainBundle] loadNibNamed:@"ClosingTimeView" owner:self options:nil].lastObject;;
    vi.frame = [UIScreen mainScreen].bounds;
    return vi;
}
- (IBAction)clickButtonAction:(id)sender {
    [self hide_custom];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
