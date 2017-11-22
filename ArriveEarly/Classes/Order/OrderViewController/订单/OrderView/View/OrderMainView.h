//
//  OrderMainView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderMainViewSate) {
    OrderMainViewSate_Normal = 0, // 微信、支付宝支付
    OrderMainViewSate_editing = 1, // 货到付款
};


@interface OrderMainView : UIView



+ (instancetype)loadNib;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, weak) UIViewController *superVC;
- (void)config;
- (void)refreshUI;
- (void)logOut;
- (void)reloadTableVviewForState:(OrderMainViewSate)state;
@end
