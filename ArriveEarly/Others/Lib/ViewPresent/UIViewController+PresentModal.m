//
//  UIViewController+PresentModal.m
//  IDoerTW
//
//  Created by iosdev on 15/12/3.
//  Copyright © 2015年 iosdev. All rights reserved.
//

//
//#define AUTO_UPDATE
//
//#ifdef AUTO_UPDATE
////exist “#define AUTO_UPDATE”
//#else
////no “#define AUTO_UPDATE”
//#endif

#import "UIViewController+PresentModal.h"


#define AnimateWithDurationTime 0.3

#define BgAlpha 0.5

#define PresentModalBGViewTag 123450
#define PresentModalToPresentViewTag 123451

#define PresentModalBGViewViewTag 123453
#define PresentModalToPresentViewViewTag 123454

#define WINDOW_SUBVIEW

@implementation UIViewController (PresentModal)
//通过自己想要的功能 去按照思路实现 并且查看 apple 官方文档  进去查看 类中的方法和属性  看对自己想做的是否有帮助
- (void)addSubViews:(NSArray*)subviews
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    NSArray* aray = [window subviews];
    if (aray.count > 0) {
        UIView* subView = [aray lastObject]; // subView --> UILayoutContainerView 私有的类
        for (UIView* aSubView in subView.subviews) {
            [aSubView.layer removeAllAnimations];
        }
        for (UIView* vi in subviews) {
            [subView addSubview:vi];
        }
    }

    /*
     UILayoutContainerView;
     // 使用这个方法 和 addSubViews 方法中的 subView 是一样的效果
     UIViewController *target = self;
     while (target.parentViewController != nil) {
     target = target.parentViewController;
     }
     //target.view --> UILayoutContainerView
     DLog(@"%@",target.view);
     */
}

- (UIView*)viewGetViewWithTag:(NSInteger)index
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    NSArray* aray = [window subviews];
    if (aray.count > 0) {
        UIView* subView = [aray lastObject];

        return [subView viewWithTag:index];
    }
    return nil;
}

- (void)my_presentViewController:(UIViewController*)vcToPresent animated:(BOOL)flag completion:(CompletionVoidBlock)completion
{

    vcToPresent.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    vcToPresent.view.tag = PresentModalToPresentViewTag;

    vcToPresent.view.backgroundColor = [UIColor clearColor];

    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;

    bgView.tag = PresentModalBGViewTag;

#ifdef WINDOW_SUBVIEW
    [self addSubViews:@[ bgView, vcToPresent.view ]];
#else
    if (self.navigationController) {
        [self.navigationController.view addSubview:bgView];
        [self.navigationController.view addSubview:vcToPresent.view];
    }
    else {
        [self.view addSubview:bgView];
        [self.view addSubview:vcToPresent.view];
    }
#endif
    if (flag) {
        [UIView animateWithDuration:AnimateWithDurationTime
            animations:^{
                bgView.alpha = BgAlpha;

                vcToPresent.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            }
            completion:^(BOOL finished) {

                if (completion) {
                    completion();
                }
            }];
    }
    else {
        bgView.alpha = BgAlpha;
        vcToPresent.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        if (completion) {
            completion();
        }
    }
}

- (void)my_dismissViewControllerAnimated:(BOOL)flag completion:(CompletionVoidBlock)completion
{
    UIView* vcToPresentView;
    UIView* bgView;

#ifdef WINDOW_SUBVIEW
    vcToPresentView = [self viewGetViewWithTag:PresentModalToPresentViewTag];
    bgView = [self viewGetViewWithTag:PresentModalBGViewTag];
#else
    if (self.navigationController) {
        vcToPresentView = [self.navigationController.view viewWithTag:PresentModalToPresentViewTag];
        bgView = [self.navigationController.view viewWithTag:PresentModalBGViewTag];
    }
    else {
        vcToPresentView = [self.view viewWithTag:PresentModalToPresentViewTag];
        bgView = [self.view viewWithTag:PresentModalBGViewTag];
    }
#endif

    if (flag) {
        [UIView animateWithDuration:AnimateWithDurationTime
            animations:^{
                bgView.alpha = 0;
                vcToPresentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            }
            completion:^(BOOL finished) {
                [vcToPresentView removeFromSuperview];
                [bgView removeFromSuperview];
                if (completion) {
                    completion();
                }

            }];
    }
    else {
        [bgView removeFromSuperview];
        [vcToPresentView removeFromSuperview];
        bgView.alpha = 0;
        vcToPresentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        if (completion) {
            completion();
        }
    }
}

