//
//  ArriveEaryDefaultConfigManager.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ArriveEaryDefaultConfigManager.h"

@interface ArriveEaryDefaultConfigManager ()
///五大活动配置参数
@end

@implementation ArriveEaryDefaultConfigManager

+ (instancetype)shared {
    static id _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
- (SecondsKillActivityState)activityState
{
    SecondsKillActivityState state = SecondsKillActivityState_NO;
    if (!self.secondsKillEveryDayConfigModel || !self.secondsKillEveryDayConfigModel.activityEffStart || !self.secondsKillEveryDayConfigModel.activityEffEnd) {
        state = SecondsKillActivityState_NO;
    }
    else if(self.secondsKillEveryDayConfigModel.newDate < self.secondsKillEveryDayConfigModel.activityEffStart)
    {
        state = SecondsKillActivityState_NOStart;
    }else if(self.secondsKillEveryDayConfigModel.newDate >= self.secondsKillEveryDayConfigModel.activityEffStart && self.secondsKillEveryDayConfigModel.newDate < self.secondsKillEveryDayConfigModel.activityEffEnd)
    {
        state = SecondsKillActivityState_AlreadyStart;
    }else if (self.secondsKillEveryDayConfigModel.newDate >= self.secondsKillEveryDayConfigModel.activityEffEnd)
    {
        state = SecondsKillActivityState_End;
        //[self refreshSecondsKillConfigMessageWithOncompletion:nil];
    }
    return state;
}
- (void)getActivityConfigWithAreaId:(NSString *)areaId completion:(ArriveEaryConfigCompletion)block
{
    if (!areaId) {
        areaId = @"";
    }
    AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
    [net post:[@"activityConfig" url_ex] params:@{@"areaId" : areaId} progress:nil responseObject:^(id responseObject) {
        NSError *error = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"responseData"][@"object"] isKindOfClass:[NSArray class]]) {
                [self.baseActivityDataAry removeAllObjects];
                for (NSDictionary *objectDict in responseObject[@"responseData"][@"object"]) {
                    if ([objectDict isKindOfClass:[NSDictionary class]]) {
                        ActivityConfigModel *model = [ActivityConfigModel yy_modelWithDictionary:objectDict];
                        if (responseObject[@"responseData"][@"nowDate"] != (id)kCFNull) {
                            model.newDate = [responseObject[@"responseData"][@"nowDate"] longLongValue];
                        }
                        [self.baseActivityDataAry addObject:model];
                    }
                }
            }
            else
            {
                error = [NSError errorWithDomain:@"数据格式错误" code:-1 localizedDescription:nil];
            }
        }else
        {
            error = [NSError errorWithDomain:@"数据格式错误" code:-1 localizedDescription:nil];
        }
        BLOCK_EXIST(block,nil,error);
    } onError:^(NSError *error) {
        BLOCK_EXIST(block,nil,error);
    }];
}

- (void)refreshSecondsKillConfigMessageWithOncompletion:(ArriveEaryConfigCompletion)block{
    NSString *areaId = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaId = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }

    AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
    [net post:[@"findSeckill" url_ex] params:@{ @"areaId":areaId } progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]] && [responseObject[@"responseData"][@"object"] isKindOfClass:[NSDictionary class]]) {
                self.secondsKillEveryDayConfigModel = [ActivityConfigModel yy_modelWithDictionary:responseObject[@"responseData"][@"object"]];
                ///规定只能 购买1分 （所有的秒杀商品）
                self.secondsKillEveryDayConfigModel.maxBuyCount = 1;
                if (responseObject[@"responseData"][@"nowDate"] != (id)kCFNull) {
                    self.secondsKillEveryDayConfigModel.newDate = [responseObject[@"responseData"][@"nowDate"] longLongValue];
                }
                BLOCK_EXIST(block,responseObject,nil);
            }else
            {
                self.secondsKillEveryDayConfigModel = nil;
                BLOCK_EXIST(block,responseObject,[NSError errorWithDomain:@"暂无秒杀活动" code:2 localizedDescription:@""]);
            }
        }
    } onError:^(NSError *error) {
        BLOCK_EXIST(block,nil,error);
    }];
    
}


- (NSMutableArray <ActivityConfigModel *>*)baseActivityDataAry
{
    if (!_baseActivityDataAry) {
        _baseActivityDataAry = [[NSMutableArray alloc] init];
    }
    return _baseActivityDataAry;
}

@end
