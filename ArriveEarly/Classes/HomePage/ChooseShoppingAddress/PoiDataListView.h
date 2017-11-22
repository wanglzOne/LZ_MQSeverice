//
//  PoiDataListView.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/25.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PoiDataListView;
@protocol PoiDataListViewDelegate <NSObject>

- (void)poiDataListView:(PoiDataListView *)dataListView didIndexRow:(NSInteger)row didInfo:(id)info;

@end


@interface PoiDataListView : UIView
+ (instancetype)loadXIB;
@property (weak, nonatomic) id<PoiDataListViewDelegate>delegate;
- (void)configUI;
- (void)reloadForData:(NSArray *)dataArray;

@end
