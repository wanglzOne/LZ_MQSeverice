//
//  CouponsTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "CouponsTableViewCell.h"

@implementation CouponsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setInfo:(RedPacketsInfo *)info
{
    _info = info;
    
    self.labe_money.text = Money(info.rbValue);
    self.labe_name.text = info.rbName;
    self.label_desc.text = [NSString stringWithFormat:@"· 满%@可用",Money(info.rbLimitValue)];
    self.label_tomeOut.text = [NSDate getTimeToLocaDatewith:@"· 有效期至 yyyy-MM-dd" with:info.rbEffEnd/1000];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
