//
//  PayMentShowTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PayMentShowTableViewCell.h"

@implementation PayMentShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lineHeight setConstant:0.5];
    self.linew.backgroundColor = HWColor(230, 230, 230);
    [self.payChooseButtton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
