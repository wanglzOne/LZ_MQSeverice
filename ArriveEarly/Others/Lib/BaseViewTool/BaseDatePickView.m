//
//  BaseDatePickView.m
//  ESmallFoot
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 cn.Xiaoliu___. All rights reserved.
//

#import "BaseDatePickView.h"

#define KViewHeight self.bounds.size.height
#define KViewWidth self.bounds.size.width

@interface BaseDatePickView ()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BaseDatePickView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark -------------------- UI

- (void)initView {
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    UIButton *hiddenBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KViewWidth, KViewHeight - 200)];
    [hiddenBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hiddenBtn];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, KViewHeight - 200, KViewWidth, 200)];
    footView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((KViewWidth - 100)/2, 0, 100, 40)];
    _titleLabel.text = @"请选择时间";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:_titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, 60, 40)];
    [PackagMet getButtonTitle:cancelBtn Title:@"取消" Font:13 Color:HWColor(54, 151, 237)];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(KViewWidth - 68, 0, 60, 40)];
    [PackagMet getButtonTitle:sureBtn Title:@"确定" Font:13 Color:HWColor(54, 151, 237)];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    
    _datePick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, KViewWidth, 160)];
    [_datePick setDate:[NSDate date]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datePick.locale = locale;
    [_datePick setDatePickerMode:UIDatePickerModeDate];
    
    [footView addSubview:cancelBtn];
    [footView addSubview:sureBtn];
    [footView addSubview:[self getSeparatView:0]];
    [footView addSubview:[self getSeparatView:39]];
    [footView addSubview:_datePick];
}

- (UIView *)getSeparatView:(CGFloat )yy {
    UIView *separatView = [[UIView alloc] initWithFrame:CGRectMake(0, yy, KViewWidth, 1)];
    [separatView setBackgroundColor:HWColor(230, 230, 230)];
    return separatView;
}

- (void)setViewTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setHidden:(BOOL)isHidden {
    if (isHidden) {
        [UIView animateWithDuration:.3 animations:^{
            self.frame = CGRectMake(0, KScreenHeight, KViewWidth, KViewHeight);
        }];
    }else {
        [UIView animateWithDuration:.3 animations:^{
            self.frame = CGRectMake(0, 0, KViewWidth, KViewHeight);
        }];
    }
    
}
- (void)cancelAction {
    [self setHidden:YES];
}

- (void)sureAction {
    [self setHidden:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [self.delegate getTime:[dateFormatter stringFromDate:_datePick.date]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
