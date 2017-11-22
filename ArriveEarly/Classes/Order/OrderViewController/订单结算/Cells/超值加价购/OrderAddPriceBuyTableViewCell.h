//
//  OrderAddPriceBuyTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderAddPriceBuyTableViewCell;

@protocol OrderAddPriceBuyDelegate <NSObject>

- (void)updateHeadConfigData:(NSArray<AddPricetoBuyConfigInfo*> *)headArray andDataArray:(NSDictionary<id,NSArray<AddPricetoBuyInfo*>*> *)dataDict tableViewCell:(OrderAddPriceBuyTableViewCell *)cell;
@end

@interface OrderAddPriceBuyTableViewCell : UITableViewCell

//- (void)createUIWith:(NSArray *)headArray andDataArray:(NSArray *)dataArray;

@property (nonatomic, strong) NSArray <AddPricetoBuyInfo *>*dataArray;

@property (nonatomic, weak) id<OrderAddPriceBuyDelegate>delegate;

@end
