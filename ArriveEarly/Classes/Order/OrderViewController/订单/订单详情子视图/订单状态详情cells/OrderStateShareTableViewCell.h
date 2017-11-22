//
//  OrderStateShareTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateShareTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lineImage1;
@property (weak, nonatomic) IBOutlet UIImageView *pointImage;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage2;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UILabel *label_time;

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

@end
