//
//  OrderSettlementViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderSettlementViewController.h"

#import "OrderSettlementContentView.h"

#import "LoginViewController.h"
#import "ClosingTimeView.h"

@interface OrderSettlementViewController ()
{
    NSArray * shoppingCartDataArray;
    
    NSInteger isViewDidAppear;
}

@property (nonatomic, strong) OrderSettlementContentView *orderView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationViewHeight;
@property (nonatomic, copy) OrderSettlementSuccessBlock settlementBlock;
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@end

@implementation OrderSettlementViewController

+ (instancetype)changeFormeViewController:(UIViewController *)fromeVC order:(OrderMessageModelInfo *)orderInfo onCompleteBlock:(OrderSettlementSuccessBlock)block
{
    OrderSettlementViewController *vc = [[OrderSettlementViewController alloc] initWithNibName:@"OrderSettlementViewController" bundle:nil];
    vc.settlementBlock = block;
    vc.orderInfo = [orderInfo yy_modelCopy];
    [fromeVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

//去结算的 时候 获取一次门店信息接口 判断门店状态
+ (instancetype)changeFormeViewController:(UIViewController *)fromeVC onCompleteBlock:(OrderSettlementSuccessBlock)block
{
    
    [[ArriveEarlyManager shared] updateRegionalInformationBlock:^(AreaStoreInfo *areaStoreInfo, NSError *error) {
        if (areaStoreInfo && areaStoreInfo.isOpen==0) {
            [[ClosingTimeView initCustomView] show_custom];
            [[ShoppingCarManager sharedManager] removeLocationData];
            BLOCK_EXIST(block,nil);
        }
    }];
    
    
 
    [fromeVC.view showPopupLoading];
    [[ArriveEarlyManager shared] updateareaStoreInfoBlock:^(AreaStoreInfo *areaStoreInfo, NSError *erroe) {
        [fromeVC.view hidePopupLoading];
        if ([ArriveEarlyManager shared].areaStoreInfo && [ArriveEarlyManager shared].areaStoreInfo.isOpen == 0) {
            [[ClosingTimeView initCustomView] show_custom];
            [[ShoppingCarManager sharedManager] removeLocationData];
            BLOCK_EXIST(block,nil);
        }else
        {
            if ([ShoppingCarManager sharedManager].totalPrice < [ArriveEarlyManager shared].areaStoreInfo.startPrice) {
                
                [UIAlertController showAlertInViewController:fromeVC withTitle:nil message:[NSString stringWithFormat:@"未达到起送价,还差%@", MoneySymbol([ArriveEarlyManager shared].areaStoreInfo.startPrice - [ShoppingCarManager sharedManager].totalPrice)] cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    
                }];
            }
            OrderSettlementViewController *vc = [[OrderSettlementViewController alloc] initWithNibName:@"OrderSettlementViewController" bundle:nil];
            vc.settlementBlock = block;
            [fromeVC.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    return nil;
    
    if ([ShoppingCarManager sharedManager].totalPrice < [ArriveEarlyManager shared].areaStoreInfo.startPrice) {
        
        [UIAlertController showAlertInViewController:fromeVC withTitle:nil message:[NSString stringWithFormat:@"未达到起送价,还差%@", MoneySymbol([ArriveEarlyManager shared].areaStoreInfo.startPrice - [ShoppingCarManager sharedManager].totalPrice)] cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
        }];
        return nil;
    }
    OrderSettlementViewController *vc = [[OrderSettlementViewController alloc] initWithNibName:@"OrderSettlementViewController" bundle:nil];
    vc.settlementBlock = block;
    [fromeVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"提交订单";
    [self.operationViewHeight setConstant:KHEIGHT_6(50.0)];
    
    isViewDidAppear = 0;
    kShowProgress(self);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!self.orderInfo) {
        NSMutableArray <OrderMessageProductInfo *>*data = [NSMutableArray new];
        shoppingCartDataArray = [[ShoppingCarManager sharedManager] getLcationData];
        for (ProductModel *product in shoppingCartDataArray) {
//            if (product.productState != ProductState_shelved) {
//                continue;
//            }
            OrderMessageProductInfo *info = [OrderMessageProductInfo new];
            if (product.isActivity) {
                info.orderProductType = 1;
            }
            info.productCnt = product.shopCount;
            info.productId = product.productId;
            info.productInfo = product;
            info.productInfo.isActivity = product.isActivity;
            [data addObject:info];
        }
        self.orderInfo = [OrderMessageModelInfo new];
        self.orderInfo.userId = [ArriveEarlyManager shared].userLogData.userId;
        self.orderInfo.orderProducts = (NSArray<OrderMessageProductInfo>*)data;
    }
    else
    {
        NSMutableArray *shops = [[NSMutableArray alloc] init];
        //处理再来一单的
        for (OrderMessageProductInfo *info in self.orderInfo.orderProducts) {
            info.productInfo.shopCount = info.productCnt;
            //info.productInfo.isActivity = (int)info.orderProductType;
            info.productInfo.productId = info.productId;
            [shops addObject:info.productInfo];
        }
        self.orderInfo.userId = [ArriveEarlyManager shared].userLogData.userId;
        shoppingCartDataArray = shops;
    }
    
    
    self.orderView = [OrderSettlementContentView loadXIB];
    self.orderView.superVC = self;

    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ArriveEarlyManager loginSuccess:^{
        if (!shoppingCartDataArray.count) {
            [[UIApplication  sharedApplication].keyWindow showPopupErrorMessage:@"无菜品"];
            kHiddenProgress(self);
            [self.navigationController  popViewControllerAnimated:YES];
            return;
        }
        
        if (![self.view.subviews containsObject:self.orderView]) {
            WEAK(weakSelf);
            [ArriveEarlyManager updateUserInfoWithTokenComplete:^(id data, NSError *error) {
                if (error) {
                    kHiddenProgress(weakSelf);
                    [[UIApplication  sharedApplication].keyWindow showPopupErrorMessage:error.domain];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                //获取支付方式
                [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"config" url_ex] params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
                    
                    
                    NSDictionary *dict = responseObject;
                    if ([dict[@"responseData"] isKindOfClass:[NSString class]]) {
                        NSString *s = dict[@"responseData"];
                        NSMutableArray *ss = [[NSMutableArray alloc] init];
                        for (int i=0; i<s.length; i++) {
                            NSString *as = [s substringWithRange:NSMakeRange(i, 1)];
                            [ss addObject:as];
                        }
                        self.orderView.payments = ss;
                    }
                    
                    [self validationOrderProducts];
                    
                }];
                
                
                
            }];
        }
        [self.orderView _viewDidAppear:YES];
    } fail:^{
        kHiddenProgress(self);
        if (isViewDidAppear == 0) {
            [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
                
            }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    isViewDidAppear = 1;
}

- (void)validationOrderProducts
{
    [EncapsulationAFBaseNet updateProductInfoForProducts:self.orderInfo.orderProducts onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            kHiddenProgress(self);
            [[UIApplication  sharedApplication].keyWindow showPopupErrorMessage:error.domain];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        NSDictionary *dict = responseObject;
        if ([dict[@"responseData"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDict in dict[@"responseData"] ) {
                ProductModel *model = [ProductModel findById_special_yy_modelWithDictionary:dataDict];
                if (model) {
                    if (model.productState != ProductState_shelved) {
                        continue;
                    }
                    [dataArr addObject:model];
                }
            }
        }
        NSMutableArray *realDataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.orderInfo.orderProducts.count; i ++) {
            OrderMessageProductInfo *info = self.orderInfo.orderProducts[i];
            for (ProductModel *aInfo in dataArr) {
                if ([aInfo.productId isEqualToString:info.productId] && aInfo.isActivity == info.productInfo.isActivity) {
                    
                    info.productInfo.price = aInfo.price;
                    info.productInfo.isActivity  = aInfo.isActivity;
                    info.productInfo.activityPrice  = aInfo.activityPrice;
                    info.productInfo.meelFee  = aInfo.meelFee;
                    if (info.productInfo.isActivity) {
                        info.orderProductType = 1;
                    }
                    /*
                    ProductModel *reIno = [aInfo yy_modelCopy];
                    if (reIno.isActivity) {
                        info.orderProductType = 1;
                    }
                    reIno.shopCount = info.productInfo.shopCount;
                    info.productInfo = reIno;
                    */
                    
                    // && pInfo.orderProductType == ProductTypeNormal
                    
                    if (info.orderProductType == ProductTypeAddPriceBuy) {
                        continue;
                    }
                    
                    //orderProductType  要不要滤掉加价购的
                    
                    [realDataArray addObject:[info yy_modelCopy]];
                    break;
                }
            }
        }
        // realDataArray   -->>OrderMessageProductInfo.productInfo
        self.orderInfo.orderProducts = (NSArray<OrderMessageProductInfo>*)realDataArray;
        
        if (self.orderInfo.orderProducts.count>0) {
            [self loadOrderSettlementContentView];
        }else
        {
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"相关菜品已经下架了" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
    }];

}

- (void)loadOrderSettlementContentView
{
    self.orderView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64.0);
    
    [self.orderView configWith:self.orderInfo];
    
    [self.view addSubview:self.orderView];
    kHiddenProgress(self);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DLogMethod();
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
