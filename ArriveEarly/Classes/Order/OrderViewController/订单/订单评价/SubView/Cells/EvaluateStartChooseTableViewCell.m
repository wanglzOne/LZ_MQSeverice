//
//  EvaluateStartChooseTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "EvaluateStartChooseTableViewCell.h"

@implementation EvaluateStartChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)loadCellForTableView:(UITableView *)tableView
{
    EvaluateStartChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateStartChoose"];
    if (!cell) {
        cell = [[EvaluateStartChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateStartChoose"];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        EvaluateStartChooseView *startView = [[NSBundle mainBundle] loadNibNamed:@"EvaluateStartChooseView" owner:nil options:nil][0];
        [self.contentView addSubview:startView];
        
        
        [startView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(15.0);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        self.starView = startView;
        
    }
    return self;
}

- (void)setOProductInfo:(OrderMessageProductInfo *)oProductInfo
{
    self.starView.titleLabel.text = oProductInfo.productInfo.productName;
}

- (void)setStar:(int)star
{
    self.starView.starIndex = star;
    WEAK(weakSelf);
    self.starView.block = ^(){
        [weakSelf starBlockCallBack];
    };
}

- (void)starBlockCallBack
{
    if (self.clickStarBlock) {
        self.clickStarBlock(@(self.starView.starIndex));
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
