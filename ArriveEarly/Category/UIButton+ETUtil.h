//
//  UIButton+ETUtil.h
//  EasyDriver
//
//  Created by chenxianwu on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ETUtil)

+(UIButton *) createButtonWithCGRect:(CGRect) frame title:(NSString *) title titleColor:(UIColor *) titleColor titleFont:(UIFont *) titleFont image:(UIImage *) image normalBackImage:(UIImage *) NorBackImage selectedImage:(UIImage *) seleImage;
@end
