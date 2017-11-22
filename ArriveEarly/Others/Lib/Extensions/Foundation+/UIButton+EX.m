//
//  UIButton+EX.m
//  IDoerTW
//
//  Created by iosdev on 15/10/14.
//  Copyright © 2015年 iosdev. All rights reserved.
//

#import "UIButton+EX.h"

@implementation UIButton (EX)

- (void)btnBoardCGColor:(CGColorRef)cgcolor
{
    self.layer.cornerRadius = 1;
    self.layer.borderColor = cgcolor;
    self.layer.borderWidth = 1.0;
    self.clipsToBounds = YES;
}

- (void)setBGImagefroNormal:(UIImage*)normalImage highlighted:(UIImage*)highlightedImage
{
    //保证 btn type 是custom 才有效
    /**
     *  [UIImage renderImageWithColor:ColorWith(0x80, 0x80, 0x80) inSize:cell.titleBtn.frame.size]
     */
    if (normalImage) {
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage) {
        [self setAdjustsImageWhenHighlighted:YES];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
}

//[UIImage renderImageWithColor:ColorWith(0x80, 0x80, 0x80) inSize:cell.titleBtn.frame.size]

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)controlStateNormal
{
    if (!color) {
        return;
    }
    if (controlStateNormal == UIControlStateHighlighted) {
        [self setAdjustsImageWhenHighlighted:YES];
    }
    
    if (color) {
        [self setBackgroundImage:[self renderImageWithColor:color inSize:self.frame.size] forState:controlStateNormal];
    }
}

- (UIImage *)renderImageWithColor:(UIColor *)color inSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    return image;
}

@end
