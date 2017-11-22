//
//  UIButton+EX.h
//  IDoerTW
//
//  Created by iosdev on 15/10/14.
//  Copyright © 2015年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EX)

- (void)btnBoardCGColor:(CGColorRef)cgcolor;
/**
 *  设置 CustomButton 的普通和高亮状态下的图片
 *
 *  @param normalImage      <#normalImage description#>
 *  @param highlightedImage <#highlightedImage description#>
 */
- (void)setBGImagefroNormal:(UIImage*)normalImage highlighted:(UIImage*)highlightedImage;
/**
 *  设置 CustomButton 某 状态xia 颜色 图片
 *
 *  @param color              <#color description#>
 *  @param controlStateNormal <#controlStateNormal description#>
 */
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)controlStateNormal;

@end
