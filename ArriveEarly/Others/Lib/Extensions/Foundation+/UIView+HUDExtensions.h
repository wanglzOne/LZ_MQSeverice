//
//  UIView+HUDExtensions.h
//  Parking
//
//  Created by ZhangTinghui on 14/12/13.
//  Copyright (c) 2014年 www.660pp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Blocks+Foundation+.h"

typedef NS_ENUM(NSInteger, UIViewPopupMessageType) {
    UIViewPopupMessageTypeOK,
    UIViewPopupMessageTypeError
};

@interface UIView (HUDExtensions)

#pragma mark - Popup Loading
- (void)showPopupLoading;
- (void)showPopupLoadingWithText:(NSString *)text;
- (void)showPopupLoadingWithText:(NSString *)text hideAfterDelay:(float)delay;
- (void)hidePopupLoading;
- (void)hidePopupLoadingAnimated:(BOOL)animated;

#pragma mark - Popup Message
- (void)showPopupOKMessage:(NSString *)message;
- (void)showPopupErrorMessage:(NSString *)message;
- (void)showPopupMessage:(NSString *)message type:(UIViewPopupMessageType)type;
- (void)showPopupMessage:(NSString *)message type:(UIViewPopupMessageType)type completion:(void(^)(void))completion;

#pragma mark - PlaneMessage
- (void)showPlaneMessage:(NSString *)message;
- (void)showPlaneMessage:(NSString *)message withIconImage:(UIImage *)iconImage;
- (void)hidePlaneMessage;



/**
 *  自己在  keyWindow上面加上的 一个提示用的label    (展示label只能显示一行  CommonVoidBlock不可用)
 *
 *  @param msg       <#msg description#>
 *  @param complment <#complment description#>
 */
- (void)showMsg:(NSString*)msg withBlock:(CommonVoidBlock)complment;

/**
 *  <#Description#>
 *
 *  @param message <#message description#>
 *  @param type    <#type description#>
 *  @param delay   显示时间 传递0 表示使用 按照人平均阅读1分钟/400字 进行计算 显示时间
 */
- (void)showPopupMessage:(NSString *)message type:(UIViewPopupMessageType)type afterDelay:(NSTimeInterval)delay;

@end
