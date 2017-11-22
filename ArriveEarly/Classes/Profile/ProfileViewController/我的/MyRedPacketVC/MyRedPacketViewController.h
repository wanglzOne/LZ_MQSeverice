//
//  MyRedPacketViewController.h
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTitleLeftViewController.h"
#import "BaseSettingViewController.h"

typedef NS_ENUM(NSInteger, RedPacketType) {
    
//    RedPacketType_Normal = 0, // 微信、支付宝支付
//    RedPacketType_TimeLimit = 1, //限时红包
//    RedPacketType_NewUser = 2,  //新手红包
    
    RedPacketType_Normal = 0, // 微信、支付宝支付
    RedPacketType_NewUser = 1,  //新手红包
    RedPacketType_Share = 2, //分享红包
};


typedef void(^RedPacketChooseBlock)(RedPacketsInfo *redPacketInfo);

/**
 我的红包 选择红包
 */
@interface MyRedPacketViewController : BaseSettingViewController

@property (nonatomic, assign) CGFloat limitPrice;

- (void)setChooiceRedPacketInfoOnCompleteBlock:(RedPacketChooseBlock)block;

@end
