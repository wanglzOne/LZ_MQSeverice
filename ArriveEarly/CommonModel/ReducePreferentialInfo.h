//
//  ReducePreferentialInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/17.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 responseData =     (
 {
 whenContent = aaa;
 whenEffEnd = 1479299515000;
 whenEffStart = 1479299512000;
 whenGenTime = "<null>";
 whenGenerator = "<null>";
 whenId = "<null>";
 whenLimitValue = "<null>";
 whenName = "\U6ee1100\U51cf10";
 whenState = 0;
 whenValue = "10.00";
 }
 );
 */

///满减优惠
@interface ReducePreferentialInfo : NSObject

@property (nonatomic, copy)  NSString *whenContent;
@property (nonatomic, copy)  NSString *whenName;
///条件价格
@property (nonatomic, assign)  CGFloat whenLimitValue;
/// - 多少钱
@property (nonatomic, assign)  CGFloat whenValue;
///  是否可用
@property (nonatomic, copy)  NSString *whenState;

@property (nonatomic, copy)  NSString *whenId;







///  创建者 时间
@property (nonatomic, copy)  NSString *whenGenTime;
@property (nonatomic, copy)  NSString *whenGenerator;

/// 结束开始时间
@property (nonatomic, copy)  NSString *whenEffEnd;
@property (nonatomic, copy)  NSString *whenEffStart;


@end
