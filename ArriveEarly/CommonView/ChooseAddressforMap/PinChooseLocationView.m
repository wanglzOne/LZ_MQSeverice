//
//  PinChooseLocationView.m
//  ETPassenger
//
//  Created by  YiDaChuXing on 16/10/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "PinChooseLocationView.h"

@implementation PinChooseLocationView


+ (instancetype)createPinChooseLocationView
{
    PinChooseLocationView *pinView = [[NSBundle mainBundle] loadNibNamed:@"PinChooseLocationView" owner:nil options:nil][0];
    pinView.backgroundColor = [UIColor clearColor];
    pinView.bounds = CGRectMake(0, 0, 11.5, 29);
    return pinView;
}

- (CGPoint)pinPoing
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width/2, CGRectGetMaxY(self.frame));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
