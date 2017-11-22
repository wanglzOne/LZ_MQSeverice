//
//  DetailsOrderViewController.m
//  早点到APP
//
//  Created by m on 16/9/21.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "DetailsOrderViewController.h"
#import "BaseScrollView.h"
#import "OrderDetailView.h"
#import "OrderStateView.h"

#import "OrderSettlementViewController.h"
#import "PayViewController.h"
#import "OrderEvaluationViewController.h"
#import "NewOrderEvaluationViewController.h"
#import "ClosingTimeView.h"

@interface DetailsOrderViewController ()<BaseScrollViewDelegate,DetailsOrderViewPperationDelegate>

@property (nonatomic, strong) BaseScrollView *footView;
@property (nonatomic,strong) OrderDetailView *orderDetailView;
@property (nonatomic,strong) OrderStateView *orderStateView;
@property (nonatomic, strong) NSMutableArray *subViewsAry;
@property (nonatomic, strong) NSMutableArray *subViewTitleAry;
@end

@implementation DetailsOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.cusNavView.titleLabel.text = @"我的订单";
    [self.cusNavView createRightButtonWithTitle:nil image:[UIImage imageNamed:@"call"] target:self action:@selector(texPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    //self.cusNavView.leftButton
    
    if (!self.orderInfo && !self.orderID) {
        return;
    }
    
    if (!self.orderInfo && self.orderID) {
        kShowProgress(self);
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findBookDetail" url_ex] params:@{@"orderId" : self.orderID} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            kHiddenProgress(self);
            if (error) {
                [self.view showPopupErrorMessage:error.domain];
                return ;
            }
            
            NSDictionary *dict = responseObject;
            if ([dict[@"responseData"] isKindOfClass:[NSDictionary class]]) {
                self.orderInfo = [OrderMessageModelInfo special_yy_modelWithDictionary:dict[@"responseData"]];
                if (self.orderInfo.orderProducts.count) {
                    [self loadMY];
                }else
                {
                    [self.view showPopupErrorMessage:@"获取商品失败了"];
                }
            }
            else{
                [self.view showPopupErrorMessage:@"请求失败，请检查您的网络"];
            }
        }];
    }else
    {
        [self loadMY];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.orderStateView.mapView clear];
}

- (void)loadMY
{
    [self initData];
    [self initInterFace];
    self.orderStateView.delegate = self;
    self.orderDetailView.delegate = self;
    self.orderID = self.orderInfo.orderId;
    [self.orderStateView configWithOrderMessageModelInfo:self.orderInfo superVC:self];
    [self.orderDetailView configWithOrderMessageModelInfo:self.orderInfo superVC:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.orderStateView.mapView viewWillAppear];
    //[self.orderStateView refreshUI];
}

- (void)texPhoneNumber
{
    [UIAlertController showInViewController:self withTitle:@"提示" message:KProductPhoneNumber preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"呼叫"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",KProductPhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
}


-(void)initData
{
    self.subViewTitleAry = [[NSMutableArray alloc] initWithObjects:@"订单跟踪",@"订单详情", nil];
    self.orderDetailView = [OrderDetailView initCustomView];
    self.orderStateView = [OrderStateView initCustomView];
    if (self.orderID) {
        self.orderDetailView.heightForHeaderInSectionOne = 0.01;
        self.orderStateView.heightForHeaderInSectionOne = -KHEIGHT_6(30.0);
    }
    self.subViewsAry = [[NSMutableArray alloc]initWithObjects:self.orderStateView,self.orderDetailView, nil];
}
-(void)initInterFace
{
    
    self.footView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 65.5, KScreenWidth, KScreenHeight-65.5)];
    self.footView.delegate = self;
    [self.footView setSubViewOfScrollerView:_subViewsAry];
    self.footView.width_moveView = KHEIGHT_6(100.0);
    [self.footView moveViewBgView:self.view.backgroundColor];
    [self.footView setViewsTitle:_subViewTitleAry];
    [self.view addSubview:self.footView];
    
//    [self.orderStateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.footView.scrollerView.mas_bottom);
//        make.left.equalTo(self.footView.scrollerView.mas_left);
//        make.height.equalTo(@(KScreenHeight-65.5));
//        make.width.equalTo(@(KScreenWidth));
//    }];
    
    
}

#pragma mark --- BaseScrollViewDelegate
- (void)initBaseScrollViewSelectPageNum:(NSInteger)pageNum
{
    if (pageNum == 0) {
        //[self.orderStateView refreshUI];
    }else
    {
        //右上角 有一个拨打电话的按钮
        //[self.orderDetailView refreshUI];
    }
}


#pragma mark - DetailsOrderViewPperationDelegate
- (void)settlementOrderforTargetView:(UIView *)targetView
{
    if (self.orderInfo.booksInfo.orderStatus == OrderStatus_waitePay) {
        //@"支付";
        [PayViewController changefromeVC:self andOrderInfo:self.orderInfo onComplete:^(UIViewController *targetVienController, id changeContent) {
            [targetVienController.navigationController popViewControllerAnimated:YES];
            //刷新页面信息
        }];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish && self.orderInfo.booksInfo.isEva <= 0)
    {
        //去评价
//        OrderEvaluationViewController *detail = [[OrderEvaluationViewController alloc] initWithNibName:@"OrderEvaluationViewController" bundle:nil];
//        detail.orderInfo = self.orderInfo;
//        [self.navigationController  pushViewController:detail animated:YES];
        NewOrderEvaluationViewController *detail = [[NewOrderEvaluationViewController alloc] initWithNibName:@"NewOrderEvaluationViewController" bundle:nil];
        detail.orderInfo = self.orderInfo;
        [self.navigationController  pushViewController:detail animated:YES];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish && self.orderInfo.booksInfo.isEva > 0)
    {
        //@"在来一单";
        [OrderSettlementViewController changeFormeViewController:self order:self.orderInfo onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
            
        }];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish ||self.orderInfo.booksInfo.orderStatus ==  OrderStatus_payTimeOut ||self.orderInfo.booksInfo.orderStatus ==  OrderStatus_waiteMake ||self.orderInfo.booksInfo.orderStatus ==  OrderStatus_makeing || self.orderInfo.booksInfo.orderStatus ==  OrderStatus_distributing || self.orderInfo.booksInfo.orderStatus ==  OrderStatus_canceling || self.orderInfo.booksInfo.orderStatus ==  OrderStatus_canceled || self.orderInfo.booksInfo.orderStatus ==  OrderStatus_abnormal || self.orderInfo.booksInfo.orderStatus ==  OrderStatus_evaluated ||  self.orderInfo.booksInfo.orderStatus == OrderStatus_areadlyFinish)
    {
        [self CloseToJudge];
        //@"在来一单";
        [OrderSettlementViewController changeFormeViewController:self order:self.orderInfo onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
            
        }];
        
    }
    /*
     OrderEvaluationViewController *detail = [[OrderEvaluationViewController alloc] initWithNibName:@"OrderEvaluationViewController" bundle:nil];
     detail.orderInfo = self.orderInfo;
     [self.navigationController  pushViewController:detail animated:YES];
    
     */
}

-(void)CloseToJudge{
    [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *error) {
        
        if (areaStoreInfo && areaStoreInfo.isOpen==0) {
            [[ClosingTimeView initCustomView] show_custom];
//            return ;
        }
        
    }];
    
}

- (void)againOrderforTargetView:(UIView *)targetView
{
    
}


- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
