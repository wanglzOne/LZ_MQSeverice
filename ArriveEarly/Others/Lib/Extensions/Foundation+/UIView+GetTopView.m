//
//  UIView+GetTopView.m
//  IDoerTW
//
//  Created by iosdev on 16/1/7.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "UIView+GetTopView.h"

@implementation UIView (GetTopView)

+ (UIView *)getWindowFirstView
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    UIView *subView  = nil;
    NSArray* aray = [window subviews];
    if (aray.count > 0) {
        subView = [aray lastObject]; // subView --> UILayoutContainerView 私有的类
        for (UIView* aSubView in subView.subviews) {
            [aSubView.layer removeAllAnimations];
        }
    }
    return subView;
}

- (UIView *)getWindowFirstView
{
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    UIView *subView  = nil;
    NSArray* aray = [window subviews];
    if (aray.count > 0) {
        subView = [aray lastObject]; // subView --> UILayoutContainerView 私有的类
        for (UIView* aSubView in subView.subviews) {
            [aSubView.layer removeAllAnimations];
        }
    }
    return subView;
}

@end
