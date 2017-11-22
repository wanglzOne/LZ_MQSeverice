//
//  OtherActivityTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/12.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OtherActivityTableViewCell.h"
#import "ProductModel.h"

@implementation OtherActivityTableViewCell

+(instancetype)creatCell:(UITableView *)tableView
{
    static NSString *identifer = @"cell";
    OtherActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OtherActivityTableViewCell" owner:self options:nil].lastObject;
    }
    return cell;
}

-(void)setModel:(ProductModel *)model
{
    _model = model;
    
    [self.foodImage sd_setImageWithURL:[NSURL URLWithString:[model.mainCoverImageUrl?model.mainCoverImageUrl:@"" imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg1"]];
    
    self.productName.text = model.productName;
    self.price.text = MoneySymbol(model.activityPrice);
  
     self.originalPrice.text = MoneySymbol(model.price);

   

//    if ([model.productMDesc isKindOfClass:[NSString class]]) {
//        self.descLabel.text = model.productMDesc;
//    }else
//    {
//        self.descLabel.text = @"暂无描述。";
//    }
    self.descLabel.text = model.productMDesc;
    if (model.shopCount) {
        self.count = model.shopCount;
    }
    else{
        self.count = 0;
    }
    
    NSString *ddd = @"";
    if (model.lableKvs.count) {
        lableKvModel *lModel = model.lableKvs[0];
        if ([lModel.value isKindOfClass:[NSString class]]) {
            ddd = [NSString stringWithFormat:@"口感 %@ ",lModel.value];
        }
    }
    self.labelWEIDAO.text = [NSString stringWithFormat:@"%@销量 %ld",ddd,(long)model.saleCount];
    
    
    self.addCount.text = [NSString stringWithFormat:@"%d",self.count];
    

    //self.labelWEIDAO.text = model.showSaleand;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
