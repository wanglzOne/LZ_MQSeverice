//
//  NormalAlertView.m
//  ALATaxi
//
//  Created by  YiDaChuXing on 17/1/13.
//  Copyright © 2017年 com.jiangjiaxiang. All rights reserved.
//

#import "NormalAlertView.h"

@interface NormalAlertView ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSArray *subTitles;

@property (strong, nonatomic) NSArray <NSNumber *>*invalIndexs;


@property (copy, nonatomic) ClickTitleBlcok block;

@end

@implementation NormalAlertView
+ (instancetype)showAlertViewForsubTitles:(NSArray *)subTitles invalIndexs:(NSArray <NSNumber *>*)invalIndexs andClickTitleBlcok:(ClickTitleBlcok)block
{
    if (!subTitles.count) {
        return nil;
    }
    NormalAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"NormalAlertView" owner:nil options:nil][0];
    view.tableView.delegate = view;
    view.invalIndexs = invalIndexs;
    view.tableView.dataSource = view;
    view.frame = [UIScreen mainScreen].bounds;
    view.isDefaultClickIndexToHide = YES;
    if (subTitles.count*44 > [UIScreen mainScreen].bounds.size.height/2) {
        [view.contentViewHeight setConstant:[UIScreen mainScreen].bounds.size.height/2];
    }else
    {
        [view.contentViewHeight setConstant:44.0 * subTitles.count];
    }
    view.subTitles  =subTitles;
    
    view.block = block;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(gestureAction)];
    [view.bgView addGestureRecognizer:gesture];
    
    [view.tableView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}
+ (instancetype)showAlertViewForsubTitles:(NSArray *)subTitles andClickTitleBlcok:(ClickTitleBlcok)block
{
    return [self showAlertViewForsubTitles:subTitles invalIndexs:nil andClickTitleBlcok:block];
    if (!subTitles.count) {
        return nil;
    }
    NormalAlertView *view = [[NSBundle mainBundle] loadNibNamed:@"NormalAlertView" owner:nil options:nil][0];
    view.tableView.delegate = view;
    view.tableView.dataSource = view;
    view.frame = [UIScreen mainScreen].bounds;
    view.isDefaultClickIndexToHide = YES;
    if (subTitles.count*44 > [UIScreen mainScreen].bounds.size.height/2) {
        [view.contentViewHeight setConstant:[UIScreen mainScreen].bounds.size.height/2];
    }else
    {
        [view.contentViewHeight setConstant:44.0 * subTitles.count];
    }
    view.subTitles  =subTitles;
    
    view.block = block;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(gestureAction)];
    [view.bgView addGestureRecognizer:gesture];
    
    [view.tableView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.subTitles[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    for (NSNumber *num in self.invalIndexs) {
        if (indexPath.row == [num integerValue]) {
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isExist = NO;
    if (self.block) {
        for (NSNumber *num in self.invalIndexs) {
            if (indexPath.row == [num integerValue]) {
                //cell.textLabel.textColor = [UIColor grayColor];
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            self.block(indexPath.row,self.subTitles[indexPath.row]);
        }
    }
    
    if (self.isDefaultClickIndexToHide && !isExist) {
        [self hidePop];
    }
    
    
    
}




- (void)gestureAction
{
    [self hidePop];
}

- (void)hidePop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.delegate = nil;
        self.tableView.dataSource = nil;
        [self removeFromSuperview];
    });
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
