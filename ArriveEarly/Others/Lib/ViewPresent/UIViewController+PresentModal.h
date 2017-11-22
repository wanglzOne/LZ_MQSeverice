//
//  UIViewController+PresentModal.h
//  IDoerTW
//
//  Created by iosdev on 15/12/3.
//  Copyright © 2015年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionVoidBlock)(void);

@interface UIViewController (PresentModal)





- (void)my_presentViewController:(UIViewController*)vcToPresent animated:(BOOL)flag completion:(CompletionVoidBlock)completion;

- (void)my_dismissViewControllerAnimated:(BOOL)flag completion:(CompletionVoidBlock)completion;


- (void)my_presentView:(UIView*)viewToPresent animated:(BOOL)flag completion:(CompletionVoidBlock)completion;

- (void)my_dismissViewAnimated:(BOOL)flag completion:(CompletionVoidBlock)completion;

@end

@interface UIView (PresentModal)

- (void)my_presentViewController:(UIView*)viewToPresent animated:(BOOL)flag completion:(CompletionVoidBlock)completion;

- (void)my_dismissViewControllerAnimated:(BOOL)flag completion:(CompletionVoidBlock)completion;

@end