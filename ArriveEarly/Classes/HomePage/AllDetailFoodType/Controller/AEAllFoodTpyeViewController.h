//
//  AEAllFoodTpyeViewController.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 八大类二级页面
 */
@interface AEAllFoodTpyeViewController : UIViewController
@property (nonatomic, strong) NSString * ButtonTitle;
@property (nonatomic, strong) NSMutableArray *buttonAry;
@property (nonatomic ,strong)NSMutableArray *titleAry;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (strong ,nonatomic) NSString * classID;//八大分类id

@property (assign ,nonatomic)BOOL isChange;//热搜过来后改变让商品位置改变
@property (nonatomic ,strong) ProductModel *hotModel;

@property (nonatomic ,strong)NSMutableArray *imageURLAry;//八大类图标

@end
