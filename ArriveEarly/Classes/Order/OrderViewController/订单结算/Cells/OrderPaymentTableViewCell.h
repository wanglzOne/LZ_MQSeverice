//
//  OrderPaymentTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PayViewController.h"

typedef void(^PaymentBlock)(PayModeIdMenu payment);

@interface OrderPaymentTableViewCell : UITableViewCell
{
    NSIndexPath *indexPath;
}
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIButton *seleted_button;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (copy, nonatomic) PaymentBlock block;
@property (strong, nonatomic) NSArray *PaymentArray;

- (void)setChooicewith:(NSIndexPath *)path payMent:(PaymentBlock)block;

@end
