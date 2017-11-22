//
//  EvaluateImageViewTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PicturesChooseView.h"

@interface EvaluateImageViewTableViewCell : UITableViewCell 
+ (instancetype)loadCellForTableView:(UITableView *)tableView;
@property (nonatomic, strong) PicturesChooseView *picView;
@property (nonatomic, weak) UIViewController *superVC;


@end
