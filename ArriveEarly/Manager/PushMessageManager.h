//
//  PushMessageManager.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/28.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "BaseManger.h"
#import "UMessage.h"

typedef NS_ENUM(NSInteger, PushCustomType) {
    PushCustomTypeNormal = 0, // 普通文本
    PushCustomTypeUrl = 1, // Url
    PushCustomTypeOrderSteteUpdate = 2, 订单状态改变
};


/**
 推送管理   页面跳转  提示
 */
@interface PushMessageManager : BaseManger

- (void)configUmengPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (void)customConfigPushMessage:(NSString *)deviceToken;


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end
