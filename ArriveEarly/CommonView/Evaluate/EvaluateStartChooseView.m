//
//  EvaluateStartChooseView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "EvaluateStartChooseView.h"

@implementation EvaluateStartChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)starButtonClick:(id)sender {
    int starI = (int)[self.btns indexOfObject:sender];
    [self updateBtnsStateWithStarIndex:starI+1];
    
    if (self.block) {
        self.block();
    }
}

//0-5
- (void)setStarIndex:(int)starIndex
{
    [self updateBtnsStateWithStarIndex:starIndex];
}


- (int)starIndex
{
    for (int i = 0; i < self.btns.count; i ++) {
        UIButton *btn = self.btns[i];
        if (!btn.selected) {
            return i;
        }
    }
    return 5;
}

- (void)updateBtnsStateWithStarIndex:(int)starIndex
{
    for (int i = 0; i < self.btns.count; i ++) {
        UIButton *btn = self.btns[i];
        if (i < starIndex) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
}

- (NSArray *)btns
{
    if (!_btns) {
        _btns = [[NSArray alloc] initWithObjects:_start1,_start2,_start3,_start4,_start5, nil];
    }
    return _btns;
}


@end
