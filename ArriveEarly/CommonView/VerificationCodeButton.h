//
//  VerificationCodeButton.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationCodeButton : UIButton
{
    NSTimer *timer;
    NSTimeInterval mytimeout;
}
//开始倒计时
- (void)beginCountdown:(NSTimeInterval)timeout;


- (void)clearTimer;

@end
