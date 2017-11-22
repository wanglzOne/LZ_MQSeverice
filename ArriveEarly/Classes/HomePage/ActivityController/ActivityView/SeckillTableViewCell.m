//
//  SeckillTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "SeckillTableViewCell.h"
#import "ProductModel.h"
@implementation SeckillTableViewCell

+(instancetype)creatCell:(UITableView *)tableView
{
    static NSString *identifer = @"cell";
    SeckillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SeckillTableViewCell class]) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ProductModel *)model
{
    _model = model;
    [self.foodImage sd_setImageWithURL:[NSURL URLWithString:[(model.mainCoverImageUrl?model.mainCoverImageUrl:@"") imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg1"]];
    self.productName.text = model.productName;
    self.price.text = MoneySymbol(model.activityPrice);
     self.originalPrice.text = MoneySymbol(model.price);
//    if ([model.productDesc isKindOfClass:[NSString class]]) {
//        self.descLabel.text = model.productDesc;
//    }
    if ([model.productMDesc isKindOfClass:[NSString class]]) {
        self.descLabel.text = model.productMDesc;
    }else
    {
        self.descLabel.text = @"暂无描述。";
    }
    if (model.shopCount) {
        self.count = model.shopCount;
    }
    else{
        self.count = 0;
    }
    self.addCount.text = [NSString stringWithFormat:@"%d",self.count];
    
    
    NSString *ddd = @"";
    if (model.lableKvs.count) {
        lableKvModel *lModel = model.lableKvs[0];
        if ([lModel.value isKindOfClass:[NSString class]]) {
            ddd = [NSString stringWithFormat:@"口味    %@ ",lModel.value];
        }
    }
    //self.labelWEIDAO.text = [NSString stringWithFormat:@"%@销量 %ld",ddd,(long)model.saleCount];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
