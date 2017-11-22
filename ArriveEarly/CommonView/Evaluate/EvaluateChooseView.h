//
//  EvaluateChooseView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateChooseView : UIView
@property (weak, nonatomic) IBOutlet UIButton *evaluate1;
@property (weak, nonatomic) IBOutlet UIButton *evaluate3;
@property (weak, nonatomic) IBOutlet UIButton *evaluate5;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (assign, nonatomic) int starIndex;

@property (nonatomic, copy) CommonVoidBlock block;

@end
