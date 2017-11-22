//
//  AllOrderView.m
//  早点到APP
//
//  Created by m on 16/9/26.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "AllOrderView.h"
#import "OrderTableViewCell.h"
#import "DetailsOrderViewController.h"
@interface AllOrderView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *DataSource;

@end

@implementation AllOrderView

+(instancetype)initCustomView {
    return [[NSBundle mainBundle]loadNibNamed:@"AllOrderView" owner:self options:nil].lastObject;
}

-(void)awakeFromNib{
    [self initData];
    [self initInterFace];
}
-(void)initData
{
    self.DataSource = [[NSMutableArray alloc] init];
}
-(void)initInterFace
{
    [_tableView setBackgroundColor:[UIColor yellowColor]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 153) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
}
- (void)initGetDataWithAry:(NSMutableArray *)ary
{
    [self.DataSource removeAllObjects];
    [self.DataSource addObjectsFromArray:ary];
    [self.tableView reloadData];
}

#pragma mark -------------------- UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    if (cell == nil) {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderTableViewCell"];
        NSArray *Ary = [[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell = [Ary objectAtIndex:0];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsOrderViewController *vc = [[DetailsOrderViewController alloc]init];
    
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    
    UIViewController *superController = (UIViewController*)object;
    [superController.navigationController pushViewController:vc animated:YES];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
