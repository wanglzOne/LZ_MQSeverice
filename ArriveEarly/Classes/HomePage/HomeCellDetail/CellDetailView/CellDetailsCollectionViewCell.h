//
//  CellDetailsCollectionViewCell.h
//  ArriveEarly
//
//  Created by m on 2016/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutomaticRollingView.h"


@class ProductModel,EvalutionModel;
@interface CellDetailsCollectionViewCell : UICollectionViewCell
@property(weak ,nonatomic)UIViewController *navi;

@property (nonatomic,strong)ProductModel *model;
@property (nonatomic,strong)EvalutionModel *evaModel;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;//口味，月售
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *valuation;//评价百分之几十
@property (weak, nonatomic) IBOutlet UIButton *numberValuation;//按钮评论
@property (weak, nonatomic) IBOutlet UIProgressView *valutionProgress;

@property (weak, nonatomic) IBOutlet UITextView *productInfo;//商品信息
@property (weak, nonatomic) IBOutlet UILabel *addCount;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *addShoppingBtn;
@property (weak, nonatomic) IBOutlet UIView *footView;


@property (nonatomic ,assign) BOOL isStart;//活动商品进入判断能否加入购物车

///收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@property (nonatomic, strong) AutomaticRollingView *rollimgView;

@property (weak, nonatomic) IBOutlet UIView *EvaView;//评价View
@property (weak, nonatomic) IBOutlet UITableView *EvaTableView;//评价列表



@property (weak, nonatomic) IBOutlet UIView *InfoView;//商品信息View

@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UIButton *Info_button;//商品信息按钮

@property (weak, nonatomic) IBOutlet UIButton *Eva_button;//评价按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeight;


@end
