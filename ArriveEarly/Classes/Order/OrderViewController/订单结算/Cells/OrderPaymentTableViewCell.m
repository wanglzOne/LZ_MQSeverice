//
//  OrderPaymentTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderPaymentTableViewCell.h"

@implementation OrderPaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.lineHeight setConstant:0.5];
    self.lineView.backgroundColor = HWColor(230, 230, 230);
    
}


- (void)setChooicewith:(NSIndexPath *)path payMent:(PaymentBlock)block
{
    indexPath = path;
    self.block = block;
}

- (IBAction)chooseButtonAction:(id)sender {
    BLOCK_EXIST(self.block,[self.PaymentArray[indexPath.row-1] intValue]);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

@end
