//
//  PleaseLogInView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/21.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PleaseLogInView.h"

@implementation PleaseLogInView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)loadXIB
{
    PleaseLogInView *vi = [[NSBundle mainBundle] loadNibNamed:@"PleaseLogInView" owner:nil options:nil][0];
    vi.frame = CGRectMake(0, 0, 300, 270);
    return vi;
}

- (void)setClickLoginButtonBlock:(CommonVoidBlock) block
{
    self.block = block;
}

- (IBAction)loginButttonAction:(UIButton *)sender {
    
    BLOCK_EXIST(self.block);
    
}


@end
