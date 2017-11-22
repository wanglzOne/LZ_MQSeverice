//
//  OrderNormalTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderNormalTableViewCell.h"

@implementation OrderNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lineHeight setConstant:0.5];
    self.lineView.backgroundColor = HWColor(230, 230, 230);
}

- (void)configUI:(NSString *)sectionName
{
    if ([self.label_title.text containsString:@"预计送达时"]) {
        [self.titleContentWith setConstant:100.0];
    }else if ([self.label_title.text containsString:@"在线支付("]) {
        [self.titleContentWith setConstant:140.0];
    }else {
        [self.titleContentWith setConstant:70];
    }
    
    
    if ([sectionName isEqualToString:@"youhui"]) {
        self.label_content.textColor = UIColorFromRGBA(0xfb3c30, 1);
    }else if ([sectionName isEqualToString:@"address"]) {
        self.label_content.textColor = UIColorFromRGBA(0x0e75ea, 1);
    }else
    {
        self.label_content.textColor = UIColorFromRGBA(0x333333, 1);
    }
    if ([sectionName isEqualToString:@"red"]) {
        self.arrowButton.hidden = NO;
    }else
    {
        self.arrowButton.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
