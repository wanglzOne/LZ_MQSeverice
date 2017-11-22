//
//  BaseTableView.m
//  TS
//
//  Created by Apple on 16/1/19.
//  Copyright © 2016年 陈彬. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger clickIndex;
}
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *cellImgAry;
@end

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        clickIndex = -1;
        _cellArray = [NSMutableArray array];
        _cellImgAry = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}

#pragma mark -------------------- UI

- (void)initView {
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = KHEIGHT_6(44);
    //self.scrollEnabled = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark ------------- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell addSubview:[PackagMet getSeparatView:KHEIGHT_6(43)]];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(KHEIGHT_6(15), KHEIGHT_6(12), KHEIGHT_6(20), KHEIGHT_6(20))];
        [cell.contentView addSubview:imgView];
        imgView.tag = indexPath.row + 100;
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KHEIGHT_6(44), 0, KHEIGHT_6(200), KHEIGHT_6(44))];
       
        label.tag = 10000 + indexPath.row;
        label.textColor = UIColorFromRGBA(0x333333, 1);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
    }
    UIImageView *imgView = [cell.contentView viewWithTag:indexPath.row + 100];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[_cellImgAry[indexPath.row] imageUrl]] placeholderImage:[UIImage imageNamed:@"man"]];
    
    UILabel *textLabel = [cell.contentView viewWithTag:indexPath.row + 10000];
    if (indexPath.row == clickIndex) {
        textLabel.textColor = [UIColor redColor];
    }else {
        textLabel.textColor = UIColorFromRGBA(0x333333, 1);
    }
    textLabel.text = [_cellArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    clickIndex = indexPath.row;
    if (self.eventDelegate && [self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectIndexPath:indexPath];
    }
    [self setHidden:YES];
}

#pragma mark -------------------- reloadData

- (void)reloadData:(NSArray *)cellArray ImageURLAry:(NSArray *)imgURLAry{
    [_cellArray removeAllObjects];
    [_cellArray addObjectsFromArray:cellArray];
    [_cellImgAry removeAllObjects];
    [_cellImgAry addObjectsFromArray:imgURLAry];
    [self reloadData];
}

- (void)scrollEnabled:(BOOL)isScroll {
    self.scrollEnabled = isScroll;
}

- (void)isHidden:(BOOL ) isHidden {
    [self setHidden:isHidden];
}
@end
