//
//  BaseScrollView.h
//  ESmallFoot
//
//  Created by Apple on 16/1/12.
//  Copyright © 2016年 cn.Xiaoliu___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseScrollViewDelegate <NSObject>

- (void)initBaseScrollViewSelectPageNum:(NSInteger)pageNum;

@end

@interface BaseScrollView : UIView

@property (strong, nonatomic) UIColor * headerColor;


@property (nonatomic, strong,readonly) UIScrollView *scrollerView;

@property (nonatomic, strong) UIView *moveView;//移动线
//设置移动线的宽度
@property (nonatomic, assign) CGFloat width_moveView;
//设置 移动线的 背景view
- (void)moveViewBgView:(UIColor*)bgcolor;

@property (nonatomic, assign) CGFloat widthOfBtn;

@property (assign, nonatomic) id <BaseScrollViewDelegate> delegate;

- (void)setSubViewOfScrollerView:(NSArray *)subViewArray;

- (void)setViewsTitle:(NSArray *)titleArray;

@end
