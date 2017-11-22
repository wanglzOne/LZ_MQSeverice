//
//  CellDetailsViewController.h
//  ArriveEarly
//
//  Created by m on 2016/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 菜品详情
 */
@interface CellDetailsViewController : UIViewController

@property (nonatomic,strong) ActivityConfigModel *activityConfig;


@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger index;




@property (nonatomic ,assign) BOOL isActivity;
@property (nonatomic ,assign) BOOL isStart;//活动商品进入判断能否加入购物车

@end
