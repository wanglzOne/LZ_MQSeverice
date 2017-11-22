//
//  OrderEvaluationTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTextViewInternal.h"
#import "OrderEvaluationViewController.h"

@interface OrderEvaluationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet HPTextViewInternal *textView;


@property (weak, nonatomic) id<OrderEvaluationViewCellDelegate> delegate;


@property (assign, nonatomic) int starIndex;

@end
