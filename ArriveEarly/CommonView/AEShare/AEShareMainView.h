//
//  AEShareMainView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareConfig.h"
//typedef NS_ENUM(NSInteger, PaymentMenu) {
//    PaymentMenu_Online = 1, // 微信、支付宝支付
//    PaymentMenu_waiteGoods = 2, // 货到付款
//};

typedef NS_ENUM(NSInteger, AEShareType) {
    
    AEShareTypePaySuccess = 1, //支付成功
    
    AEShareTypeOrderDetail = 2, //订单详情跟踪
    
    AEShareTypePersonal = 3, //个人中心
};

@interface AEShareMainView : UIView

+ (instancetype)showShareViewWith:(AEShareType)type;










@end
