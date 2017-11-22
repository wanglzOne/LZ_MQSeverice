//
//  SeckillTableViewCell.h
//  ArriveEarly
//
//  Created by m on 2016/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface SeckillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;

@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UILabel *addCount;
@property(nonatomic ,assign) int count;

@property(nonatomic ,assign)BOOL isShow;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UILabel *btnLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic ,strong) ProductModel *model;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;

+(instancetype)creatCell:(UITableView*)tableView;
@end
