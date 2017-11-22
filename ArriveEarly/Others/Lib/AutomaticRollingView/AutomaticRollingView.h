//
//  AutomaticRollingView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/30.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutomaticRollingView : UIView

- (instancetype) initWithFrame:(CGRect)frame WithNetImageUrls:(NSArray *)imageUrls localPlaceholderImages:(NSArray *)placeholderImageNames;
@property (nonatomic, assign) NSTimeInterval autoScrollDelay;   //滚动延时

- (void)removeTimer;
- (void)setUpTimer;


- (void)refreshWithNetImageUrls:(NSArray *)imageUrls localPlaceholderImages:(NSArray *)placeholderImageNames;

@end
