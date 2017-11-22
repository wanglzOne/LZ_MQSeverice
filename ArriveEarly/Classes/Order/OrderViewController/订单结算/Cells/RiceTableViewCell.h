//
//  RiceTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/3.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UITextField *tf_content;
@property (weak, nonatomic) IBOutlet UIButton *clickButtton;
@property (weak, nonatomic) IBOutlet UIView *linew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;


@end
