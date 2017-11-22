//
//  OrderStateView.m
//  早点到APP
//
//  Created by m on 16/9/26.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "OrderStateView.h"
#import <MJRefresh.h>
#import "OrderStateTableViewCell.h"
#import "OrderSettlementViewController.h"
#import "OrderStateShareTableViewCell.h"
#import "OrderStateMapTableViewCell.h"
#import "AEShareMainView.h"
#import "OrderStateFinishTableViewCell.h"
#import "ShowExpAddressViewController.h"

@interface OrderStateView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@property (weak, nonatomic) UIViewController *superViewController;

@property (strong, nonatomic) NSMutableArray <OrderStateInfo*>*dataArray;
/*
 empId = 18228106168;
 empLat = "30.5917700";
 empLon = "104.0611300";
 */
@property (strong, nonatomic) NSMutableDictionary *expNewPositionData;


@end

@implementation OrderStateView
+(instancetype)initCustomView
{
    return [[NSBundle mainBundle] loadNibNamed:@"OrderStateView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.heightForHeaderInSectionOne = 0.01;
    [self.operationButton setBackgroundColor:CUS_Nav_bgColor forState:UIControlStateNormal];
}

- (void)configWithOrderMessageModelInfo:(OrderMessageModelInfo *)info superVC:(UIViewController*)superVC
{
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.superViewController = superVC;
    self.orderInfo = info;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderStateTableViewCell" bundle:nil] forCellReuseIdentifier:@"StateCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderStateShareTableViewCell" bundle:nil] forCellReuseIdentifier:@"StateShareCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderStateFinishTableViewCell" bundle:nil] forCellReuseIdentifier:@"StateFinishell"];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"OrderStateMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"StateMapCell"];

    
    [self loadNormalStateData];
    
    [self refreshUI];
    self.operationButton.hidden = YES;
    
    if (_heightForHeaderInSectionOne < 0) {
        //self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(_heightForHeaderInSectionOne, 0, 0, 0);
    }
}

- (void)loadNormalStateData
{
    WEAK(weakSelf);
    
    if (!self.tableView.mj_header) {
        
        self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
    
}
- (void)refreshUI
{
    [self.tableView.mj_header beginRefreshing];
    self.operationButton.hidden = NO;
    if (self.orderInfo.booksInfo.orderStatus == OrderStatus_waitePay) {
        //@"支付";
        [self.operationButton setTitle:@"立即支付" forState:UIControlStateNormal];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish && self.orderInfo.booksInfo.isEva <= 0)
    {
        [self.operationButton setTitle:@"去评价" forState:UIControlStateNormal];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish && self.orderInfo.booksInfo.isEva > 0)
    {
        [self.operationButton setTitle:@"再来一单" forState:UIControlStateNormal];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_areadlyFinish)
    {
        [self.operationButton setTitle:@"再来一单" forState:UIControlStateNormal];
    }
    else
    {
        [self.operationButton setTitle:@"再来一单" forState:UIControlStateNormal];
    }
    
}
- (void)headerRefresh
{
    [self updateExpNewPosition];
    
    //orderInfo  根据ID 进行 请求 详情
    [self.superViewController.view showPopupLoading];
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findOrderState" url_ex] params:@{@"id" : self.orderInfo.orderId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.superViewController.view hidePopupLoadingAnimated:YES];
        if (error) {
            [self showPopupErrorMessage:error.domain];
            return;
        }
        NSDictionary *dict = responseObject;
        NSArray *data = dict[@"responseData"];
        if ([data isKindOfClass:[NSArray class]]) {
            
            [data sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                NSDictionary *a = (NSDictionary *)obj1;
                NSDictionary *b = (NSDictionary *)obj2;
                if (![a.allKeys containsObject:@"updateTime"] || ![a[@"updateTime"] isKindOfClass:[NSString class]] || ![b[@"updateTime"] isKindOfClass:[NSString class]]) {
                    return NSOrderedSame;
                }
                long long aNum = [a[@"updateTime"] longLongValue];
                long long bNum = [b[@"updateTime"] longLongValue];
                if (aNum > bNum) {
                    return NSOrderedDescending;
                }
                else if (aNum < bNum){
                    return NSOrderedAscending;
                }
                else {
                    return NSOrderedSame;
                }
            }];
            NSMutableArray *marray = [[NSMutableArray alloc] init];
            for (NSDictionary *datadict in data) {
                if ([datadict isKindOfClass:[NSDictionary class]]) {
                    OrderStateInfo *info = [OrderStateInfo yy_modelWithDictionary:datadict];
                    if ([info.orderId isEqualToString:self.orderInfo.orderId] && info.updateTime > 0) {
                        [marray addObject:info];
                    }
                }
            }
            if (marray.count > 0) {
                OrderStateInfo *info = [marray[0] yy_modelCopy];
                info.orderDescription = @"点击参与【邀请活动】";
                info.isShare = YES;
                [marray insertObject:info atIndex:1];
            }
            if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish || self.orderInfo.booksInfo.orderStatus == OrderStatus_evaluated || self.orderInfo.booksInfo.orderStatus == OrderStatus_areadlyFinish) {
                OrderStateInfo *info = [[OrderStateInfo alloc] init];
                info.orderDescription = @"订单完成";
                info.isShare = NO;
                [marray insertObject:info atIndex:marray.count];
            }
            
            
            self.dataArray = marray;
        }
        [self.tableView reloadData];
    }];
}
- (void)footerRefresh
{
    [self.tableView.mj_header beginRefreshing];
    
}



