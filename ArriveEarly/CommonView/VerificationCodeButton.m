//
//  VerificationCodeButton.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "VerificationCodeButton.h"

@implementation VerificationCodeButton

- (void)awakeFromNib
{
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    [self setBackgroundColor:CUS_Nav_bgColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.preferredMaxLayoutWidth = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//开始倒计时
- (void)beginCountdown:(NSTimeInterval)timeout
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
    mytimeout = timeout;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

- (void)countdown
{
    mytimeout--;
    self.userInteractionEnabled = NO;
    [self setTitle:[NSString stringWithFormat:@"重新获取(%.0fs)",mytimeout] forState:UIControlStateNormal];
    [self setBackgroundColor:Color_Nolmal_666666 forState:UIControlStateNormal];
    if (mytimeout <= 0) {
        self.userInteractionEnabled = YES;
        if (timer)
        {
            [timer invalidate];
            timer = nil;
        }
        [self setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        [self setBackgroundColor:CUS_Nav_bgColor forState:UIControlStateNormal];
    }
}

- (void)clearTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

@end
