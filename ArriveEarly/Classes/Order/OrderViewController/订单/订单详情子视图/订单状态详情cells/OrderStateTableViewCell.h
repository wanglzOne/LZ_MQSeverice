//
//  OrderStateTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineImage1;
@property (weak, nonatomic) IBOutlet UIImageView *pointImage;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage2;
@property (weak, nonatomic) IBOutlet UIView *grayLineView;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UILabel *label_desc;
@property (weak, nonatomic) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grayLineHeight;

@end
