//
//  NullLabel.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/4.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "NullLabel.h"

@implementation NullLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setText:(NSString *)text
{
    if (text != (id)kCFNull) {
        [super setText:text];
    }else
    {
        text = @"";
        [super setText:text];
    }
}

@end
