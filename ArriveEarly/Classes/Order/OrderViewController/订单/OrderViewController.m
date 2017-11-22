//
//  OrderViewController.m
//  早点到APP
//
//  Created by m on 16/9/19.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "OrderViewController.h"
#import "BaseScrollView.h"
#import "AllOrderView.h"
#import "WaitPingjiaView.h"
#import "LoginViewController.h"
#import "OrderMainView.h"
#import "BaseScrollView.h"
#import "DetailsOrderViewController.h"
//   <BaseScrollViewDelegate>
@interface OrderViewController ()<BaseScrollViewDelegate>

/*********** 暂时不用的
@property (weak, nonatomic) IBOutlet UIButton *eidtbtn;//编辑按钮
@property (nonatomic, strong) BaseScrollView *footView;
@property (nonatomic,strong) AllOrderView *allOrderView;
@property (nonatomic,strong) WaitPingjiaView *waitPingjiaView;
@property (nonatomic, strong) NSMutableArray *subViewsAry;
@property (nonatomic, strong) NSMutableArray *subViewTitleAry;
@property (weak, nonatomic) IBOutlet UIView *containView;
**********/
/***********      available      *******/
{
    OrderMainView*mainView;
    
    OrderMainView*mainEvaluationView;
    NSString *changeOrderID;
}

@property (nonatomic, strong) BaseScrollView *footView;

@property (nonatomic, strong) PleaseLogInView *loginView;

@end

@implementation OrderViewController

//视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    

#ifdef DEBUG
    
    //[self.cusNavView createRightButtonWithTitle:@"提交订单" image:<#(UIImage *)#> target:<#(id)#> action:<#(SEL)#> forControlEvents:<#(UIControlEvents)#>]
    
#else
#endif
    
    
    
    /*
    [self initData];
    [self initInterFace];
    */
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addCustomNavigationWithTitle:@"订单"];
    
    self.cusNavView.backButton.hidden = YES;
    
    [self.cusNavView createRightButtonWithTitle:@"编辑" image:nil target:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cusNavView.rightButton setTitle:@"完成" forState:UIControlStateSelected];
    
    mainView = [OrderMainView loadNib];
    //[self.view addSubview:mainView];
    mainView.baseUrl = @"byUserIdBooks";
    mainView.superVC = self;
    [mainView config];
    mainEvaluationView = [OrderMainView loadNib];
    //[self.view addSubview:mainView];
    mainEvaluationView.superVC = self;
    [mainEvaluationView config];
    mainEvaluationView.baseUrl = @"queryNotEva";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:KLogOutSucess object:nil];
    
}
- (void)logOut
{
    [mainView logOut];
    [mainEvaluationView logOut];
    
    self.footView.hidden = YES;
    [self loadLogInView];
}

- (void)changetoDetailsOrderViewControllerWithOrderid:(NSString *)orderID
{
    changeOrderID = orderID;
//    DetailsOrderViewController *detail = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
//    detail.orderID = orderID;
//    [self.navigationController  pushViewController:detail animated:NO];
}

- (void)editAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    [mainView reloadTableVviewForState:(btn.selected? OrderMainViewSate_editing : OrderMainViewSate_Normal)];
    [mainEvaluationView reloadTableVviewForState:(btn.selected? OrderMainViewSate_editing : OrderMainViewSate_Normal)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    mainView.frame = CGRectMake(0, 64.0, KScreenWidth, KScreenHeight - 64.0 - 44.0);
    //mainEvaluationView.frame = CGRectMake(0, 64.0, KScreenWidth, KScreenHeight - 64.0 - 44.0);
    
    [ArriveEarlyManager loginSuccess:^{
        [self.loginView removeFromSuperview];
        self.footView.hidden = NO;
        [self initInterFace];
        [mainView refreshUI];
        [mainEvaluationView refreshUI];
        
        if (changeOrderID) {
            [self pushToDetailsOrderViewControllerWithOrderID:changeOrderID];
            changeOrderID = nil;
        }
        
        
    } fail:^{
        self.footView.hidden = YES;
        [self loadLogInView];
    }];
    
    
    
}
- (void)pushToDetailsOrderViewControllerWithOrderID:(NSString *)orderID
{
    if (!orderID) {
        return;
    }
    kShowProgress(self);
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findBookDetail" url_ex] params:@{@"orderId" : orderID} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(self);
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        OrderMessageModelInfo *orderInfo = nil;
        NSDictionary *dict = responseObject;
        if ([dict[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            orderInfo = [OrderMessageModelInfo special_yy_modelWithDictionary:dict[@"responseData"]];
            if (orderInfo.orderProducts.count) {
                DetailsOrderViewController *detail = [[DetailsOrderViewController alloc] initWithNibName:@"DetailsOrderViewController" bundle:nil];
                detail.orderInfo = orderInfo;
                [self.navigationController  pushViewController:detail animated:YES];
            }else
            {
                [self.view showPopupErrorMessage:@"获取商品失败了"];
            }
        }
        else{
            [self.view showPopupErrorMessage:@"请求失败，请检查您的网络"];
        }
    }];
}

-(void)initInterFace
{
    if (self.footView) {
        return;
    }
    NSMutableArray *subViewTitleAry = [[NSMutableArray alloc]initWithObjects:@"全部订单",@"待评价", nil];
    NSMutableArray *subViewsAry = [[NSMutableArray alloc]initWithObjects:mainView,mainEvaluationView, nil];
    self.footView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 65.5, KScreenWidth, KScreenHeight-65 - 44.0)];
    self.footView.delegate = self;
    [self.footView setSubViewOfScrollerView:subViewsAry];
    self.footView.width_moveView = KHEIGHT_6(100.0);
    [self.footView moveViewBgView:self.view.backgroundColor];
    [self.footView setViewsTitle:subViewTitleAry];
    [self.view addSubview:self.footView];
    
    
}

- (void)initBaseScrollViewSelectPageNum:(NSInteger)pageNum
{
    
}

- (void)loadLogInView
{
    if (!self.loginView) {
        self.loginView = [PleaseLogInView loadXIB];
        self.loginView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
        WEAK(weakSelf);
        [self.loginView setClickLoginButtonBlock:^{
            [LoginViewController changeFromeVC:weakSelf onCompleteSuccessBlock:^{
                
            }];
        }];
        [self.view addSubview:self.loginView];
    }else
    {
        [self.view addSubview:self.loginView];
    }
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
/*
-(void)initData
{
    self.eidtbtn.selected = NO;
    self.subViewTitleAry = [[NSMutableArray alloc]initWithObjects:@"全部订单", @"待评价", nil];
    self.allOrderView = [AllOrderView initCustomView];
    self.waitPingjiaView = [WaitPingjiaView initCustomView];
    self.subViewsAry = [[NSMutableArray alloc]initWithObjects:self.allOrderView, self.waitPingjiaView, nil];
}
-(void)initInterFace
{
    self.footView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 0    , KScreenWidth, KScreenHeight )];
    self.footView.delegate = self;
    [self.footView setSubViewOfScrollerView:_subViewsAry];
    [self.footView setViewsTitle:_subViewTitleAry];
    [self.containView addSubview:self.footView];}
#pragma mark --- BaseScrollViewDelegate
- (void)initBaseScrollViewSelectPageNum:(NSInteger)pageNum
{
    
}
 */
@end
