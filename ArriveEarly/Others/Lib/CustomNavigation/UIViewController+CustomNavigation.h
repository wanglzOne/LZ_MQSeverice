//
//  UIViewController+CustomNavigation.h
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/5/4.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavigationView.h"




@interface UIViewController (CustomNavigation)
// addCustomNavigationWithTitle  会创建这个View
@property (nonatomic, strong) CustomNavigationView *cusNavView;

- (CustomNavigationView *)addCustomNavigationWithTitle:(NSString *)title;
- (CustomNavigationView *)addCustomNavigationWithTitle:(NSString *)title withBackButtonBlock:(CusNavButtonTouch_BackButton)backButtonBlock;

- (void)addCustomNavigationRightButtonWithTitle:(NSString *)title image:(UIImage *)image seletor:(SEL)seletor;


- (void)setCusNavHide;

/**
 *  只是申明了  set  方法  导航栏的 固定 高度   CustomNavigationView_Height 64.0
 */
@property (nonatomic, assign, readonly) float customNavigationView_Height;


@end
