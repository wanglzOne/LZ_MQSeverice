//
//  AEAllFoodTypeTableViewCell.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel,AEAllFoodTypeTableViewCell;
@protocol AEAllFoodTypeTableViewCellDelegate <NSObject>

-(void)clickPlusBtn:(AEAllFoodTypeTableViewCell*)cell;
-(void)clickMinusBtn:(AEAllFoodTypeTableViewCell*)cell;

@end

@interface AEAllFoodTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *productName;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *composeName;//组合名
@property (weak, nonatomic) IBOutlet UILabel *taste;//口味
@property (weak, nonatomic) IBOutlet UILabel *saleCount;//出售数量
@property (weak, nonatomic) IBOutlet UILabel *price;//售价
@property (weak, nonatomic) IBOutlet UIButton *minus;
@property (weak, nonatomic) IBOutlet UIButton *plus;
@property (weak, nonatomic) IBOutlet UILabel *addCount;

@property(nonatomic ,assign)NSInteger index;
@property(nonatomic ,strong)ProductModel* model;

@property (assign, nonatomic) NSInteger foodId;
@property (assign, nonatomic) int count;

@property (assign, nonatomic) id<AEAllFoodTypeTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *productLbeldesc;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_manjian;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_new;

@property (weak, nonatomic) IBOutlet UILabel *label_manjian;
@property (weak, nonatomic) IBOutlet UILabel *label_newProduct;

@property (weak, nonatomic) IBOutlet UIView *manjian_View;
@property (weak, nonatomic) IBOutlet UIView *xin_View;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xinViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manjianViewHeight;



@end
