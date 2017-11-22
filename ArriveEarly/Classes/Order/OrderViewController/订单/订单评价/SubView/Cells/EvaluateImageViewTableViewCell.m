//
//  EvaluateImageViewTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "EvaluateImageViewTableViewCell.h"

@implementation EvaluateImageViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)loadCellForTableView:(UITableView *)tableView
{
    EvaluateImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateImageChoose"];
    if (!cell) {
        cell = [[EvaluateImageViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateImageChoose"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.picView = [[PicturesChooseView alloc] initWithFrame:CGRectMake(8, 0, KScreenWidth - 16, 0)];
        [self.contentView addSubview:self.picView];
        self.picView.maxImage = 8;
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
