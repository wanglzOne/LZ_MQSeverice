//
//  EvaluateChooseView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "EvaluateChooseView.h"

@implementation EvaluateChooseView



- (IBAction)evaluateButtonClick:(UIButton *)evButtton {
    self.evaluate1.selected = NO;
    self.evaluate3.selected = NO;
    self.evaluate5.selected = NO;

    evButtton.selected = YES;
    
    if (self.block) {
        self.block();
    }
}

- (void)setStarIndex:(int)starIndex
{
    self.evaluate1.selected = NO;
    self.evaluate3.selected = NO;
    self.evaluate5.selected = NO;
    switch (starIndex) {
        case 1:
            self.evaluate1.selected = YES;
            break;
        case 3:
            self.evaluate3.selected = YES;
            break;
        case 5:
            self.evaluate5.selected = YES;
            break;
            
        default:
            break;
    }
}

- (int)starIndex
{
    if (self.evaluate1.selected == YES) {
        return 1;
    }
    else if (self.evaluate3.selected == YES) {
        return 3;
    }
    else if (self.evaluate5.selected == YES) {
        return 5;
    }
    return 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
