//
//  EvaluateChooseTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EvaluateChooseView.h"

@interface EvaluateChooseTableViewCell : UITableViewCell
+ (instancetype)loadCellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) EvaluateChooseView *starView;


@property (nonatomic, strong) NSString *titleCus;
@property (nonatomic, assign) int star;
@property (nonatomic, copy) CommonObjectBlock clickStarBlock;



@end
