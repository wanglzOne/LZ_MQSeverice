//
//  OrderMsgTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMsgTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHieght;

@end
