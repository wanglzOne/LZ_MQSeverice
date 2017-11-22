//
//  AreaStoreInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/17.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, AreaStoreState) {
    AreaStoreState_invalid = 0, // 不可用
    AreaStoreState_available = 1, // 可用的
};

///区域商店信息
@interface AreaStoreInfo : NSObject

@property (nonatomic, assign) int isOpen;


@property (nonatomic, copy) NSString *areaId;
///"104.060395#30.594176"
@property (nonatomic, copy) NSString *areaLocations;

@property (nonatomic, copy) NSString *areaName;
///门店状态 
@property (nonatomic, assign) NSInteger areaState;
///门店配送费
@property (nonatomic, assign) CGFloat dispatchPrice;
/// 门店结束营业时间
@property (nonatomic, assign) long long endTime;
@property (nonatomic, assign) long long startTime;
//起送价格
@property (nonatomic, assign) CGFloat startPrice;
///配送范围 区域范围103.963162#30.786408,103.914869#30.741723,103.989608#30.581679,104.148285#30.572724,104.309261#30.623455,104.256369#30.817179,104.094243#30.832064,104.082744#30.827103
@property (nonatomic, copy) NSString *areaScope;


///解析字段 areaLocations
@property (nonatomic, assign) CLLocationCoordinate2D coord;
///解析字段 areaLocations
@property (nonatomic, strong) NSArray *areaScopes;
///  解析103.963162#30.786408 拿到经纬度
+ (CLLocationCoordinate2D)getCLLocationCoordinate2DforAreaScopeObjet:(NSString *)lng_latString;

///区域 @property (nonatomic, copy) NSString *areaEmpBelongs;
@property (nonatomic, copy) NSString *scopePointEnd;
@property (nonatomic, copy) NSString *scopePointStart;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *scopeState;

@end
