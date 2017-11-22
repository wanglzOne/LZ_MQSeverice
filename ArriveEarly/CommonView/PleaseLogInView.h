//
//  PleaseLogInView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/21.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PleaseLogInView : UIView

+ (instancetype)loadXIB;
@property (weak, nonatomic) IBOutlet UILabel *messageLbael;

@property (nonatomic, copy) CommonVoidBlock block;

- (void)setClickLoginButtonBlock:(CommonVoidBlock) block;

@end
