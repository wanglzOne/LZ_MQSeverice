//
//  AESecondView.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一个枚举区分点击的按钮
typedef NS_ENUM (NSInteger, AECustomButtonType){
    UIButtonTypeMeiShi = 0,
    UIButtonTypeFengWei,
    UIButtonTypeXiaoChiJie,
    UIButtonTypeZaoDian,
    UIButtonTypeTianDian,
    UIButtonTypeJingCai,
    UIButtonTypeChaoSi,
    UIButtonTypeShangJiaYouHui
};
@protocol AESecondViewDelegate <NSObject>

//监听按钮的点击
-(void) buttonClickWhichOneWithNumber:(UIButton *) number;

@end

@interface AESecondView : UIView

@property(nonatomic, weak) id <AESecondViewDelegate>  delegate;

@property(nonatomic, assign) AECustomButtonType state;
@property (nonatomic, strong) NSMutableArray * secondClassIDArray;

-(instancetype) createSecondView;
-(void)getSecondData:(NSArray *)ary;

@end
