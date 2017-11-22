//
//  AECollectTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AECollectTableViewCell.h"

@interface AECollectTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (nonatomic, strong) NSArray <UIButton*>*btns;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

@end

@implementation AECollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lineViewHeight setConstant:0.5];

    // Initialization code
}

- (NSArray *)btns
{
    if (!_btns) {
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:self.btn1,self.btn2,self.btn3,self.btn4,self.btn5, nil];
        _btns = buttons;
    }
    return _btns;
}
- (void)setStar:(int)star
{
    _star = star;
    [self.btns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx<star) {
            obj.selected = YES;
        }else
            obj.selected = NO;
    }];
}
- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (isEditing) {
        [self.editViewLeading setConstant:0.0];
    }else
        [self.editViewLeading setConstant:-70.0];
}


- (void)setProduct:(ProductModel *)product
{
    _product = product;
    self.moneyLabel.text = MoneySymbol(product.price);
//    if ([product.productMDesc isKindOfClass:[NSString class]] && product.productMDesc!=(id)kCFNull)
//    {
//        self.descLabel.text = product.productMDesc;
//    }else
//    {
//        self.descLabel.text = @"";
//    }
    self.descLabel.text = product.productMDesc;
    self.star = product.evaScore;
    self.nameLabel.text = product.productName;

    
    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[(product.mainCoverImageUrl?product.mainCoverImageUrl:@"") imageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lbimg1"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
