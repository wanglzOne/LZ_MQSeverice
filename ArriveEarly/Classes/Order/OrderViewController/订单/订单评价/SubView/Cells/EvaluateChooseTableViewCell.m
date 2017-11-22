//
//  EvaluateChooseTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "EvaluateChooseTableViewCell.h"

@implementation EvaluateChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)loadCellForTableView:(UITableView *)tableView
{
    EvaluateChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateChoose"];
    if (!cell) {
        cell = [[EvaluateChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateChoose"];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        EvaluateChooseView *startView = [[NSBundle mainBundle] loadNibNamed:@"EvaluateChooseView" owner:nil options:nil][0];
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

- (void)setTitleCus:(NSString *)titleCus
{
    _titleCus = titleCus;
    self.starView.titleLabel.text = titleCus;
    
    
}
- (void)setStar:(int)star
{
    _star = star;
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
