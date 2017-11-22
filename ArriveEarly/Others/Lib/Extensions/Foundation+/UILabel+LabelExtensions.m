//
//  UILabel+LabelExtensions.m
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/5/18.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import "UILabel+LabelExtensions.h"

@implementation UILabel (LabelExtensions)
- (void)setTitle:(NSString *)title andColorTitle:(NSString *)colorTitle withColor:(UIColor *)color
{
//    NSMutableAttributedString* noteStr = [[title copy] setStrColor:color colorStr:colorTitle];

    NSString* titleStr = title;
    if (![title containsString:colorTitle]) {
        titleStr = [title stringByAppendingString:colorTitle];
    }
    NSMutableAttributedString* noteStr = [[NSMutableAttributedString alloc] initWithString:titleStr ? titleStr : @""];
    NSInteger location = [[noteStr string] rangeOfString:colorTitle].location;
    NSRange redRange = NSMakeRange(location, colorTitle.length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    
    [self setAttributedText:noteStr];
}
@end
