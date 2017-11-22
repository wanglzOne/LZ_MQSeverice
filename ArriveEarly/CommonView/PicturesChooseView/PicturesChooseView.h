//
//  PicturesChooseView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PicturesChooseView;
@protocol PicturesChooseViewDelegate <NSObject>

- (void)picturesChooseView:(PicturesChooseView *)picturesChooseView uploadUIForPicturesChooseViewHeight:(CGFloat )contentHeight;

- (void)picturesChooseView:(PicturesChooseView *)picturesChooseView uploadImage:(UIImage *)image forIndex:(NSInteger)index;

@end

@interface PicturesChooseView : UIView
@property (nonatomic, assign)  int maxImage;
@property (nonatomic, weak) UIViewController *superVC;

@property (nonatomic, strong, readonly) NSMutableArray *images;

@property (nonatomic, weak) id<PicturesChooseViewDelegate>delegate;

- (void)setImageDatas:(NSMutableArray <UIImage *>*)datas;



@end
