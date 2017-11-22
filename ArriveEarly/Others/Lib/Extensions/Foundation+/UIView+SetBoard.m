//
//  UIView+SetBoard.m
//  IDoerTW
//
//  Created by iosdev on 16/1/15.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "UIView+SetBoard.h"

@implementation UIView (SetBoard)

- (void)setCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor*)borderColor
{
    if (borderColor && borderWidth) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
    }
    
    if (cornerRadius) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
    }
    
}



@end
