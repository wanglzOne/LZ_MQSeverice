//
//  EvaluateStartChooseView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface EvaluateStartChooseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *start1;
@property (weak, nonatomic) IBOutlet UIButton *start2;
@property (weak, nonatomic) IBOutlet UIButton *start3;
@property (weak, nonatomic) IBOutlet UIButton *start4;
@property (weak, nonatomic) IBOutlet UIButton *start5;
@property (strong, nonatomic) NSArray *btns;

@property (assign, nonatomic) int starIndex;

@property (nonatomic, copy) CommonVoidBlock block;

@end
