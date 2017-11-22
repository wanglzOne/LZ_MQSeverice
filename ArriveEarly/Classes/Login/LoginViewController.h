//
//  LoginViewController.h
//  ArriveEarly
//
//  Created by m on 2016/11/4.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ArriveEarlyManager.h"

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginCommitParameter:(NSDictionary *)parameters forTargetView:(UIView *)targetView;

@end

@interface LoginViewController : UIViewController

+ (instancetype)changeFromeVC:(UIViewController *)fromeVC onCompleteSuccessBlock:(LoginSuccessBlock)block;
@property (nonatomic, assign) BOOL isDismiss;
@end
