//
//  NormalWebPageViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/14.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

@interface NormalWebPageViewController : BaseSettingViewController

+ (instancetype)changefromeVC:(UIViewController *)superVC andTitle:(NSString *)title andLoadUrl:(NSString *)url;
@property (nonatomic, copy) NSString *cusTitle;
@property (nonatomic, copy) NSString *url;

@end
