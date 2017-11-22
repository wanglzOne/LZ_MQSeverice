//
//  AEHomeTableViewCell.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface AEHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *descLable;
@property (weak, nonatomic) IBOutlet UILabel *MonthSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *EvaLabel;

@property (nonatomic ,strong)ProductModel*model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
