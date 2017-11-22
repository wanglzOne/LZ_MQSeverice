//
//  BasePopTableViewCell.h
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgConstraint;

@end
