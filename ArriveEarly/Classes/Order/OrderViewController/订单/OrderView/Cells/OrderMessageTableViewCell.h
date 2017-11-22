//
//  OrderMessageTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMessageModelInfo.h"


@protocol OrderMessageTableViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell clickTypeButton:(UIButton *)button;

@end

@interface OrderDishesView : UIView

@end

@interface OrderMessageTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModelData:(OrderMessageModelInfo *)orderMessageInfo;
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;



@property (nonatomic, strong) UIButton *typeButton;

@property (strong, nonatomic) UIButton *evaluationBtn;



@property (nonatomic, assign) id<OrderMessageTableViewCellDelegate>delegate;





@end
