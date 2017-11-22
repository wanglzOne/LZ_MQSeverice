//
//  UIView+HUDExtensions.m
//  Parking
//
//  Created by ZhangTinghui on 14/12/13.
//  Copyright (c) 2014年 www.660pp.com. All rights reserved.
//

#import "UIView+HUDExtensions.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "NSString+GetSize.h"

static const NSInteger kHUDPopLoadingViewTag = 1412301511;
static const NSInteger kHUDPlaneMessageViewTag = 1501091133;

@interface HUDCustomLoadingView : UIView
@property (nonatomic, weak) UIImageView* loadingView;
@property (nonatomic, assign) BOOL shouldRestoreAnimation;

+ (instancetype)loadingView;
- (void)stopLoadingAnimation;
- (void)startLoadingAnimation;
@end

@implementation HUDCustomLoadingView
- (void)dealloc
{
    [self stopLoadingAnimation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)loadingView
{
    CGRect rect = CGRectMake(0, 0, 37, 37);
    return [[self alloc] initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self _addLoadingView];
        [self _registerAppStateNotifications];
        [self startLoadingAnimation];
    }
    return self;
}

- (void)_addLoadingView
{
    [@[ @"hud_icon_loading", @"hud_icon_pp" ] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        UIImage* image = [UIImage imageNamed:obj];
        UIImageView* view = [[UIImageView alloc] initWithImage:image];
        view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        view.frame = self.bounds;
        [self addSubview:view];

        if (idx == 0) {
            self.loadingView = view;
        }
    }];
}

- (BOOL)_isInLoadingAnimation
{
    return ([self.loadingView.layer animationForKey:@"loading"] != nil);
}

- (void)stopLoadingAnimation
{
    if (![self _isInLoadingAnimation]) {
        return;
    }
    [self.loadingView.layer removeAnimationForKey:@"loading"];
}

- (void)startLoadingAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"loading"];
}

#pragma mark - AppStateNotification
- (void)_registerAppStateNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_appDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)_appDidEnterBackground:(NSNotification*)notification
{
    self.shouldRestoreAnimation = [self _isInLoadingAnimation];
    [self stopLoadingAnimation];
}

- (void)_appWillEnterForeground:(NSNotification*)notification
{
    if (!self.shouldRestoreAnimation) {
        return;
    }

    [self startLoadingAnimation];
}

@end

@implementation UIView (HUDExtensions)

#pragma mark - Popup Loading
- (MBProgressHUD*)_createAndShowHUDForPopupLoading
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.tag = kHUDPopLoadingViewTag;
    hud.removeFromSuperViewOnHide = YES;
    //    hud.mode = MBProgressHUDModeCustomView;
    //    hud.customView = [HUDCustomLoadingView loadingView];
    return hud;
}

- (void)showPopupLoading
{
    [self showPopupLoadingWithText:nil];
}

- (void)showPopupLoadingWithText:(NSString*)text
{
    if ([self isKindOfClass:[CusProgressView class]]) {
        self.hidden = NO;
    }
    [self _createAndShowHUDForPopupLoading].label.text = text;
}

- (void)showPopupLoadingWithText:(NSString*)text hideAfterDelay:(float)delay
{
    MBProgressHUD* hud = [self _createAndShowHUDForPopupLoading];
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)hidePopupLoading
{
    [self hidePopupLoadingAnimated:YES];
}

- (void)hidePopupLoadingAnimated:(BOOL)animated
{
    NSArray* huds = [MBProgressHUD allHUDsForView:self];
    
    for (MBProgressHUD* hud in huds) {
        if (hud.tag == kHUDPopLoadingViewTag) {
            [hud hideAnimated:animated];
        }
    }
    if ([self isKindOfClass:[CusProgressView class]]) {
        self.hidden = YES;
    }
}

#pragma mark - Popup Message
- (void)showPopupOKMessage:(NSString*)message
{
    [self showPopupMessage:message type:UIViewPopupMessageTypeOK];
}

