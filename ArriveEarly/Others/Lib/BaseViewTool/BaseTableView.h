//
//  BaseTableView.h
//  TS
//
//  Created by Apple on 16/1/19.
//  Copyright © 2016年 陈彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath;

@end


@interface BaseTableView : UITableView

@property (nonatomic, assign) id <BaseTableViewDelegate> eventDelegate;

/*
 *  cellArray 为 Tableview 的数据源
 */

- (void)reloadData:(NSArray *)cellArray ImageURLAry:(NSArray *)imgURLAry;

- (void)scrollEnabled:(BOOL)isScroll;

- (void)isHidden:(BOOL ) isHidden;

@end
