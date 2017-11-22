//
//  RiceTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/3.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "RiceTableViewCell.h"

@implementation RiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.linew.backgroundColor = HWColor(230, 230, 230);
    [self.lineViewHeight setConstant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
