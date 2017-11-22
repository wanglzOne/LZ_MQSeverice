//
//  AEAllFoodTypeTableViewCell.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEAllFoodTypeTableViewCell.h"
#import "ProductModel.h"

@implementation AEAllFoodTypeTableViewCell

-(void)setModel:(ProductModel *)model{
    
    if ([model.mainCoverImageUrl isKindOfClass:[NSString class]]) {
        [self.foodImage sd_setImageWithURL:[NSURL URLWithString:[model.mainCoverImageUrl imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg1"]];
    }else
    {
        [self.foodImage sd_setImageWithURL:[NSURL URLWithString:[model.productClass.imgUrl imageUrl]] placeholderImage:[UIImage imageNamed:@"lbimg1"]];
    }
    
    NSString*str  = [[NSString alloc]init];
    for (lableKvModel *m in model.lableKvs) {
        NSDictionary *dic = [m yy_modelToJSONObject];
        str = [str stringByAppendingString:dic[@"value"]];
    }
    
    self.taste.text = @"";
    
    NSString *text = @"";
    if([str isEqualToString:@""]){
        text = @"";
    }else{
        text = [NSString stringWithFormat:@"口感 %@  ",str];
    }
    text = [NSString stringWithFormat:@"%@销量 %ld",text,model.saleCount];
    self.saleCount.text = text;
    
    
    self.productName.text = model.productName;
    self.price.text = MoneySymbol(model.price);
    
    if (model.shopCount) {
        self.count = model.shopCount;
    }
    else{
        self.count = 0;
    }
    self.addCount.text = [NSString stringWithFormat:@"%d",self.count];
    self.composeName.text = model.productMDesc;
    if ([model.productIntroduction isKindOfClass:[NSString class]]) {
        if (model.productIntroduction.length) {
            self.productLbeldesc.text = model.productIntroduction;
        }else
        {
            self.productLbeldesc.text = @"暂无介绍";
        }
    }else
    {
        self.productLbeldesc.text = @"暂无介绍";
    }
    //根据数量来判断显示的减按钮和数量显示
    if ([self.addCount.text isEqualToString:@"0"]) {
        [self.minus setHidden:YES];
        [self.addCount setHidden:YES];
    }
    else{
        [self.minus setHidden:NO];
        [self.addCount setHidden:NO];
    }
    //manjian
    
    
    
    
}

- (IBAction)minus:(id)sender {
    
    self.count--;
    if (self.count == 0) {
        [self.minus setHidden:YES];
        [self.addCount setHidden:YES];
    }else{
        self.addCount.text = [NSString stringWithFormat:@"%d",self.count];
    }
    
    if([self.delegate respondsToSelector:@selector(clickMinusBtn:)]){
        [self.delegate clickMinusBtn:self];
    }
}
- (IBAction)plus:(id)sender {
    
    self.count++;
    [self.minus setHidden:NO];
    [self.addCount setHidden:NO];
    self.addCount.text = [NSString stringWithFormat:@"%d",self.count];
    
    if([self.delegate respondsToSelector:@selector(clickPlusBtn:)]){
        [self.delegate clickPlusBtn:self];
    }
}


//界面改变调用
-(void)layoutSubviews
{
    //先保留父类中已经做好的布局
    [super layoutSubviews];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
