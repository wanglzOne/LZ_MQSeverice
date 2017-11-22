//
//  GoodsTableViewCell.m
//  早点到APP
//
//  Created by m on 16/9/27.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lineHeight setConstant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
