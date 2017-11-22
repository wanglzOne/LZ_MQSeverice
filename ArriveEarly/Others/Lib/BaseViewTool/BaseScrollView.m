//
//  BaseScrollView.m
//  ESmallFoot
//
//  Created by Apple on 16/1/12.
//  Copyright © 2016年 cn.Xiaoliu___. All rights reserved.
//

#import "BaseScrollView.h"

@interface BaseScrollView ()<UIScrollViewDelegate>

{
    
}

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *subViewArray;

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *moveViewBView;
@property (nonatomic, strong) NSMutableArray *buttonArray;



@end

@implementation BaseScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark --------------------   UI

- (void)initView
{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    _headerView.backgroundColor = HWColor(255, 255, 255);
    
    _moveViewBView = [[UIView alloc]init];
    //_moveViewBView.backgroundColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1];
    _moveViewBView.backgroundColor = [UIColor clearColor];
    
    _moveView = [[UIView alloc]init];
    _moveView.backgroundColor = HWColor(0xff, 0xd7, 0x05);
    
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.bounds.size.height - 40)];
    _scrollerView.delegate = self;
    _scrollerView.pagingEnabled = YES;
    _scrollerView.bounces = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    [_headerView addSubview:_moveViewBView];
    [_headerView addSubview:_moveView];
    [self addSubview:_headerView];
    [self addSubview:_scrollerView];
}

- (void)setHeaderColor:(UIColor *)headerColor
{
    _headerView.backgroundColor = self.headerColor;
}

- (void)setSubViewOfScrollerView:(NSArray *)subViewArray
{
    _scrollerView.contentSize = CGSizeMake(self.frame.size.width * subViewArray.count, self.bounds.size.height - 40);
    for (NSInteger index = 0; index < subViewArray.count; index ++)
    {
        UIView *view = [subViewArray objectAtIndex:index];
        view.frame = CGRectMake(self.frame.size.width * index, 0, self.frame.size.width, _scrollerView.bounds.size.height);
        [_scrollerView addSubview:view];
    }
}
- (void)moveViewBgView:(UIColor*)bgcolor
{
    _moveViewBView.backgroundColor = bgcolor;
}

- (void)setViewsTitle:(NSArray *)titleArray
{
    
    
    
    self.widthOfBtn = self.frame.size.width/titleArray.count;
    if (!self.width_moveView) {
        self.width_moveView = self.widthOfBtn;
    }
    _moveView.frame = CGRectMake(0, 38, self.width_moveView, 2);
    _moveViewBView.frame = CGRectMake(0, 38, self.frame.size.width, 2);
    self.buttonArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < titleArray.count; index ++)
    {
        UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.widthOfBtn * index, 0, self.widthOfBtn, 40)];
        [PackagMet getButtonTitle:clickBtn Title:[titleArray objectAtIndex:index] Font:15 Color:HWColor(0, 0, 0)];
        if (index == 0) {
            _moveView.center = CGPointMake(clickBtn.center.x, 39);
        }
        clickBtn.tag = index;
        [clickBtn addTarget: self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:clickBtn];
        
        if (index == 0) {
            [clickBtn setTitleColor:HWColor(0x33, 0x33, 0x33) forState:UIControlStateNormal];
        }else {
            [clickBtn setTitleColor:HWColor(0x66, 0x66, 0x66) forState:UIControlStateNormal];
        }
        
        [self.buttonArray addObject:clickBtn];
    }
}


#pragma mark -------------------- UIScrollViewDelegate

//  滑动ScrollView改变moveView的Frame
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _moveView.frame = CGRectMake(self.widthOfBtn * scrollView.contentOffset.x/self.frame.size.width + (self.widthOfBtn - self.width_moveView)/2, 38, self.width_moveView, 2);
}

/**
 *  减速完毕
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.delegate initBaseScrollViewSelectPageNum:scrollView.contentOffset.x/self.frame.size.width];
}

#pragma mark --------------------   Action

//  点击按钮改变ScrollView的Frame
- (void)clickAction:(UIButton *)btn
{
    
    for (UIButton *btn2 in self.buttonArray) {
        if (btn2 == btn) {
            [btn2 setTitleColor:HWColor(0x33, 0x33, 0x33) forState:UIControlStateNormal];
        }else {
            [btn2 setTitleColor:HWColor(0x66, 0x66, 0x66) forState:UIControlStateNormal];
        }
    }
    
    [self.delegate initBaseScrollViewSelectPageNum:btn.tag];
    [UIView animateWithDuration:.3 animations:^{
//        _moveView.frame = CGRectMake(self.widthOfBtn * btn.tag, 38, self.width_moveView, 2);
        _moveView.center = CGPointMake(btn.center.x, 39);
        _scrollerView.contentOffset = CGPointMake(self.frame.size.width *btn.tag, 0);
    }];
}

@end
