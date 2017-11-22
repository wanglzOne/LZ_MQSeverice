//
//  EvaluateStartChooseTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateStartChooseView.h"
@interface EvaluateStartChooseTableViewCell : UITableViewCell


+ (instancetype)loadCellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) EvaluateStartChooseView *starView;




@property (nonatomic, strong) OrderMessageProductInfo *oProductInfo;

@property (nonatomic, assign) int star;

@property (nonatomic, copy) CommonObjectBlock clickStarBlock;

@end
