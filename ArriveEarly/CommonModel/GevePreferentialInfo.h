//
//  GevePreferentialInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/17.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 responseData =     (
 {
 whenGiveId = 1;
 whenGiveIsActived = 0;
 whenGiveName = aaa;
 whenGiveTrigger = 50;
 }
 );
 */


//满赠优惠
@interface GevePreferentialInfo : NSObject

@property (nonatomic, copy) NSString *whenGiveId;
///是否过期
@property (nonatomic, copy) NSString *whenGiveIsActived;
///
@property (nonatomic, copy) NSString *whenGiveName;

/// 满赠生效金额
@property (nonatomic, assign) CGFloat whenGiveTrigger;

@end
