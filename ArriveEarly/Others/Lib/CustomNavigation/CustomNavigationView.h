//
//  CustomNavigationView.h
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/5/4.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CusNavButtonTouchUpInside)(UIButton *clickButton);

typedef void (^CusNavButtonTouch_BackButton)(UIButton *backButton);

#define CustomNavigationView_Height 64.0f


typedef NS_ENUM(NSInteger, CustomNavigationViewType) {
    CustomNavigationViewTypeNormal = 0,
    CustomNavigationViewTypeTitleLeft,
};

@interface CustomNavigationView : UIView

- (id)initWithSuperView:(UIView *)superView onCusNavButtonTouch_BackButton:(CusNavButtonTouch_BackButton)backButtonBlock;

@property (nonatomic, assign) CustomNavigationViewType show_type;

/**
 *  可以在外面创建给rightButton赋值，也可以使用下面方法创建 默认的
 */
- (void)createRightButtonWithTitle:(NSString *)title image:(UIImage *)image;
- (void)createRightButtonWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;




@property (nonatomic, copy) CusNavButtonTouchUpInside block;

@property (nonatomic, copy) CusNavButtonTouch_BackButton backButtonBlock;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;


@property (nonatomic, strong) UIButton *backButton;

/**************   常用控件      ****************/
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;



@end
