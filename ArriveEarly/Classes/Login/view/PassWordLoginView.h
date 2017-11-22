//
//  PassWordLoginView.h
//  ArriveEarly
//
//  Created by m on 2016/11/4.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "LoginViewController.h"

///验证码登录
@interface PassWordLoginView : UIView

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@property (nonatomic, weak) UIViewController *superViewController;

+(instancetype)initCustomView;

- (void)clearData;

@end
