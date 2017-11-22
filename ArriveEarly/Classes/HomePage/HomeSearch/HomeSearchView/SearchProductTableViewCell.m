//
//  SearchProductTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "SearchProductTableViewCell.h"

@implementation SearchProductTableViewCell

-(void)setModel:(ProductModel *)model
{
    self.productName.text = model.productName;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
