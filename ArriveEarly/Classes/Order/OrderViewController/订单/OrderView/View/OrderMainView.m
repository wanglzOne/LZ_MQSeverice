//
//  OrderMainView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderMainView.h"

#import "OrderMessageTableViewCell.h"
#import "DetailsOrderViewController.h"
#import <MJRefresh.h>
#import "OrderEvaluationViewController.h"
#import "PayViewController.h"

#import "OrderSettlementViewController.h"

#import "NewOrderEvaluationViewController.h"

@interface OrderMainView ()<UITableViewDelegate, UITableViewDataSource, OrderMessageTableViewCellDelegate>
{
    NSMutableDictionary *heightDict;
    PageHelper *page;
    OrderMainViewSate viewState;
}
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation OrderMainView

+ (instancetype)loadNib
{
    OrderMainView *view = [[NSBundle mainBundle] loadNibNamed:@"OrderMainView" owner:nil options:nil][0];
    return view;
}

- (void)config
{
    self.dataArray = [[NSMutableArray alloc] init];
    heightDict = [[NSMutableDictionary alloc] init];;
//    [self.tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:@"Message"];
    self.dataArray = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadNormalStateData];
    
}

- (void)logOut
{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)reloadTableVviewForState:(OrderMainViewSate)state
{
    viewState = state;
    self.tableView.editing = state;
//    [self.tableView reloadData];
}

- (void)loadNormalStateData
{
    WEAK(weakSelf);
    
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }
    
    if (!self.tableView.mj_header) {
        
        self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
}

- (void)refreshUI
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefresh
{
    //self.dataArray = [[NSMutableArray alloc] init];
    page = [[PageHelper  alloc] init];
    [self request];
}

- (void)footerRefresh
{
    [page add];
    [self request];
}

- (void)request
{
    if (![ArriveEarlyManager shared].userLogData.userToken.length) {
        [self showPopupErrorMessage:@"请登录..."];
        return;
    }
    WEAK(weakSelf);
//    [self showPopupLoading];
    if (viewState == OrderMainViewSate_editing) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        return;
    }
    
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[self.baseUrl url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        [weakSelf hidePopupLoadingAnimated:YES];
        STRONG(strong_weakSelf, weakSelf);
        if (error) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            }
            
            [strong_weakSelf->page falseAdd];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf showPopupErrorMessage:error.domain];
            return ;
        }
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSDictionary *dataDict = responseObject;
        NSArray *arr = dataDict[@"responseData"];
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in arr) {
                if ([dict isKindOfClass:[NSDictionary class]])
                {
                    OrderMessageModelInfo *info = [OrderMessageModelInfo special_yy_modelWithDictionary:dict];
                    if ([info.orderProducts isKindOfClass:[NSArray class]] && info.orderProducts.count>0) {
                        [array addObject:info];
                    }
                }
            }
        }
        
        
        if (array) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
        }
        [weakSelf.tableView reloadData];

        if (weakSelf.dataArray.count < strong_weakSelf->page.total) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [weakSelf.tableView.mj_footer resetNoMoreData];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark ---------UITableViewDelegateDataSource-----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHEIGHT_6(10.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeight:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    // 编辑图标设定
    // 是删除还是增加
    if (viewState == OrderMainViewSate_editing) {
        OrderMessageModelInfo *info = self.dataArray[indexPath.section];
        if (!info.booksInfo.isAllowDelete) {
            return UITableViewCellEditingStyleNone;
        }
        return UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleNone;
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMessageModelInfo *info = self.dataArray[indexPath.section];
    [self showPopupLoading];
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"isDel" url_ex] params:@{@"orderId" : info.orderId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self hidePopupLoading];
        if (error) {
            [self showPopupErrorMessage:error.domain];
            return ;
        }
        [tableView setEditing:NO animated:YES];
        [self.dataArray removeObjectAtIndex:indexPath.section];
        [tableView reloadData];
        [self reloadTableVviewForState:OrderMainViewSate_editing];
    }];
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMessageModelInfo *info = self.dataArray[indexPath.section];
    NSString *identifier = [NSString stringWithFormat:@"Message%lu",(unsigned long)info.orderProducts.count + 1];
    OrderMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[OrderMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andModelData:info];
    }
    
    cell.showsReorderControl =YES;
    
    cell.delegate = self;
    cell.orderInfo = info;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderMessageModelInfo *info = self.dataArray[indexPath.section];
    //订单详情
    DetailsOrderViewController *detail = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
    detail.orderInfo = info;
    [self.superVC.navigationController  pushViewController:detail animated:YES];
}