- (void)showPopupErrorMessage:(NSString*)message
{
    [self showPopupMessage:message type:UIViewPopupMessageTypeError];
}
- (void)showPopupMessage:(NSString*)message type:(UIViewPopupMessageType)type afterDelay:(NSTimeInterval)delay
{
    [self showPopupMessage:message type:type afterDelay:delay completion:nil];
}
- (void)showPopupMessage:(NSString*)message type:(UIViewPopupMessageType)type
{
    [self showPopupMessage:message type:type completion:nil];
}
- (void)showPopupMessage:(NSString*)message
                    type:(UIViewPopupMessageType)type
              afterDelay:(NSTimeInterval)delay
              completion:(void (^)(void))completion
{
    if (delay) {
        if ([message length] <= 0) {
            if (!self) {
                return;
            }
            if (completion) {
                completion();
            }
            return;
        }
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        UIImage* iconImage = nil;
        switch (type) {
        case UIViewPopupMessageTypeError:
            iconImage = [UIImage imageNamed:@"hud_icon_error"];
            break;
        case UIViewPopupMessageTypeOK:
        default:
            iconImage = [UIImage imageNamed:@"hud_icon_ok"];
            break;
        }
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:iconImage];
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16];

        if (completion) {
            hud.completionBlock = completion;
        }
        [hud hideAnimated:YES afterDelay:MAX(0.5f, delay)];
        //handle tap
        [hud addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                              action:@selector(_handleHUDTap:)]];
    }
    else {
        [self showPopupMessage:message type:type completion:completion];
    }
}
- (void)showPopupMessage:(NSString*)message
                    type:(UIViewPopupMessageType)type
              completion:(void (^)(void))completion
{

    if ([message length] <= 0) {
        if (!self) {
            return;
        }
        if (completion) {
            completion();
        }
        return;
    }

    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    UIImage* iconImage = nil;
    switch (type) {
    case UIViewPopupMessageTypeError:
        iconImage = [UIImage imageNamed:@"hud_icon_error"];
        break;
    case UIViewPopupMessageTypeOK:
    default:
        iconImage = [UIImage imageNamed:@"hud_icon_ok"];
        break;
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:iconImage];
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];

    if (completion) {
        hud.completionBlock = completion;
    }

    //根据消息的文字长度，决定delay时间长短
    //按照人平均阅读速度 400个/分钟
    NSTimeInterval delay = [message length] / (400 / 60);
    [hud hide:YES afterDelay:MIN(MAX(1.5f, delay), 3)];

    //handle tap
    [hud addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                          action:@selector(_handleHUDTap:)]];
}

- (void)_handleHUDTap:(UITapGestureRecognizer*)recognizer
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - PlaneMessage
- (void)showPlaneMessage:(NSString*)message
{
    [self showPlaneMessage:message withIconImage:[UIImage imageNamed:@"hud_gray_info"]];
}

- (void)showPlaneMessage:(NSString*)message withIconImage:(UIImage*)iconImage
{
    UIView* containerView = [self viewWithTag:kHUDPlaneMessageViewTag];
    if (!containerView) {
        CGRect frame = self.bounds;
        CGPoint contentCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

        containerView = [[UIView alloc] initWithFrame:frame];
        containerView.backgroundColor = [UIColor grayColor];
        containerView.tag = kHUDPlaneMessageViewTag;

        UIImageView* imageView = [[UIImageView alloc] initWithImage:iconImage];

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        //        label.font          = SystemFont(14);
        //        label.textColor     = UIColorForAppGrayLightTextColor;
        label.text = message;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByWordWrapping;

        // message
        CGRect labelBounds = self.bounds;
        labelBounds.size.width -= 10 * 2;
        labelBounds.size.height = [message boundingRectWithSize:CGSizeMake(CGRectGetWidth(labelBounds), CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }
                                                        context:nil]
                                      .size.height;
        label.bounds = labelBounds;
        label.center = contentCenter;
        imageView.center = CGPointMake(contentCenter.x,
            contentCenter.y - CGRectGetHeight(labelBounds) / 2 - 15 - CGRectGetHeight(imageView.bounds) / 2);

        [containerView addSubview:imageView];
        [containerView addSubview:label];

        [self addSubview:containerView];
    }
}

- (void)hidePlaneMessage
{
    UIView* containerView = [self viewWithTag:kHUDPlaneMessageViewTag];
    if (containerView) {
        [containerView removeFromSuperview];
        containerView = nil;
    }
}

- (void)showMsg:(NSString*)msg withBlock:(CommonVoidBlock)complment
{
    UILabel* addMsgLabeladdMsgLabel = [self sharedLabel];
    CGSize msgSize = [NSString getSizelabelAutoCalculateRectWith:msg FontSize:17 MaxSize:CGSizeMake(0, 0)];
    [addMsgLabeladdMsgLabel setFrame:CGRectMake(UIScreenWidth / 2 - msgSize.width / 2, UIScreenHeight, msgSize.width + 10, msgSize.height + 10)];
    addMsgLabeladdMsgLabel.text = msg;
    addMsgLabeladdMsgLabel.alpha = 0;
    addMsgLabeladdMsgLabel.font = [UIFont systemFontOfSize:17];
    addMsgLabeladdMsgLabel.textColor = [UIColor whiteColor];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:addMsgLabeladdMsgLabel];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    addMsgLabeladdMsgLabel.frame = CGRectMake(UIScreenWidth / 2 - msgSize.width / 2, UIScreenHeight - msgSize.height - 64 - 44, msgSize.width, msgSize.height);
    //addMsgLabeladdMsgLabel.layer.borderWidth = 1.0;
    addMsgLabeladdMsgLabel.backgroundColor = [UIColor grayColor];
    addMsgLabeladdMsgLabel.layer.cornerRadius = 3;
    addMsgLabeladdMsgLabel.layer.masksToBounds = YES;
    addMsgLabeladdMsgLabel.alpha = 1;
    [UIView commitAnimations];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2秒后异步执行这里的代码...
        [addMsgLabeladdMsgLabel removeFromSuperview];
        if (complment) {
            complment();
        }
    });
}
- (UILabel*)sharedLabel
{
    static UILabel* label = nil;
    static dispatch_once_t onceToken; //???有神马作用
    dispatch_once(&onceToken, ^{
        label = [[UILabel alloc] init];
    });

    return label;
}
@end
