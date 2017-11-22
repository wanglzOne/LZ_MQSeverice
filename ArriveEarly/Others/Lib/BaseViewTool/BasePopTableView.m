//
//  BasePopTableView.m
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "BasePopTableView.h"
#import "BasePopTableViewCell.h"
@interface BasePopTableView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger clickIndex;
}

@end
@implementation BasePopTableView


+(instancetype)initCustomView
{
    return [[NSBundle mainBundle] loadNibNamed:@"BasePopTableView" owner:self options:nil].lastObject;
}
-(void)reloadData:(NSArray *)cellArray
{
    _cellArray = [[NSMutableArray alloc]init];
    [_cellArray addObjectsFromArray:cellArray];
    
    [self loadTableView];
    
    
    [self.tableView reloadData];
}
-(void)initInterFace
{
    [self loadTableView];
}

- (void)loadTableView
{
    CGFloat height = KHEIGHT_6(44) * self.cellArray.count;
    if (height > (KScreenHeight - KHEIGHT_6(200))/2) {
        height = (KScreenHeight - KHEIGHT_6(200))/2;
    }
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHEIGHT_6(15), KScreenWidth, height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = KHEIGHT_6(44);
        //self.tableView.scrollEnabled = NO;
        //        self.tableView.bounces = NO;
        [self.tableView registerNib:[UINib nibWithNibName:@"BasePopTableViewCell" bundle:nil] forCellReuseIdentifier:@"BasePopTableViewCell"];
        [self addSubview:self.tableView];
        self.backGroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height+KHEIGHT_6(15), KScreenWidth, self.bounds.size.height - self.tableView.frame.size.height)];
        self.backGroundBtn.backgroundColor = [UIColor blackColor];
        self.backGroundBtn.alpha = 0.3;
        [self.backGroundBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backGroundBtn];
    }
    self.tableView.frame = CGRectMake(0, KHEIGHT_6(15), KScreenWidth, height);
    self.backGroundBtn.frame = CGRectMake(0, self.tableView.frame.size.height+KHEIGHT_6(15), KScreenWidth, self.bounds.size.height - self.tableView.frame.size.height);
}
-(void)updateTableViewHeight{
    CGFloat height = KHEIGHT_6(44) * self.cellArray.count;
    if (height > (KScreenHeight - KHEIGHT_6(200))/2) {
        height = (KScreenHeight - KHEIGHT_6(200))/2;
    }
    self.tableView.frame = CGRectMake(0, KHEIGHT_6(15), KScreenWidth, height);
    self.backGroundBtn.frame = CGRectMake(0, self.tableView.frame.size.height+KHEIGHT_6(15), KScreenWidth, self.bounds.size.height - self.tableView.frame.size.height);
}
-(void)action{
    [self clickAction];
}
-(void)clickAction
{
    if ([self.delegate conformsToProtocol:@protocol(BasePopTableView)]) {
        [self.delegate clickBackGroundBtn:self.backGroundBtn];
        [self isHidden:YES];
    }
}

#pragma mark ----UItableViewDelegateDataSource----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasePopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasePopTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _cellArray[indexPath.row];
    if (self.isSortCategory) {
        cell.imgConstraint.constant = 10;
        [cell.image setHidden:NO];
        if (indexPath.row == 0) {//xiaoliang
            cell.image.image = [UIImage imageNamed:@"time"];
        }else if (indexPath.row == 1){
            cell.image.image = [UIImage imageNamed:@"xiaoliang"];
        }else if (indexPath.row == 2){
            cell.image.image = [UIImage imageNamed:@"haoping"];
        }
        else{
            cell.image.image = [UIImage imageNamed:@"haoping"];
        }
        
        /*else if (indexPath.row == 1){
            cell.image.image = [UIImage imageNamed:@"Price"];
        }else if (indexPath.row == 2){
            cell.image.image = [UIImage imageNamed:@"xiaoliang"];
        }
        else{
            cell.image.image = [UIImage imageNamed:@"haoping"];
        }*/

    }else{
        cell.imgConstraint.constant = -10;
        [cell.image setHidden:YES];
    }
    
    
    
    
    
    //    NSString *url = @"";
    //    if (indexPath.row < self.imgArray.count) {
    //        url = self.imgArray[indexPath.row];
    //    }
    //    [cell.image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"tbhr"]];//tbhr
    //typeAry
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    clickIndex = indexPath.row;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate popView:self.tableView didSelectIndexPath:indexPath];
    }
    [self setHidden:YES];
}


-(void)isHidden:(BOOL)isHidden
{
    [self setHidden:isHidden];
}

-(void)refreshUI{
    [self.tableView reloadData];
    [self updateTableViewHeight];
}

@end
