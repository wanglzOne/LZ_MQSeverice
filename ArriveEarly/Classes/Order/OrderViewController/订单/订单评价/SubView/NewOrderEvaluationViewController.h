//
//  NewOrderEvaluationViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

@protocol NewOrderEvaluationViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell clickButttonWithStarIndex:(int)starIndex;

@end

@interface NewOrderEvaluationViewController : BaseSettingViewController
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;

@end
