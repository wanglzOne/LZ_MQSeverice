//
//  SearchProductView.h
//  ArriveEarly
//
//  Created by m on 2016/11/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchProductView : UIView
@property(weak ,nonatomic) UIViewController *vc;

@property (nonatomic ,strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


+(instancetype)initCustomView;
- (void)reloadData;
- (void)isHidden:(BOOL ) isHidden;
@end
