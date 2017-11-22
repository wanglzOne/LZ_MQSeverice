//
//  OrderDetailView.h
//  早点到APP
//
//  Created by m on 16/9/26.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderMessageModelInfo.h"


#import "DetailsOrderViewController.h"

@interface OrderDetailView : UIView
@property (nonatomic, assign) CGFloat heightForHeaderInSectionOne;

@property (nonatomic, weak) id<DetailsOrderViewPperationDelegate>delegate;
+(instancetype)initCustomView;

- (void)configWithOrderMessageModelInfo:(OrderMessageModelInfo *)info superVC:(UIViewController*)superVC;


- (void)refreshUI;

@end
