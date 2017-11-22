//
//  OrderEvaluationViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseSettingViewController.h"
#import "OrderMessageModelInfo.h"

@protocol OrderEvaluationViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell clickButttonWithStarIndex:(int)starIndex;

@end

@interface OrderEvaluationViewController : BaseSettingViewController
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@end
