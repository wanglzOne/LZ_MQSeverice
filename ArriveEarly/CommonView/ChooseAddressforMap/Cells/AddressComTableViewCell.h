//
//  AddressComTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressComTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHieght;
@property (weak, nonatomic) IBOutlet UILabel *addressDesc;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
