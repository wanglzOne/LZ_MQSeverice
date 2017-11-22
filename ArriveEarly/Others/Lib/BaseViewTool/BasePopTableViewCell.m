//
//  BasePopTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "BasePopTableViewCell.h"

@implementation BasePopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lineViewHeight setConstant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
