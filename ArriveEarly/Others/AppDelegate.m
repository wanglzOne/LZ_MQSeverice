//
//  AppDelegate.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/18.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LocationManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "PushMessageManager.h"
#import "WXApi.h"

#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/ASIdentifierManager.h>
//http://www.jianshu.com/p/f08891ccb218
#import "LaunchIntroductionView.h"

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.pushManager = [[PushMessageManager alloc] init];
    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    [manager removeLocationData];
    
    self.g_deviceToken  = @"";
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    RootViewController *MineVC = [[RootViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:MineVC];
    navi.navigationBarHidden = YES;
    navi.hidesBottomBarWhenPushed = YES;
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    
    BOOL ret = [_mapManager start:kBaiduMapKey  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [[LocationManager sharedManager] startLocateAndGeoCurrentCityLocationWithSuccess:nil failure:nil];
    
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:KEY_Umeng];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx8482dcf69d4ffc0c" appSecret:@"e6ab86492f430148a4c13a5684e62dcc" redirectURL:@"http://mobile.umeng.com/social"];
    //设置QQ的appKey和appSecret
    //   1105853034 -> 1105911261  6ehQcGdGdfZkfltP -> gfe2wt9iErH6KGYG
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105911261" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    [WXApi registerApp:@"wx8482dcf69d4ffc0c"];
    
    /*** Umeng推送 *****/
    [self.pushManager configUmengPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //[LaunchIntroductionView sharedWithImages:@[@"launch1.jpg",@"launch0.jpg"]];

    self.launchIntroductionView = [LaunchIntroductionView sharedWithImages:@[@"welcome1.png",@"welcome2.png"] buttonImage:nil buttonFrame:CGRectMake(KHEIGHT_6(100.0), UIScreenHeight-200/2, UIScreenWidth - 2*KHEIGHT_6(100.0), KHEIGHT_6(130.0))];
    
    return YES;
}
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"%@ %d",(iError==0?@"联网成功 ":@"onGetNetworkState "),iError);
}

- (void)onGetPermissionState:(int)iError
{
    NSLog(@"%@ %d",(iError==0?@"授权成功":@"onGetPermissionState "),iError);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//退到后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backActivity" object:nil];
    });
}



//进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"comeActivity" object:nil];
    });
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *device_Token = [token substringWithRange:NSMakeRange(1, token.length - 2)];
    device_Token = [device_Token stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.g_deviceToken = device_Token;
    if (!self.g_deviceToken) {
        self.g_deviceToken = @"";
    }
    NSLog(@"device_Token========================================================%@",self.g_deviceToken);
    [PushMessageManager customConfigPushMessage:self.g_deviceToken];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) { // 支付宝快捷支付
            
            //跳转支付宝钱包进行支付，处理支付结果  处理客户端方法
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
             {
                 NSLog(@"支付宝result = %@",resultDic);
                 //发送通知
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResultTheCallback" object:resultDic];
             }];
        }
        if ([sourceApplication isEqualToString:@"com.tencent.xin"])
        {
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
 
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    //BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL result = NO;
    if (!result) {
        
        
        
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResultTheCallback" object:resultDic];
            }];
            /*
             // 授权跳转支付宝钱包进行支付，处理支付结果
             [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@",resultDic);
             // 解析 auth code
             NSString *result = resultDic[@"result"];
             NSString *authCode = nil;
             if (result.length>0) {
             NSArray *resultArr = [result componentsSeparatedByString:@"&"];
             for (NSString *subResult in resultArr) {
             if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
             authCode = [subResult substringFromIndex:10];
             break;
             }
             }
             }
             NSLog(@"授权结果 authCode = %@", authCode?:@"");
             }];
             */
        }//com.tencent.mqq
        if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
            [WXApi handleOpenURL:url delegate:self];
        }
        return YES;
    }
    
    
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
    
    
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
//    WXSuccess           = 0,    /**< 成功    */
//    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//    WXErrCodeSentFail   = -3,   /**< 发送失败    */
//    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResultTheCallback" object:resp];
}

#pragma mark - app出于前台，收到通知
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self.pushManager  application:application didReceiveRemoteNotification:userInfo];
}

//willPresentNotification:withCompletionHandler


void uncaughtExceptionHandler(NSException*exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    // Internal error reporting
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"NMBD");
    
}


@end
