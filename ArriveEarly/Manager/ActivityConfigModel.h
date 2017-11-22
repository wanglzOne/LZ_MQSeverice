//
//  ActivityConfigModel.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageConfig : NSObject
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) int isCover;

@property (nonatomic, copy) NSString *activityId;


@end

@protocol ImageConfig;

@interface ActivityConfigModel : NSObject


/// 自定义字段  一个 活动 一个订单所限制的最大购买份数。   0表示 不限制
@property (nonatomic, assign) int maxBuyCount;



@property (nonatomic, copy) NSString *activityContent;
@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *activityName;

@property (nonatomic, strong) NSArray <ImageConfig>*listImage;

//
@property (nonatomic, strong) NSArray *listImage_isCover0;
@property (nonatomic, copy) NSString *mainUrl_isCover1;


@property (nonatomic, assign) NSInteger activityState;
@property (nonatomic, assign) NSInteger activityType;

@property (nonatomic, assign) long long activityEffEnd;
@property (nonatomic, assign) long long activityEffStart;
@property (nonatomic, assign) long long activityGenTime;

@property (nonatomic, assign) long long newDate;
////计算熟悉
@property (nonatomic, assign) long long countdownSeconds;


@end
