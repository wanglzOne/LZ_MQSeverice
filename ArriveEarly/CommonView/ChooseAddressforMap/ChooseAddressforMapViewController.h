//
//  ChooseAddressforMapViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomNavViewController.h"

typedef void(^ChooseAddressforMapBlock)(id param);


@interface ChooseAddressforMapViewController : BaseCustomNavViewController
+ (instancetype)chooseAddressFormVC:(UIViewController *)fromVC onCompleteBlock:(ChooseAddressforMapBlock)block;

- (void)beginSlidingChoiceUdateArress;

@end
