//
//  ArriveEaryDefaultConfigManager.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "BaseManger.h"

#import "ActivityConfigModel.h"

typedef void(^ArriveEaryConfigCompletion)(NSDictionary * result, NSError * err);


typedef NS_ENUM(NSInteger, SecondsKillActivityState) {
    SecondsKillActivityState_NO = 0, // 没有活动
    SecondsKillActivityState_NOStart = 1, // 有活动 活动没有开始  距离活动开始
    SecondsKillActivityState_AlreadyStart = 2, // 有活动 活动已经开始  距离活动结束
    SecondsKillActivityState_End = 3, // 没有活动
    
};


@interface ArriveEaryDefaultConfigManager : BaseManger

+ (instancetype)shared;
@property (nonatomic, strong) NSMutableArray <ActivityConfigModel *>*baseActivityDataAry;

@property (nonatomic, strong) ActivityConfigModel *secondsKillEveryDayConfigModel;

@property (nonatomic, assign) SecondsKillActivityState  activityState;

///获取活动配置信息
- (void)getActivityConfigWithAreaId:(NSString *)areaId completion:(ArriveEaryConfigCompletion)block;


- (void)refreshSecondsKillConfigMessageWithOncompletion:(ArriveEaryConfigCompletion)block;



@end
