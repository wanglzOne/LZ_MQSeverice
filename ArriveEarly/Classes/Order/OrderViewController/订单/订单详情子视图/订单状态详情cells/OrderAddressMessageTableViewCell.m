//
//  OrderAddressMessageTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderAddressMessageTableViewCell.h"

@implementation OrderAddressMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lineViewHieght setConstant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
