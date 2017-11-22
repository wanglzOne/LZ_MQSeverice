//
//  AEHomeTableViewCell.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEHomeTableViewCell.h"
#import "ProductModel.h"
@interface AEHomeTableViewCell ()

@end
@implementation AEHomeTableViewCell

-(void)setModel:(ProductModel *)model
{
    self.productName.text = model.productName;
    self.price.text = MoneySymbol(model.price);
    self.descLable.text = model.productMDesc;
    self.MonthSaleLabel.text = [NSString stringWithFormat:@"销量 %ld",model.saleCount] ;
    self.EvaLabel.text = [NSString stringWithFormat:@"好评 %ld",model.goodEvaCount];
    
    if ([model.mainCoverImageUrl isKindOfClass:[NSString class]]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.mainCoverImageUrl imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg2"]];
    }else
    {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:[model.productClass.imgUrl imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg2"]];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * ID =@"CELL";
    AEHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AEHomeTableViewCell class]) owner:nil options:nil] firstObject];
    }
    return cell;

}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背景或者选中背景
    }
    return  self;
}
@end
