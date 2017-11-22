//
//  UIViewController+VCBlock.m
//  IDoerTW
//
//  Created by iosdev on 16/1/5.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "UIViewController+VCBlock.h"

#import <objc/runtime.h>

const void *KEYProgressView;

@implementation CusProgressView

@end


@implementation UIViewController (VCBlock)

#pragma mark - runtime associate

- (void)setViewControllerActionBlock:(void (^)(UIViewController *vc, NSUInteger type, NSDictionary *dict))viewControllerActionBlock {
    objc_setAssociatedObject(self, @selector(viewControllerActionBlock), viewControllerActionBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UIViewController *, NSUInteger, NSDictionary *))viewControllerActionBlock {
    return objc_getAssociatedObject(self, @selector(viewControllerActionBlock));
}

#pragma mark - block

- (void)viewControllerAction:(void (^)(UIViewController *vc, NSUInteger type, NSDictionary *dict))viewControllerActionBlock {
    self.viewControllerActionBlock = nil;
    self.viewControllerActionBlock = [viewControllerActionBlock copy];
}


- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}


- (void)promptAlertMessage:(NSString *)alertMessage
{
        [UIAlertController showInViewController:self withTitle:@"提示" message:alertMessage preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
           
        }];
}


- (CusProgressView *)progressView
{
    CusProgressView *proView = objc_getAssociatedObject(self, KEYProgressView);
    if (!proView) {
        proView = [[CusProgressView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        objc_setAssociatedObject(self, KEYProgressView, proView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self.view addSubview:proView];
    return proView;
}
- (void)setProgressView:(CusProgressView *)progressView
{
    objc_setAssociatedObject(self, KEYProgressView, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
