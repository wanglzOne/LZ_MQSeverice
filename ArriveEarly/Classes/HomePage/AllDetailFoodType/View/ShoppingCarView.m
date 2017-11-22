//
//  ShoppingCarView.m
//  ArriveEarly
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ShoppingCarView.h"
#import "ShoppingCarTableViewCell.h"
#import "OrderSettlementViewController.h"
#import "ProductTypeModel.h"

@interface ShoppingCarView()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{

}
@property (nonatomic ,strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)UIButton *backGroundBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToThebottom;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIButton *settlementButton;

@end

@implementation ShoppingCarView

- (void)dealloc
{
    DLogMethod();
}

+(instancetype)initCustomView
{
    return [[NSBundle mainBundle]loadNibNamed:@"ShoppingCarView" owner:self options:nil].lastObject;
}


-(void)reloadData
{
    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    self.dataSource = [manager getLcationData];
    self.redLabel.text = [NSString stringWithFormat:@"%ld",self.dataSource.count];
    float size = self.dataSource.count * 50;
    float height = size < 50 *6 ? size : 50 *6;
    //拿到数据加载界面
    if (self.tableView) {
        self.tableView.frame = CGRectMake(0, self.bounds.size.height - 46 - height, KScreenWidth, height);
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 46 - height, KScreenWidth, height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCarTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCarTableViewCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
        [self addSubview:self.tableView];
    }
    self.topToThebottom.constant = height;
    _totalMoney = manager.totalPrice;
    self.waitPayprice.text = MoneySymbol(_totalMoney);
    [self configSettlementButton];
}
//清空购物车操作
- (IBAction)cleanShoppingCarAction:(UIButton *)sender {
    NSLog(@"清空购物车~");
    UIAlertView *show = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清空购物车!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [show show];
    
}
#pragma mark------UIAlertViewDelegate-------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

        NSLog(@"点击的是确定");
        ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
        [manager removeLocationData];
        _totalMoney = 0;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"deletCar" object:nil];
        [UIView animateWithDuration:1.5 animations:^{
            [self isHidden:YES];
            [self.delegate refreshControllerView];
            
            
        }];
        [self configSettlementButton];
    }
}

- (IBAction)shoppingCarBtnAction:(UIButton *)sender {
    
    [UIView animateWithDuration:1.5 animations:^{
        [self isHidden:YES];
        
        [self.delegate backRefresh];
    }];
    [self configSettlementButton];

}
- (IBAction)settleAcountBtnAction:(UIButton *)sender {
    
    [OrderSettlementViewController changeFormeViewController:self.vc onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
    }];
    
}



- (IBAction)backGroundBtn:(UIButton *)sender {
    [UIView animateWithDuration:1.5 animations:^{
        [self isHidden:YES];
        [self.delegate backRefresh];
    }];
}



#pragma mark -------UITableViewDelegateDataSource-------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"ShoppingCarTableViewCell";
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ShoppingCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.model = self.dataSource[indexPath.row];
    cell.plus.tag = indexPath.row +1000;
    cell.minus.tag = indexPath.row +2000;
    [cell.plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)plusAction:(UIButton*)sender
{
    NSInteger index = sender.tag - 1000;
    ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    ProductModel* model = self.dataSource[index];
    ShoppingCarManager *mananger = [ShoppingCarManager sharedManager];
    
    
    [mananger saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:model.activityConfigModel onComplete:^(BOOL isFlag, NSError *error) {
        if (error) {
            [self showPopupErrorMessage:error.domain];
            return ;
        }
        cell.productCount.text = [NSString stringWithFormat:@"%d",[cell.productCount.text intValue] + 1];
        //[mananger saveProduct:model andChangeAdditionalCopies:1 andProductConfig:nil];
        self.dataSource = mananger.productData;
        [self reloadData];
    }];
    
}
-(void)minusAction:(UIButton*)sender
{
    NSInteger index = sender.tag - 2000;
    ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.productCount.text = [NSString stringWithFormat:@"%d",[cell.productCount.text intValue] - 1];
    NSLog(@"______cell.productCount.text is %@",cell.productCount.text);
    int count = [cell.productCount.text intValue];
    NSLog(@" ______count   is   %d",count);
    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:-1 andProductConfig:nil];
    if (count <= 0) {
        [self reloadData];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDetail" object:nil];
    }
    if (manager.productData <= 0) {
        [self isHidden:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"haveNoData" object:nil];
    }
    [self reloadData];
}


- (void)configSettlementButton
{
    if (self.totalMoney>=[ArriveEarlyManager shared].areaStoreInfo.startPrice) {
        [self.settlementButton setTitle:@"去结算" forState:UIControlStateNormal];
        [self.settlementButton setBackgroundColor:HWColor(253, 213, 3) forState:UIControlStateNormal];
    }else
    {
        [self.settlementButton setTitle:[NSString stringWithFormat:@"差%@起送",MoneySymbol([ArriveEarlyManager shared].areaStoreInfo.startPrice-self.totalMoney)] forState:UIControlStateNormal];
        [self.settlementButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }

}
- (void)isHidden:(BOOL ) isHidden
{
    [self setHidden:isHidden];
}



@end
