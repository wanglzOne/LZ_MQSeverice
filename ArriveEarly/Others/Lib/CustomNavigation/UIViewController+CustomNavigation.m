//
//  UIViewController+CustomNavigation.m
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/5/4.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

const void *kCustomNavigationView = @"CustomNavigationView";

#import "UIViewController+CustomNavigation.h"

#import <objc/runtime.h>

@implementation UIViewController (CustomNavigation)

- (CustomNavigationView *)addCustomNavigationWithTitle:(NSString *)title
{
    return [self addCustomNavigationWithTitle:title withBackButtonBlock:nil];
}

- (CustomNavigationView *)addCustomNavigationWithTitle:(NSString *)title withBackButtonBlock:(CusNavButtonTouch_BackButton)backButtonBlock;
{
    WEAK(weakSelf);
    CustomNavigationView *cusNavView = nil;
    cusNavView = [[CustomNavigationView alloc] initWithSuperView:self.view onCusNavButtonTouch_BackButton:^(UIButton *backButton) {
        if (!backButtonBlock) {
            BOOL isDismiss = YES;
            
            if ([backButton.allTargets containsObject:weakSelf]) {
                NSArray *list = [backButton actionsForTarget:weakSelf forControlEvent:UIControlEventTouchUpInside];
                if (list.count) {
                    NSString *selStr = list[0];
                    SEL sel = NSSelectorFromString(selStr);
                    
                    if ([weakSelf respondsToSelector:sel]) {
                        [weakSelf performSelector:sel withObject:backButton];
                    }
                }
            }
            else
            {
                for (NSSet *set in backButton.allTargets) {
                    
                    if ([set isKindOfClass:[CustomNavigationView class]]) {
                        //绑定自身
                        
                    }
                    else if ([set isKindOfClass:[weakSelf class]])
                    {
                        isDismiss = NO;
                    }
                }
                if (weakSelf.navigationController) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else
                {
                    if (isDismiss) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }
            
            
            
        }
        else
        {
            backButtonBlock(backButton);
        }
    }];
    objc_setAssociatedObject(self, kCustomNavigationView, cusNavView, OBJC_ASSOCIATION_RETAIN);
    
    [cusNavView.backButton setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    
    
    [cusNavView.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    cusNavView.titleLabel.text = title;
    cusNavView.titleLabel.textColor = UIColorFromRGBA(0x333333, 1);

    return cusNavView;
}

- (void)addCustomNavigationRightButtonWithTitle:(NSString *)title image:(UIImage *)image seletor:(SEL)seletor
{
    NSParameterAssert(self.cusNavView != nil);
    
    [self.cusNavView createRightButtonWithTitle:title image:image];
    
    [self.cusNavView.rightButton addTarget:self action:seletor forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setCusNavHide
{
    self.cusNavView.hidden = YES;
}











#pragma mark -
- (CustomNavigationView *)cusNavView
{
    return objc_getAssociatedObject(self, kCustomNavigationView);
}

- (void)setCusNavView:(CustomNavigationView *)cusNavView
{
    objc_setAssociatedObject(self, kCustomNavigationView, cusNavView, OBJC_ASSOCIATION_RETAIN);
}

- (float)customNavigationView_Height
{
    return CustomNavigationView_Height;
}

@end
