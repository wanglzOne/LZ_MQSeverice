//
//  UILabel+LabelExtensions.h
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/5/18.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelExtensions)
/**
 *  设置 title 的 中的 字体的颜色
 *
 *  @param title      标题
 *  @param colorTitle 有颜色标题
 *  @param color      颜色
 */
- (void)setTitle:(NSString *)title andColorTitle:(NSString *)colorTitle withColor:(UIColor *)color ;

@end
