//
//  UIView+CusAlertView.h
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ShowCustomType) {
    ShowCustomTypeAlert = 0,
    ShowCustomTypeActionSheet = 1,
};

typedef void (^SimpleTapReceivedBlock)(void);

@interface UIView (CusAlertView)



- (void)actionShow_custom;
- (void)actionHide_custom;


- (void)show_custom;
- (void)hide_custom;

@property (nonatomic, assign) ShowCustomType showType;

/**
 *  默认为 NO 不允许点击背景view消失
 */
@property (nonatomic, assign) BOOL isAllowClickBackgroundViewToHideView;


- (void)setClickBackgroundViewBlock:(SimpleTapReceivedBlock)block;

@property (nonatomic, copy) SimpleTapReceivedBlock simpleTapReceivedBlock_custom;

@end
