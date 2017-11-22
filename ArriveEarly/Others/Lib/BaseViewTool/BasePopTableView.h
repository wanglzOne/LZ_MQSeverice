//
//  BasePopTableView.h
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BasePopTableView <NSObject>

- (void)popView:(UITableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath;
-(void)clickBackGroundBtn:(UIButton*)btn;
@end

@interface BasePopTableView : UIView

@property (nonatomic, strong) NSArray *imgArray;

- (void)loadTableView;
- (void)updateTableViewHeight;

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UIButton *backGroundBtn;
@property (nonatomic, assign) id <BasePopTableView> delegate;

@property (nonatomic, assign) BOOL isSortCategory;


+(instancetype)initCustomView;



- (void)reloadData:(NSArray *)cellArray;
- (void)isHidden:(BOOL ) isHidden;
- (void)refreshUI;
@end
