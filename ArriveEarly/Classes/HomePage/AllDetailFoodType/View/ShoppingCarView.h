//
//  ShoppingCarView.h
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingCarViewDelegate <NSObject>

-(void)refreshControllerView;
-(void)backRefresh;

@end

@interface ShoppingCarView : UIView

@property(weak ,nonatomic)UIViewController *vc;
@property (nonatomic ,assign)BOOL isActivity;//是否是活动进入的 YES是 NO不是
@property (weak, nonatomic) IBOutlet UILabel *waitPayprice;
@property (weak, nonatomic) IBOutlet UILabel *boxFee;

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,assign)id<ShoppingCarViewDelegate>delegate;

+(instancetype)initCustomView;


@property (nonatomic ,assign) double totalMoney;



- (void)reloadData;
- (void)isHidden:(BOOL ) isHidden;
@end