- (void)my_presentView:(UIView*)viewToPresent animated:(BOOL)flag completion:(CompletionVoidBlock)completion
{

    viewToPresent.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - viewToPresent.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height, viewToPresent.frame.size.width, viewToPresent.frame.size.height);

    viewToPresent.tag = PresentModalToPresentViewViewTag;

    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;

    bgView.tag = PresentModalBGViewViewTag;

#ifdef WINDOW_SUBVIEW
    [self addSubViews:@[ bgView, viewToPresent ]];
#else

    if (self.navigationController) {
        [self.navigationController.view addSubview:bgView];
        [self.navigationController.view addSubview:viewToPresent];
    }
    else {
        [self.view addSubview:bgView];
        [self.view addSubview:viewToPresent];
    }
#endif

    if (flag) {
        [UIView animateWithDuration:AnimateWithDurationTime
            animations:^{
                bgView.alpha = BgAlpha;

                viewToPresent.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - viewToPresent.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height - viewToPresent.frame.size.height, viewToPresent.frame.size.width, viewToPresent.frame.size.height);
            }
            completion:^(BOOL finished) {

                if (completion) {
                    completion();
                }
            }];
    }
    else {
        bgView.alpha = BgAlpha;
        viewToPresent.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - viewToPresent.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height - viewToPresent.frame.size.height, viewToPresent.frame.size.width, viewToPresent.frame.size.height);
        if (completion) {
            completion();
        }
    }
}

- (void)my_dismissViewAnimated:(BOOL)flag completion:(CompletionVoidBlock)completion
{

    UIView* viewToPresent;
    UIView* bgView;

#ifdef WINDOW_SUBVIEW
    viewToPresent = [self viewGetViewWithTag:PresentModalToPresentViewViewTag];
    bgView = [self viewGetViewWithTag:PresentModalBGViewViewTag];
#else
    if (self.navigationController) {
        viewToPresent = [self.navigationController.view viewWithTag:PresentModalToPresentViewViewTag];
        bgView = [self.navigationController.view viewWithTag:PresentModalBGViewViewTag];
    }
    else {
        viewToPresent = [self.view viewWithTag:PresentModalToPresentViewViewTag];
        bgView = [self.view viewWithTag:PresentModalBGViewViewTag];
    }
#endif
    
    if (flag) {
        [UIView animateWithDuration:AnimateWithDurationTime
            animations:^{
                bgView.alpha = 0;
                viewToPresent.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - viewToPresent.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height, viewToPresent.frame.size.width, viewToPresent.frame.size.height);
            }
            completion:^(BOOL finished) {
                [viewToPresent removeFromSuperview];
                [bgView removeFromSuperview];
                if (completion) {
                    completion();
                }
                
            }];
    }
    else {
        [bgView removeFromSuperview];
        [viewToPresent removeFromSuperview];
        bgView.alpha = 0;
        viewToPresent.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - viewToPresent.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height, viewToPresent.frame.size.width, viewToPresent.frame.size.height);
        if (completion) {
            completion();
        }
    }
}

@end

@implementation UIView (PresentModal)

- (void)my_presentViewController:(UIView*)viewToPresent animated:(BOOL)flag completion:(CompletionVoidBlock)completion
{
}

- (void)my_dismissViewControllerAnimated:(BOOL)flag completion:(CompletionVoidBlock)completion
{
}

@end