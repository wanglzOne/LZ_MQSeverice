//
//  OtherActivityTableViewCell.h
//  ArriveEarly
//
//  Created by m on 2016/11/12.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface OtherActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;

@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UILabel *addCount;
@property(nonatomic ,assign) int count;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic ,strong) ProductModel *model;

+(instancetype)creatCell:(UITableView*)tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelWEIDAO;
@property (weak, nonatomic) IBOutlet UILabel *originalPrice;
@property (weak, nonatomic) IBOutlet UIView *originalView;

@end
