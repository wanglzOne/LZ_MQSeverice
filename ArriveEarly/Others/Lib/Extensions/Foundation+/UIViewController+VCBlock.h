//
//  UIViewController+VCBlock.h
//  IDoerTW
//
//  Created by iosdev on 16/1/5.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusProgressView : UIView

@end

//9.一个通用回调的简单示例(from 灰灰)
@interface UIViewController (VCBlock)

@property (nonatomic, copy) void (^viewControllerActionBlock)(UIViewController* vc, NSUInteger type, NSDictionary* dict);

#pragma mark - viewControllerAction

/**
 *  View 事件的block回调
 *
 *  @param viewControllerActionBlock block的参数有view本身，状态码，键值对。
 */
- (void)viewControllerAction:(void (^)(UIViewController* vc, NSUInteger type, NSDictionary* dict))viewControllerActionBlock;

/**
 *  获得跟 视图控制器
 *
 *  @return <#return value description#>
 */
- (UIViewController*) topMostController;



- (void)promptAlertMessage:(NSString *)alertMessage;

@property (nonatomic, strong) CusProgressView *progressView;



@end


