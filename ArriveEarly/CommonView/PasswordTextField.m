//
//  PasswordTextField.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/11.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PasswordTextField.h"

@implementation PasswordTextField
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.secureTextEntry = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
