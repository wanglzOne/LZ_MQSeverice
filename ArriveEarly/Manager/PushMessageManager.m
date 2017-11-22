//
//  PushMessageManager.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/28.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PushMessageManager.h"
#import <UserNotifications/UserNotifications.h>
#import "DetailsOrderViewController.h"

@interface PushMessageManager () <UNUserNotificationCenterDelegate>

@end

@implementation PushMessageManager
#pragma mark Config
- (void)configUmengPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:KEY_Umeng launchOptions:launchOptions httpsenable:NO ];
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
            
            
        }
    }];
    [UMessage setLogEnabled:YES];
}
+ (void)customConfigPushMessage:(NSString *)deviceToken
{
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"updateRegs" url_ex] params:@{@"regId":ArriveEarlyManager.deviceToken,@"deviceId" : ArriveEarlyManager.deviceToken, @"pushUniqueId" : @"111",@"appType" : @(2) } onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@",error.domain);
        }
    }];
    
    
    [UMessage addTag:@"MQ-USER" response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@",error.domain);
        }
    }];
    
}

#pragma mark ReceiveRemoteNotification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self dealWithPushReceiveRemoteNotification:userInfo];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}




#pragma mark UNUserNotificationCenterDelegate 通知代理 iOS10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self dealWithPushReceiveRemoteNotification:userInfo];
        
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
///在后台 点击通知 调用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self dealWithPushReceiveRemoteNotification:userInfo];
        
        //应用处于后台时的远程推送接受
        //必须加这句代码
        
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}










- (void)dealWithPushReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //CUSTOM_PARAMETERS
    /* extra:
     pushContent
     pushOrderId = 840;
     pushTag = 0;
     pushType = 1
     */
    if (userInfo) {
        if ([userInfo[@"extra"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = userInfo[@"extra"];
            if (dict[@"pushType"] && dict[@"pushType"] != (id)kCFNull && dict[@"pushContent"] && dict[@"pushContent"] != (id)kCFNull) {
                [self dealWith: [dict[@"pushType"] intValue] andContent:userInfo];
            }
        }
        else
        {
            //
            if ([userInfo[@"aps"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *aps = userInfo[@"aps"];
                if ([aps[@"alert"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *alert = aps[@"alert"];
                    NSString *title = nil;
                    if ([alert[@"title"] isKindOfClass:[NSString class]]) {
                        title = [alert[@"title"] copy];
                    }
                    
                    NSString *body = nil;
                    if ([alert[@"subtitle"] isKindOfClass:[NSString class]]) {
                        body = alert[@"subtitle"];
                    }
                    if ([alert[@"body"] isKindOfClass:[NSString class]]) {
                        body = [NSString stringWithFormat:@"%@\n%@",body,alert[@"body"]];
                    }
                    if (body || title) {
                        [[[UIAlertView alloc] initWithTitle:title message:body delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    }
                }
                
                if ([aps[@"alert"] isKindOfClass:[NSString class]]) {
                    [[[UIAlertView alloc] initWithTitle:@"提示信息" message:aps[@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                }
                
                
            }
        }
        
        
    }
}
///处理 自定义 消息
- (void)dealWith:(PushCustomType)pushType andContent:(NSDictionary *)userInfo
{
    NSDictionary *contentDict = userInfo[@"extra"];;
    switch (pushType) {
        case PushCustomTypeNormal:
            if ([contentDict[@"pushContent"] isKindOfClass:[NSString class]]) {
                DLog(@"文本--->> %@",contentDict[@"pushContent"]);
                [[[UIAlertView alloc] initWithTitle:@"消息提示" message:contentDict[@"pushContent"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
            break;
        case PushCustomTypeUrl:
            if ([contentDict[@"pushContent"] isKindOfClass:[NSString class]]) {
                NSString *urlstr = contentDict[@"pushContent"];
                
                NormalWebPageViewController *vc = [[NormalWebPageViewController alloc] initWithNibName:@"NormalWebPageViewController" bundle:nil];
                vc.url = urlstr;
                NSString *title = @"推送消息";
                if ([userInfo[@"aps"] isKindOfClass:[NSDictionary class]]) {
                    if ([userInfo[@"aps"][@"alert"] isKindOfClass:[NSString class]]) {
                        title = userInfo[@"aps"][@"alert"];
                    }
                }
                vc.cusTitle = title;
                if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
                    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:vc animated:YES];
                }
                //NormalWebPageViewController *vcc = [NormalWebPageViewController changefromeVC:[UIApplication sharedApplication].keyWindow.rootViewController andTitle:@"tuisong" andLoadUrl:urlstr];
                //if ([contentDict[@"pushContent"] hasPrefix:@"http"])
            }
            break;
        case PushCustomTypeOrderSteteUpdate:
        {
            NSString *orderID = [NSString stringWithFormat:@"%d",[contentDict[@"pushContent"] intValue]];
            OrderStatus orderState = OrderStatus_waitePay;
            if (contentDict[@"pushStatus"] != (id)kCFNull) {
                orderState = [contentDict[@"pushStatus"] intValue];
            }
            if (orderState != OrderStatus_waitePay) {
                if ([contentDict[@"pushMsg"] isKindOfClass:[NSString class]]) {
                    DLog(@"--->> 订单有更新");
                    
                    DetailsOrderViewController *detailVC = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
                    detailVC.orderID = orderID;
                    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
                        [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:detailVC animated:YES];
                    }

                    
                    //[[[UIAlertView alloc] initWithTitle:@"订单有更新" message:contentDict[@"pushMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                    
                    
                    
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
