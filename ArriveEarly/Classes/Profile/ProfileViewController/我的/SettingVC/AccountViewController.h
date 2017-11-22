//
//  AccountViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTitleLeftViewController.h"
#import "BaseSettingViewController.h"

typedef void (^LogoutSuccessBlock)(void);



/**
 账号信息
 */
@interface AccountViewController : BaseSettingViewController
+ (instancetype)changeFromeVC:(UIViewController *)fromeVC onCompleteSuccessBlock:(LogoutSuccessBlock)block;
@end
