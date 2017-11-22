//
//  OrderStateTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderStateTableViewCell.h"

@implementation OrderStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.grayLineHeight setConstant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
