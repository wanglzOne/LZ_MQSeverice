//
//  CustomStarView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "CustomStarView.h"

@implementation CustomStarView

+ (instancetype)customStarView
{
    CustomStarView *view = [[NSBundle mainBundle] loadNibNamed:@"CustomStarView" owner:nil options:nil][0];
    
    return view;
}

- (IBAction)starAction:(id)sender {
    int starI = [self.btns indexOfObject:sender];
    [self updateBtnsStateWithStarIndex:starI+1];
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
        _btns = [[NSArray alloc] initWithObjects:_btn1,_btn2,_btn3,_btn4,_btn5, nil];
    }
    return _btns;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