- (void)tableViewCell:(UITableViewCell *)cell clickTypeButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderMessageModelInfo *orderInfo = self.dataArray[indexPath.section];
    if (orderInfo.booksInfo.orderStatus == OrderStatus_waitePay) {
        //@"支付";
        [PayViewController changefromeVC:self.superVC andOrderInfo:orderInfo onComplete:^(UIViewController *targetVienController, id changeContent) {
            [targetVienController.navigationController popViewControllerAnimated:YES];
            //刷新页面信息
        }];
    }
    else if (orderInfo.booksInfo.orderStatus == OrderStatus_finish)
    {
        OrderMessageTableViewCell *ocell = cell;
        if (button == ocell.evaluationBtn) {
            //@"去评价";
//            OrderEvaluationViewController *detail = [[OrderEvaluationViewController alloc] initWithNibName:@"OrderEvaluationViewController" bundle:nil];
//            detail.orderInfo = orderInfo;
//            [self.superVC.navigationController  pushViewController:detail animated:YES];
            
            
            
            NewOrderEvaluationViewController *detail = [[NewOrderEvaluationViewController alloc] initWithNibName:@"NewOrderEvaluationViewController" bundle:nil];
            detail.orderInfo = orderInfo;
            [self.superVC.navigationController  pushViewController:detail animated:YES];
        }else
        {
            //再来一单
            [OrderSettlementViewController changeFormeViewController:self.superVC order:orderInfo onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
                
            }];
        }
        
    }
    else if(orderInfo.booksInfo.orderStatus == OrderStatus_distributing)
    {
        if (button.tag == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要催单么？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击确定发送退款接口请求   add by luojian -2017-3-12
                 
                NSDictionary *dict = @{
                                       @"orderId":orderInfo.booksInfo.orderID
                                       };
                [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"orderHurry" url_ex] params:dict onCommonBlockCompletion:^(id responseObject, NSError *error) {
                    if ([responseObject[@"responseCode"] integerValue] == 1) {
                        UIAlertController *alertPrompt = [UIAlertController alertControllerWithTitle:@"提示" message:@"催单申请已成功提交，请耐心等候！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelPromptAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                        [alertPrompt addAction:cancelPromptAction];
                        
                        [self.superVC presentViewController:alertPrompt animated:YES completion:nil];
                        
                    }
                }];
            }];
            [alert addAction:okAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancelAction];
            [self.superVC presentViewController:alert animated:YES completion:nil];
            
        }
        //@"查看详情";
        OrderMessageModelInfo *info = self.dataArray[indexPath.section];
        //订单详情
        DetailsOrderViewController *detail = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
        detail.orderInfo = info;
        [self.superVC.navigationController  pushViewController:detail animated:YES];
    }
    
    else if(orderInfo.booksInfo.orderStatus == OrderStatus_waiteMake)
    {
        if (button.tag == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退款么？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击确定发送退款接口请求
                NSDictionary *dict = @{
                                       @"orderId":orderInfo.booksInfo.orderID
                                       };
                 [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"orderFeeback" url_ex] params:dict onCommonBlockCompletion:^(id responseObject, NSError *error) {
                     if ([responseObject[@"responseCode"] integerValue] == 1) {
                        UIAlertController *alertPrompt = [UIAlertController alertControllerWithTitle:@"提示" message:@"退款申请已成功提交，请耐心等候！" preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction *cancelPromptAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                         [alertPrompt addAction:cancelPromptAction];
                         
                         [self.superVC presentViewController:alertPrompt animated:YES completion:nil];
                         
                     }

                     
                 }];
                  
                
                
            }];
            [alert addAction:okAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancelAction];
            [self.superVC presentViewController:alert animated:YES completion:nil];
        
        }
        
        //@"查看详情";
        OrderMessageModelInfo *info = self.dataArray[indexPath.section];
        //订单详情
        DetailsOrderViewController *detail = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
        detail.orderInfo = info;
        [self.superVC.navigationController  pushViewController:detail animated:YES];

    }
    else
    {
        //@"查看详情";
        OrderMessageModelInfo *info = self.dataArray[indexPath.section];
        //订单详情
        DetailsOrderViewController *detail = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
        detail.orderInfo = info;
        [self.superVC.navigationController  pushViewController:detail animated:YES];
    }
    
}

- (CGFloat)getHeight:(NSIndexPath *)indexPath
{
    OrderMessageModelInfo *info = self.dataArray[indexPath.section];
    
    CGFloat height = [[heightDict objectForKey:@(info.orderProducts.count + 1)] floatValue];
    
    if (height <= 0) {
        height = KHEIGHT_6(100.0) + 2.0;
        height = height + 15.0*(info.orderProducts.count + 1) + 15.0*2  + ((info.orderProducts.count + 1) - 1) * 8;//2   info.orderProducts.count + 1  是因为有一个共多少商品显示
        [heightDict setObject:@(height) forKey:@(info.orderProducts.count + 1)];
    }
    return height;
}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
