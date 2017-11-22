//
//  NormalAlertView.h
//  ALATaxi
//
//  Created by  YiDaChuXing on 17/1/13.
//  Copyright © 2017年 com.jiangjiaxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTitleBlcok)(NSInteger clickIndex, NSString *title);

@interface NormalAlertView : UIView

+ (instancetype)showAlertViewForsubTitles:(NSArray *)subTitles andClickTitleBlcok:(ClickTitleBlcok)block;
+ (instancetype)showAlertViewForsubTitles:(NSArray *)subTitles invalIndexs:(NSArray <NSNumber *>*)invalIndexs andClickTitleBlcok:(ClickTitleBlcok)block;

///默认yes
@property (nonatomic, assign) BOOL isDefaultClickIndexToHide;

- (void)hidePop;

@end
