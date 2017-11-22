//
//  SearchProductView.m
//  ArriveEarly
//
//  Created by m on 2016/11/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "SearchProductView.h"
#import "SearchProductTableViewCell.h"
#import "SearchResultViewController.h"
@interface SearchProductView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchProductView

+(instancetype)initCustomView
{
    return [[NSBundle mainBundle]loadNibNamed:@"SearchProductView" owner:self options:nil].lastObject;
}
-(void)reloadData
{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchProductTableViewCell"];
    
    
}
#pragma mark ------UITableViewDelegate--------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifer = @"SearchProductTableViewCell";
    SearchProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[SearchProductTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataSource[indexPath.row] yy_modelToJSONObject];
    NSString *str = dic[@"productName"];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchResultViewController *vc = [[SearchResultViewController alloc]init];
    vc.searchName = str;
    [self.vc.navigationController pushViewController:vc animated:YES];
    [self isHidden:YES];
    
    
}

-(void)isHidden:(BOOL)isHidden
{
    [self setHidden:isHidden];
}

@end
