//
//  UIButton+ETUtil.m
//  EasyDriver
//
//  Created by chenxianwu on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import "UIButton+ETUtil.h"

@implementation UIButton (ETUtil)

+(UIButton *) createButtonWithCGRect:(CGRect) frame title:(NSString *) title titleColor:(UIColor *) titleColor titleFont:(UIFont *) titleFont image:(UIImage *) image normalBackImage:(UIImage *) NorBackImage selectedImage:(UIImage *) seleImage {
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
//    [button setTitleColor:titleColor forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font= titleFont;
//    [button setImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:NorBackImage forState:UIControlStateNormal];
//    [button setBackgroundImage:seleImage forState:UIControlStateSelected];
    
    
    return button;
}
@end
