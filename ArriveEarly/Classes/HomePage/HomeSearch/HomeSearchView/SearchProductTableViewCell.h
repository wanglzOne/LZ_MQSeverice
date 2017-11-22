//
//  SearchProductTableViewCell.h
//  ArriveEarly
//
//  Created by m on 2016/11/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface SearchProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (nonatomic ,strong)ProductModel *model;
@end
