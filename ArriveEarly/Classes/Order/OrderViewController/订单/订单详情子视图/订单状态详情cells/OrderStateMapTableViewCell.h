//
//  OrderStateMapTableViewCell.h
//  ArriveEarly
//
//  Created by 黎恩宏 on 17/3/12.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateMapTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lineImage1;
@property (weak, nonatomic) IBOutlet UIImageView *pointImage;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage2;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_desc;
@property (weak, nonatomic) IBOutlet UIButton *btn_phone;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end
