//
//  AETopSearchView.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/27.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AETopSearchView.h"

@interface AETopSearchView ()
@property (weak, nonatomic) IBOutlet UIButton *ClickBtn;

@end

@implementation AETopSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
//    self.frame = CGRectMake(HomeTopSearchBtnMargion, HomeTopSearchBtnMargion + Margion, ScreenWith/2, HomeTopSearchBtnHeight); // 需要适配
//    self.center = CGPointMake(ScreenWith/2, HomeTopSearchBtnMargion + Margion + 10);
    
        self.layer.cornerRadius = homeTopSearchCornerRadius;
        self.backgroundColor = [UIColor darkGrayColor];
}

+(instancetype) createTopSearchButton{
    
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AETopSearchView class]) owner:nil options:nil] firstObject];
}

-(void)SearchViewClickWithTarget:(id)target action:(SEL)action{
    
    [self.ClickBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
