//
//  CustomStarView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomStarView : UIView
+ (instancetype)customStarView;
@property (nonatomic, strong) NSArray *btns;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (assign, nonatomic) int starIndex;


@end
