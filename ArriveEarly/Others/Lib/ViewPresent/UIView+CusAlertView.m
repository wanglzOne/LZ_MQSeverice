//
//  UIView+CusAlertView.m
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import "UIView+CusAlertView.h"

#import <objc/runtime.h>

const void *k_self_View = @"self_View";

const void *kShowType = @"ShowType";

const void *kBackgroundView = @"BackgroundView";
const void *kIsAllowClickBackgroundViewToHideView = @"IsAllowClickBackgroundViewToHideView";
const void *kSimpleTapReceivedBlock = @"SimpleTapReceivedBlock";

@implementation UIView (CusAlertView)


- (void)show_custom
{
    self.showType = ShowCustomTypeAlert;
    UIView *vi = [self subView];
    if (vi) {
        self.frame = CGRectMake(UIScreenWidth/2 - self.frame.size.width/2,
                                UIScreenHeight/2 - self.frame.size.height/2,
                                self.bounds.size.width,
                                self.bounds.size.height);
        //当界面 上 出现多个view 的时候 就移除上一个 始终只显示一个，        如果需要去保留多个，可以将self放在一个数组中， 界面上显示最后一个，  最后一个消失在显示上一个出啦（无动画）
        [self addBack];
        [self showBackground];
        [self showAlertAnimation];
    }
}
- (void)hide_custom
{
    self.isAllowClickBackgroundViewToHideView = YES;
    [self simpleTapReceived:nil];
}

- (void)actionShow_custom
{
    self.showType = ShowCustomTypeActionSheet;
    UIView *vi = [self subView];
    if (vi) {
        self.frame = CGRectMake(UIScreenWidth/2 - self.frame.size.width/2,
                                UIScreenHeight,
                                self.bounds.size.width,
                                self.bounds.size.height);
        [self addBack];
        [self actionShowBackground];
        [self actionShowAlertAnimation];
    }
}
- (void)actionHide_custom
{
    self.isAllowClickBackgroundViewToHideView = YES;
    [self actionSimpleTapReceived:nil];
}

- (void)addBack
{
    UIView *vi = [self subView];
    UIView *self_view = objc_getAssociatedObject(vi, k_self_View);
    [self_view removeFromSuperview];
    self_view = nil;
    //使用 一个数组 来存储不同的 kBackgroundView
    UIView *backGroundView = objc_getAssociatedObject(vi, kBackgroundView);
    [backGroundView removeFromSuperview];
    backGroundView = nil;
    
    if (!backGroundView) {
        backGroundView = [[UIView alloc] initWithFrame:
                          [UIScreen mainScreen].bounds];
        backGroundView.backgroundColor = [UIColor blackColor];
        backGroundView.alpha = 0.f;
        objc_setAssociatedObject(vi,
                                 kBackgroundView,
                                 backGroundView,
                                 OBJC_ASSOCIATION_RETAIN);
        
        [vi addSubview:backGroundView];
        SEL  sell = nil;
        if (self.showType == ShowCustomTypeAlert) {
            sell = @selector(simpleTapReceived:);
        }else
        {
            sell = @selector(actionSimpleTapReceived:);
        }
        UITapGestureRecognizer* simpleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:sell];
        simpleTapRecognizer.numberOfTapsRequired = 1;
        [backGroundView addGestureRecognizer:simpleTapRecognizer];
    }
    [vi addSubview:self];
    objc_setAssociatedObject(vi,
                             k_self_View,
                             self,
                             OBJC_ASSOCIATION_RETAIN);
}

- (void)simpleTapReceived:(id)sender
{
    if (self.isAllowClickBackgroundViewToHideView) {
        [self hideAlertAnimation];
        if (sender && self.simpleTapReceivedBlock_custom) {
            self.simpleTapReceivedBlock_custom();
        }
        [self removeFromSuperview];
    }
}
- (void)actionSimpleTapReceived:(id)sender
{
    if (self.isAllowClickBackgroundViewToHideView) {
        [self hideActionSheetAnimation];
        if (sender && self.simpleTapReceivedBlock_custom) {
            self.simpleTapReceivedBlock_custom();
        }
    }
}
- (void)showBackground
{
    UIView *backGroundView = [self getBackGroundView];
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.30];
    backGroundView.alpha = 0.4;
    [UIView commitAnimations];
}
- (void)actionShowBackground
{
    UIView *backGroundView = [self getBackGroundView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    backGroundView.alpha = 0.4;
    [UIView commitAnimations];
}
- (void)showAlertAnimation
{
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray* values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}
- (void)actionShowAlertAnimation
{
    [UIView animateWithDuration:0.30 animations:^{
        self.frame = CGRectMake(UIScreenWidth/2 - self.frame.size.width/2,
                                UIScreenHeight-self.bounds.size.height,
                                self.bounds.size.width,
                                self.bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)hideAlertAnimation
{
    UIView *backGroundView = [self getBackGroundView];
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.30];
    backGroundView.alpha = 0.0;
    [UIView commitAnimations];
    objc_removeAssociatedObjects(backGroundView);
    [backGroundView removeFromSuperview];
    backGroundView = nil;
}
- (void)hideActionSheetAnimation
{
    UIView *backGroundView = [self getBackGroundView];
    //[self removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        backGroundView.alpha = 0.0;
        self.frame = CGRectMake(UIScreenWidth/2 - self.frame.size.width/2,
                                UIScreenHeight,
                                self.bounds.size.width,
                                self.bounds.size.height);
    } completion:^(BOOL finished) {
        objc_removeAssociatedObjects(backGroundView);
        [backGroundView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (UIView *)getBackGroundView
{
    UIView *vi = [self subView];
    if (vi) {
        return objc_getAssociatedObject(vi, kBackgroundView);
    }
    return nil;
}

- (UIView *)subView
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    return window;
    NSArray* windowViews = [window subviews];
    if (windowViews && [windowViews count] > 0) {
        UIView* subView = [windowViews lastObject];
        for (UIView* aSubView in subView.subviews) {
            [aSubView.layer removeAllAnimations];
        }
        return subView;
    }
    return nil;
}

- (void)setClickBackgroundViewBlock:(SimpleTapReceivedBlock)block
{
    self.simpleTapReceivedBlock_custom = block;
}

- (void)setIsAllowClickBackgroundViewToHideView:(BOOL)isAllowClickBackgroundViewToHideView
{
    objc_setAssociatedObject(self, kIsAllowClickBackgroundViewToHideView, @(isAllowClickBackgroundViewToHideView), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAllowClickBackgroundViewToHideView
{
    return [objc_getAssociatedObject(self, kIsAllowClickBackgroundViewToHideView) boolValue];
}
- (void)setShowType:(ShowCustomType)showType
{
    objc_setAssociatedObject(self, kShowType, @(showType), OBJC_ASSOCIATION_ASSIGN);
}
- (ShowCustomType)showType
{
    return [objc_getAssociatedObject(self, kShowType) integerValue];
}

- (void)setSimpleTapReceivedBlock_custom:(SimpleTapReceivedBlock)simpleTapReceivedBlock_custom
{
    objc_setAssociatedObject(self, kSimpleTapReceivedBlock, simpleTapReceivedBlock_custom, OBJC_ASSOCIATION_COPY);
}

- (SimpleTapReceivedBlock)simpleTapReceivedBlock_custom
{
    return objc_getAssociatedObject(self, kSimpleTapReceivedBlock);
}

@end
