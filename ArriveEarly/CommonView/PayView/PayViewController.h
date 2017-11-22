//
//  PayViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSettingViewController.h"

#import "OrderMessageModelInfo.h"

typedef NS_ENUM(NSInteger, PayModeIdMenu) {
    
    PayModeIdMenu_ZHIFUBAO = 1, // 支付宝
    PayModeIdMenu_YINLIAN = 4, // 银联
    
    PayModeIdMenu_WCHAT = 2, // 微信
    PayModeIdMenu_waiteGoods = 3, // 货到付款
};

//0-未支付 1-支付宝、2-银联、3-微信支付

@interface PayViewController : BaseSettingViewController
///ChangeSuccessBlock 支付成功的回调 一定是支付成功的回调
+ (instancetype)changefromeVC:(UIViewController *)superVC andOrderInfo:(OrderMessageModelInfo *)order onComplete:(ChangeSuccessBlock)block;

@end
