//
//  PoiDataListView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/25.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PoiDataListView.h"

@interface PoiDataListView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation PoiDataListView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    [self.bgView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    
}

+ (instancetype)loadXIB
{
    PoiDataListView *vi = [[NSBundle mainBundle] loadNibNamed:@"PoiDataListView" owner:nil options:nil][0];
    return vi;
}

- (void)configUI
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)reloadForData:(NSArray *)dataArray
{
    //BMKPoiInfo
    self.dataArray = dataArray;
    [self.tableView reloadData];
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = info.address;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPoiInfo *info = self.dataArray[indexPath.section];
    if ([self.delegate respondsToSelector:@selector(poiDataListView:didIndexRow:didInfo:)]) {
        [self.delegate poiDataListView:self didIndexRow:indexPath.row didInfo:info];
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
