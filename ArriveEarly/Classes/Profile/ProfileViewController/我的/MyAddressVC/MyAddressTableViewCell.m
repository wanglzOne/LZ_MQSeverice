//
//  MyAddressTableViewCell.m
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "MyAddressTableViewCell.h"

@implementation MyAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEdite:(BOOL)edite
{
    _edite = edite;
    self.edit_view.hidden = !edite;
}

- (void)setAddressInfo:(Adress_Info *)addressInfo
{
    _addressInfo = addressInfo;
    
    NSString *address = @"";
    if (addressInfo.addressDetail.length) {
        address = [NSString stringWithFormat:@"%@-%@",addressInfo.address,addressInfo.addressDetail];
    }else
    {
        address = addressInfo.address;
    }
    self.label_address.text = address;
    self.label_name.text = addressInfo.contactName;
    self.label_phoneNumber.text = addressInfo.contactPhone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
