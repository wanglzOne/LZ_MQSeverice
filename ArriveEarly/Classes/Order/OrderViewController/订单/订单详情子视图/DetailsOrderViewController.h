//
//  DetailsOrderViewController.h
//  早点到APP
//
//  Created by m on 16/9/21.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMessageModelInfo.h"
#import "BaseSettingViewController.h"

@protocol DetailsOrderViewPperationDelegate <NSObject>

- (void)settlementOrderforTargetView:(UIView *)targetView;
- (void)againOrderforTargetView:(UIView *)targetView;


@end

@interface DetailsOrderViewController : BaseSettingViewController
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@property (nonatomic, copy) NSString * orderID;
@end
