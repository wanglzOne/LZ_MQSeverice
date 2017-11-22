//
//  OrderStateShareTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderStateShareTableViewCell.h"

@implementation OrderStateShareTableViewCell

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
