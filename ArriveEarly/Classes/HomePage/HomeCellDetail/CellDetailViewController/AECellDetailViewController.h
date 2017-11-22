//
//  AECellDetailViewController.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/26.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface AECellDetailViewController : UIViewController

@property (nonatomic ,strong) ProductModel *model;

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;//口味，月售
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *valuation;//评价百分之几十
@property (weak, nonatomic) IBOutlet UIButton *numberValuation;
@property (weak, nonatomic) IBOutlet UIProgressView *valutionProgress;

@property (weak, nonatomic) IBOutlet UITextView *productInfo;//商品信息

@property (weak, nonatomic) IBOutlet UILabel *addCount;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property (nonatomic ,assign) BOOL isStart;//活动商品进入判断能否加入购物车

@end
