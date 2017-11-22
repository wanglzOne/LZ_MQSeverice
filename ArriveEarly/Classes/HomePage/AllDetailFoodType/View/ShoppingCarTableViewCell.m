//
//  ShoppingCarTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"
#import "ProductModel.h"

@implementation ShoppingCarTableViewCell

-(void)setModel:(ProductModel *)model
{
    //数据。。。
    self.productName.text = model.productName;
    if (model.isActivity) {
        
        self.price.text = MoneySymbol(model.activityPrice);
        
    }else{
        
        self.price.text = MoneySymbol(model.price);
        
    }
    self.productCount.text = [NSString stringWithFormat:@"%d",model.shopCount];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
