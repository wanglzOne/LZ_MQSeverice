//
//  PayMentShowTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMentShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_paymentShow;
@property (weak, nonatomic) IBOutlet UIButton *payChooseButtton;
@property (weak, nonatomic) IBOutlet UIView *linew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end
