//
//  OrderSettlementViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"


typedef void(^OrderSettlementSuccessBlock)(OrderMessageModelInfo *orderMessageInfo);

/**
 订单结算
 */
@interface OrderSettlementViewController : BaseSettingViewController
+ (instancetype)changeFormeViewController:(UIViewController *)fromeVC order:(OrderMessageModelInfo *)orderInfo onCompleteBlock:(OrderSettlementSuccessBlock)block;
///有起送价的判断。  未达到起送价不允许配送
+ (instancetype)changeFormeViewController:(UIViewController *)fromeVC onCompleteBlock:(OrderSettlementSuccessBlock)block;
@end
