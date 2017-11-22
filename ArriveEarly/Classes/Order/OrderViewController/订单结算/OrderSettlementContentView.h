//
//  OrderSettlementContentView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单结算view
 */
@interface OrderSettlementContentView : UIView

@property (nonatomic, weak) UIViewController *superVC;

+ (instancetype)loadXIB;

@property (nonatomic, strong) NSArray *payments;

- (void)configWith:(OrderMessageModelInfo *)info;

- (void)_viewDidAppear:(BOOL)animated;



@end
