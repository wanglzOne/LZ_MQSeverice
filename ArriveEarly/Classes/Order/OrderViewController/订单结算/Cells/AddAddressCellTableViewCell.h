//
//  AddAddressCellTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyAddressViewController.h"


@interface AddAddressCellTableViewCell : UITableViewCell

@property (nonatomic, strong) Adress_Info *chooseAddressInfo;

@property (nonatomic, weak) UIViewController *superVC;

- (void)setChooiceAddressOnCompleteBlock:(ChooseAddressBlock)block;
@property(nonatomic,copy) ChooseAddressBlock adressBlock;

@property (weak, nonatomic) IBOutlet UIButton *chooseAddressButton;
@property (weak, nonatomic) IBOutlet UILabel *label_phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *label_address;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@end
