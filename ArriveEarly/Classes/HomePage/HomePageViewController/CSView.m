//
//  CSView.m
//  ArriveEarly
//
//  Created by 黎恩宏 on 17/3/29.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "CSView.h"

@implementation CSView


+(instancetype)initCSView
{
   CSView *vi = [[NSBundle mainBundle] loadNibNamed:@"CSView" owner:self options:nil].lastObject;;
    vi.frame = [UIScreen mainScreen].bounds;
    return vi;
}
- (IBAction)clickButtonAction:(id)sender {
    [self hide_custom];
}



@end
