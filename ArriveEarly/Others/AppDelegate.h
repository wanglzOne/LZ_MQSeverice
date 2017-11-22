//
//  AppDelegate.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/18.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
//cn.com.easytaxi.driver.travel
//com.et.zaodiandao  rgh52L6LSvigGprx6vymdX7fAvOh8qkz

//com.NetworkFlow  -->>//81X8rdYxmSZyeWwWMb1AMbsUEAPg93zb
//GgtDcYy6aB10ih7khjaGAzblaPpwPDmW
#import "PushMessageManager.h"
#import "LaunchIntroductionView.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy, nonatomic) NSString *g_deviceToken;
@property (nonatomic, strong) PushMessageManager *pushManager;
@property (nonatomic, weak) LaunchIntroductionView *launchIntroductionView;
@end

