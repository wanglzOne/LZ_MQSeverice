//
//  BaseDatePickView.h
//  ESmallFoot
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 cn.Xiaoliu___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getTimeDelegate <NSObject>

- (void)getTime:(NSString *)timeString;

@end

@interface BaseDatePickView : UIView

@property (nonatomic, strong) UIDatePicker *datePick;
@property (nonatomic, assign) id <getTimeDelegate> delegate;

- (void)setHidden:(BOOL)isHidden;

- (void)setViewTitle:(NSString *)title;

@end
