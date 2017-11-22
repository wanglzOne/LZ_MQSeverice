//
//  BaseSettingViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseTitleLeftViewController.h"

typedef void(^ChangeSuccessBlock)(UIViewController *targetVienController, id changeContent);

@interface BaseSettingViewController : BaseTitleLeftViewController

+ (instancetype)changefromeVC:(UIViewController *)superVC andChangeToVCName:(NSString *)toVCName onComplete:(ChangeSuccessBlock)block;
@property (nonatomic, copy) ChangeSuccessBlock changedBlock;

@end
