//
//  MyAddressTableViewCell.h
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Adress_Info.h"

@interface MyAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_address;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_phoneNumber;

@property (weak, nonatomic) IBOutlet UIView *edit_view;
@property (weak, nonatomic) IBOutlet UIButton *edit_delete;
@property (weak, nonatomic) IBOutlet UIButton *edit_change;

@property (assign, nonatomic) BOOL edite;


@property (strong, nonatomic) Adress_Info *addressInfo;



@end