- (IBAction)operationButtonClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(settlementOrderforTargetView:)]) {
        [self.delegate settlementOrderforTargetView:self];
    }
    
}





#pragma mark ---------UITableViewDelegateDataSource-----------
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
//    return -30.0;
    return 0.01;
    return _heightForHeaderInSectionOne;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderStateInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    if (info.isShare) {
        return KHEIGHT_6(150);
    }
    if (info.orderState == OrderStatus_distributing && self.orderInfo.booksInfo.orderStatus == OrderStatus_distributing)
    {
        return 200.0;
    }
    return KHEIGHT_6(80.0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderStateInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    
    //地图cell
    if (info.orderState == OrderStatus_distributing && self.orderInfo.booksInfo.orderStatus == OrderStatus_distributing) {
        //显示地图
        OrderStateMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateMapCell" forIndexPath:indexPath];
       
        if (indexPath.row == 0) {
            cell.lineImage1.hidden = YES;
        }
        if (indexPath.row == self.dataArray.count-1) {
            cell.lineImage2.hidden = YES;
        }
        cell.label_time.text = [NSDate getTimeToLocaDatewith:@"MM-dd HH:mm" with:info.updateTime/1000];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"催单请拨:%@",self.orderInfo.booksInfo.expressId];
        NSLog(@"orderDescription===%@",info.orderDescription);
        cell.label_state.text = [NSString stringWithFormat:@"%@",info.orderDescription];
       cell.shareImage.image = [UIImage imageNamed:@""];
        cell.label_desc.userInteractionEnabled = YES;
        cell.btn_phone.hidden = YES;
        cell.label_desc.hidden = NO;
        cell.label_desc.text =[NSString stringWithString:str];
        [self.mapView setShowsUserLocationIsShow:YES];
        
        
        [cell.shareImage addSubview:self.mapView];
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(map_click:)];
       [cell.label_desc addGestureRecognizer:singleTap1];
        
        

        
        return cell;
    }
    
    
    //点击参与cell
    if (info.isShare) {
        OrderStateShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateShareCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.lineImage1.hidden = YES;
        }
        if (indexPath.row == self.dataArray.count-1) {
            cell.lineImage2.hidden = YES;
        }
        cell.shareImage.image = [UIImage imageNamed:@"Invite-new"];
        cell.label_time.text = [NSDate getTimeToLocaDatewith:@"MM-dd HH:mm" with:info.updateTime/1000];
        cell.label_state.text = [NSString stringWithFormat:@"%@",info.orderDescription];
        return cell;
    }
    //完成
    if (indexPath.row == self.dataArray.count - 1 && (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish || self.orderInfo.booksInfo.orderStatus == OrderStatus_evaluated  || self.orderInfo.booksInfo.orderStatus == OrderStatus_areadlyFinish)) {
        
        OrderStateFinishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateFinishell" forIndexPath:indexPath];
        
        return cell;
    }
    
    
    //支付部分cell
    OrderStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StateCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.lineImage1.hidden = YES;
    }
    if (indexPath.row == self.dataArray.count-1) {
        cell.lineImage2.hidden = YES;
    }
    cell.label_time.text = [NSDate getTimeToLocaDatewith:@"MM-dd HH:mm" with:info.updateTime/1000];
    cell.label_desc.text = [NSString stringWithFormat:@"%@",info.orderDescription];
    NSLog(@"支付部分cell====%@",info.orderDescription);
    cell.label_state.text = [NSString stringWithFormat:@"%@",info.orderDescription];
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderStateInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    //配送中
    if (info.orderState == OrderStatus_distributing && self.orderInfo.booksInfo.orderStatus == OrderStatus_distributing) {
        //拨打电话
        //  替换成info 中的电话号码，接口多返回一个电话号码
        
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.orderInfo.booksInfo.expressId];

//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        
        ShowExpAddressViewController *vc = [[ShowExpAddressViewController alloc] initWithNibName:@"ShowExpAddressViewController" bundle:nil];
        vc.orderInfo  =self.orderInfo;
        [self.superViewController.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    if (info.isShare) {
        [AEShareMainView showShareViewWith:AEShareTypeOrderDetail];
    }
}
//地图imageview点击
-(void)map_click:(UITapGestureRecognizer *)gestureRecognizer
{
//            ShowExpAddressViewController *vc = [[ShowExpAddressViewController alloc] initWithNibName:@"ShowExpAddressViewController" bundle:nil];
//            vc.orderInfo  =self.orderInfo;
//            [self.superViewController.navigationController pushViewController:vc animated:YES];
//
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.orderInfo.booksInfo.expressId];
    
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)updateExpNewPosition
{
    if (![self.orderInfo.booksInfo.expressId isKindOfClass:[NSString class]] || self.orderInfo.booksInfo.orderStatus != OrderStatus_distributing) {
        return;
    }
    [EncapsulationAFBaseNet updateExpNewPosition:self.orderInfo.booksInfo.expressId onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        self.expNewPositionData =  [responseObject[@"responseData"] copy];
        [self.tableView reloadData];
        if (self.expNewPositionData[@"empLat"] != (id)kCFNull && self.expNewPositionData[@"empLon"] != (id)kCFNull) {
            [self.mapView setPositonfor:CLLocationCoordinate2DMake([self.expNewPositionData[@"empLat"] doubleValue], [self.expNewPositionData[@"empLon"] doubleValue]) andImageName:@"expAddress"];
            

        }
    }];
}

- (CustomBaiDuMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[CustomBaiDuMapView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 56, 138)];//200
        [_mapView viewWillAppear];
    }
    return _mapView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
