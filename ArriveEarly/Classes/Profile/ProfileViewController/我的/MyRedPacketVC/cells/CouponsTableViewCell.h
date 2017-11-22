//
//  CouponsTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketsInfo.h"
@interface CouponsTableViewCell : UITableViewCell
@property (nonatomic, strong) RedPacketsInfo *info;
@property (weak, nonatomic) IBOutlet UILabel *label_money_unit;

@property (weak, nonatomic) IBOutlet UILabel *labe_money;

@property (weak, nonatomic) IBOutlet UILabel *label_tomeOut;
@property (weak, nonatomic) IBOutlet UILabel *labe_name;
@property (weak, nonatomic) IBOutlet UILabel *label_desc;

@end
