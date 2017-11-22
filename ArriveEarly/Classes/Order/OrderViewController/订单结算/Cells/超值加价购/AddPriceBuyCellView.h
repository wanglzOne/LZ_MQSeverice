//
//  AddPriceBuyCellView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPriceBuyCellView : UIView
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *label_productCount;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_price;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) AddPricetoBuyInfo *addPricetoBuyInfo;

@end
