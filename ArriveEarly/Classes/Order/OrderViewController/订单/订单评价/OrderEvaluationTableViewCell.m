//
//  OrderEvaluationTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderEvaluationTableViewCell.h"

@interface OrderEvaluationTableViewCell ()
@property (nonatomic, strong) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@end

@implementation OrderEvaluationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)starAction:(id)sender {
    int starI = (int)[self.btns indexOfObject:sender];
    [self updateBtnsStateWithStarIndex:starI+1];
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:clickButttonWithStarIndex:)]) {
        [self.delegate tableViewCell:self clickButttonWithStarIndex:self.starIndex];
    }
}

//0-5
- (void)setStarIndex:(int)starIndex
{
    [self updateBtnsStateWithStarIndex:starIndex];
}


- (int)starIndex
{
    for (int i = 0; i < self.btns.count; i ++) {
        UIButton *btn = self.btns[i];
        if (!btn.selected) {
            return i;
        }
    }
    return 5;
}

- (void)updateBtnsStateWithStarIndex:(int)starIndex
{
    for (int i = 0; i < self.btns.count; i ++) {
        UIButton *btn = self.btns[i];
        if (i < starIndex) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
}

- (NSArray *)btns
{
    if (!_btns) {
        _btns = [[NSArray alloc] initWithObjects:_btn1,_btn2,_btn3,_btn4,_btn5, nil];
    }
    return _btns;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
