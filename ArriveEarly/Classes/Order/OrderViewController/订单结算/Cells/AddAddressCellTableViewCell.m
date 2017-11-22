//
//  AddAddressCellTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AddAddressCellTableViewCell.h"


@implementation AddAddressCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label_phoneNumber.textColor = [UIColor grayColor];
    
    
    [self.lineHeight setConstant:0.5];
    self.lineView.backgroundColor = HWColor(230, 230, 230);
}

- (void)setChooseAddressInfo:(Adress_Info *)chooseAddressInfo
{
    _chooseAddressInfo = chooseAddressInfo;
    if (!_chooseAddressInfo) {
        self.label_address.text = @"";
        self.label_phoneNumber.text = @"";
        [self.chooseAddressButton setTitle:@"    选择收货地址" forState:UIControlStateNormal];
        [self.chooseAddressButton setImage:[UIImage imageNamed:@"addAddress"] forState:UIControlStateNormal];
    }
    else
    {
        if ([self.chooseAddressInfo.addressDetail isKindOfClass:[NSString class]]) {
            self.label_address.text = [NSString stringWithFormat:@"%@ - %@",self.chooseAddressInfo.addressDetail,self.chooseAddressInfo.address];
        }else
        {
            self.label_address.text = [NSString stringWithFormat:@"%@",self.chooseAddressInfo.address];
        }
        self.label_phoneNumber.text = [NSString stringWithFormat:@"%@   %@",self.chooseAddressInfo.contactName,self.chooseAddressInfo.contactPhone];
        [self.chooseAddressButton setTitle:@"             " forState:UIControlStateNormal];
        [self.chooseAddressButton setImage:nil forState:UIControlStateNormal];
    }
    
}
- (IBAction)chooseAddressAction:(id)sender {
    MyAddressViewController *vc = [[MyAddressViewController alloc]init];
    vc.showType = AddressShowTypeChoose;
    [self.superVC.navigationController pushViewController:vc animated:YES];
    WEAK(weakSelf);
    [vc setChooiceAddressOnCompleteBlock:^(NSArray<Adress_Info *> *adresss) {
        weakSelf.adressBlock(adresss);
    }];
}
- (void)setChooiceAddressOnCompleteBlock:(ChooseAddressBlock)block
{
    self.adressBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
