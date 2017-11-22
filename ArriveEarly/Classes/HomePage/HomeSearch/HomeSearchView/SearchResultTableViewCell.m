//
//  SearchResultTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/25.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

-(void)setModel:(ProductModel *)model
{
    NSString*str  = [[NSString alloc]init];
    for (lableKvModel *m in model.lableKvs) {
        NSDictionary *dic = [m yy_modelToJSONObject];
        str = [str stringByAppendingString:dic[@"value"]];
    }
    if([str isEqualToString:@""]){
        self.tagLabel.text = [NSString stringWithFormat:@"口感 无"];
    }else{
        self.tagLabel.text = [NSString stringWithFormat:@"口感 %@",str];
    }
    self.saleCount.text = [NSString stringWithFormat:@"销量 %ld",model.saleCount];
    self.productName.text = model.productName;
    self.price.text = MoneySymbol(model.newPrice);
    self.decLabel.text = model.productMDesc;
    
     [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.mainCoverImageUrl?model.mainCoverImageUrl:@"" imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg1"]];
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
