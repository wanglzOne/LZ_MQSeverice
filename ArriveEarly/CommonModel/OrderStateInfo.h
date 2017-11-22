//
//  OrderStateInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/21.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderStateInfo : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) int orderState;
@property (nonatomic, copy) NSString *orderDescription;

@property (nonatomic, copy) NSString *cus_orderDescription;

@property (nonatomic, assign) long long updateTime;


@property (nonatomic, assign) BOOL isShare;



@end
