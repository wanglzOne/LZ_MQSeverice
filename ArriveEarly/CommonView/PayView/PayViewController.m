//
//  PayViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PayViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "PaySuccessViewController.h"
#import "RootViewController.h"
#import "OrderViewController.h"

@interface PayViewController ()
{
    NSTimer *timer;
    int timeOut;
}
@property (nonatomic, strong) NSArray *bts;
@property (nonatomic, strong) OrderMessageModelInfo *order;
@property (nonatomic, copy) ChangeSuccessBlock block;
@property (weak, nonatomic) IBOutlet UILabel *timeLbale;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbael;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;


@property (weak, nonatomic) IBOutlet UIButton *zhifubaoButtton;
@property (weak, nonatomic) IBOutlet UIButton *weixingButton;

@property (strong, nonatomic) UIButton *choosedButtton;

@property (weak, nonatomic) IBOutlet UIButton *payButtton;

@property (weak, nonatomic) IBOutlet UILabel *m1_time;
@property (weak, nonatomic) IBOutlet UILabel *m2_time;
@property (weak, nonatomic) IBOutlet UILabel *s1_time;
@property (weak, nonatomic) IBOutlet UILabel *s2_time;

@end

@implementation PayViewController
+ (instancetype)changefromeVC:(UIViewController *)superVC andOrderInfo:(OrderMessageModelInfo *)order onComplete:(ChangeSuccessBlock)block
{
    PayViewController *vc = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
    vc.block = block;
    vc.order = order;
    [superVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"支付订单";
    
    [self.cusNavView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    

    self.timeLbale.text = @"支付剩余时间";//[@"请在 15分钟 内完成支付" setStrColor:[UIColor redColor] colorStr:@"15分钟"];
    self.moneyLbael.text = MoneySymbol(self.order.booksInfo.orderPrice);
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号 %@",self.order.booksInfo.orderId];
    
    self.bts = [[NSArray alloc] initWithObjects:self.zhifubaoButtton,self.weixingButton, nil];
    self.choosedButtton = self.bts[0];
    
    [self comeActivity];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeActivity) name:@"comeActivity" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultTheCallback:) name:@"PayResultTheCallback" object:nil];
    
    
}
- (void)backButtonAction
{
    [UIAlertController showInViewController:self withTitle:@"提示" message:@"放弃支付？" preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
        UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
        if ([nav isKindOfClass:[UINavigationController class]]) {
            UIViewController *rootVC = [nav.viewControllers firstObject];
            if ([rootVC isKindOfClass:[RootViewController class]]) {
                RootViewController *root = (RootViewController *)rootVC;
                
                OrderViewController *orderVC = (OrderViewController *)[root changeToClass:[OrderViewController class]];
                [orderVC changetoDetailsOrderViewControllerWithOrderid:self.order.orderId];
            }
        }

    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)comeActivity
{
    
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"searchTime" url_ex] params:@{@"orderId" : self.order.orderId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        if (error) {
            [self setTileShow:0];
            [self.view showPopupErrorMessage:error.domain];
            [self.payButtton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.payButtton setTitle:@"订单已经超时" forState:UIControlStateNormal];
            self.payButtton.userInteractionEnabled = NO;
            return ;
        }
        NSDictionary *responseDict = responseObject;
        NSDictionary *dataDict = responseDict[@"responseData"];
        if ([dataDict isKindOfClass:[NSDictionary class]]) {
            [self setTileShow:[dataDict[@"time"] intValue]];
        }
        
        //responseDict[@"payMethod"];//123
    }];

    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findBookDetail" url_ex] params:@{@"orderId" : self.order.orderId} onCommonBlockCompletion:^(id responseObject, NSError *error) {

            if (!error) {
                NSDictionary *dict = responseObject;
                if ([dict[@"responseData"] isKindOfClass:[NSDictionary class]]) {
                    OrderMessageModelInfo* orderInfo = [OrderMessageModelInfo special_yy_modelWithDictionary:dict[@"responseData"]];
                    if(orderInfo.booksInfo.orderStatus == 1){
                        [self pushToPaySuccessView];
                    }
                }
            }
        }];

    });
 
}
- (void)setTileShow:(int)time
{
    timeOut = time/1000;
    [self timerLabelShow];
    [self beginTimer];
}


- (void)scheduledTimer
{
    timeOut--;
    [self timerLabelShow];
}

- (IBAction)choosePayMentButtonClick:(id)sender {
    UIButton *btn = sender;
    if (btn.selected) {
        return;
    }
    for (UIButton *button in self.bts) {
        if (button == btn) {
            button.selected = YES;
            self.choosedButtton = button;
        }
        else
        {
            button.selected = NO;
        }
    }
    
}


- (IBAction)enterPayActon:(id)sender {
    [self payRequest];
}




- (void)payRequest
{
    [self.view showPopupLoading];
    NSString *url = @"alipay/recharge";
    if (self.choosedButtton == self.zhifubaoButtton) {
    }
    else if (self.choosedButtton == self.weixingButton)
    {
        url = @"wxpay/recharge";
    }
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[url url_ex] params:[self creatDataPaymentType:0] onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self.view hidePopupLoadingAnimated:YES];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        NSDictionary *responseDict = responseObject;
        DLog(@"支付宝结果 ：%@ ",responseDict);
        [self dealWithData:responseDict];
    }];
}


- (void)dealWithData:(NSDictionary *)dataDict
{
    if ([dataDict isKindOfClass:[NSDictionary class]]) {
        id datas = [dataDict objectForKey:@"responseData"];
        if (datas && datas != [NSNull null])
        {
            if (self.choosedButtton == self.zhifubaoButtton) {
                //支付宝支付
                [self initAlipay:datas];
            }
            else
            {
                //微信支付
                [self weixinpayWithSignedData:datas];
            }
        }
    }
}

#pragma mark ----- 支付宝 支付 ----- eztriptechPassenger
- (void)initAlipay:(NSDictionary *)infoDic
{
    NSString * appScheme = @"ArriveEarlyAlipay";
    NSString *requestStr = infoDic[@"requestStr"];
    if (requestStr) {
        [[AlipaySDK defaultService] payOrder:requestStr fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             [self dealPaySuccess:resultDic];
         }];
    }else
    {
        [self promptAlertMessage:@"支付失败!"];
    }
}

#pragma mark ----------------- weixinpay -------------
-(void)weixinpayWithSignedData:(NSDictionary *)infoDic
{
    
    if ([WXApi isWXAppInstalled])
    {

        PayReq *request = [[PayReq alloc]init];
        request.partnerId = infoDic[@"partnerid"];
        request.prepayId = infoDic[@"prepayid"];
        request.package = infoDic[@"package"];
        request.nonceStr = infoDic[@"noncestr"];
        request.timeStamp = [infoDic[@"timestamp"] intValue];
        request.sign = infoDic[@"sign"];
        [WXApi sendReq:request];
        
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有安装微信哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}


- (void)payResultTheCallback:(NSNotification *)noti
{
    id resultDic = noti.object;
    if ([resultDic isKindOfClass:[BaseResp class]]) {
        BaseResp *resp = resultDic;
        if (resp.errCode == 0) {
            //[[UIApplication sharedApplication].keyWindow showPopupOKMessage:@"恭喜支付成功"];
            [self pushToPaySuccessView];

            //[self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            [self promptAlertMessage:@"支付失败!"];
        }
        
    }
    if ([resultDic isKindOfClass:[NSDictionary class]]) {
        [self dealPaySuccess:resultDic];
    }
}
- (void)dealPaySuccess:(NSDictionary *)resultDic
{
    if ([resultDic[@"resultStatus"] integerValue] == 9000)
    {
        [self pushToPaySuccessView];
    }
    else
    {
        [self promptAlertMessage:@"支付失败!"];
    }
}


- (void)pushToPaySuccessView
{
    PaySuccessViewController *pay = [[PaySuccessViewController alloc] initWithNibName:@"PaySuccessViewController" bundle:nil];
    pay.order = self.order;
    [self.navigationController pushViewController:pay animated:YES];
}











- (NSDictionary *)creatDataPaymentType:(int)type
{
    NSDictionary *dictionary = nil ;
    if (self.choosedButtton == self.zhifubaoButtton) {
        dictionary = @{
                       @"platform":@"支付宝iOS",
                       //@"money":@"0.01",
                       @"money":@([[self.moneyLbael.text substringFromIndex:1] doubleValue]),
                       @"payModeId": @(PayModeIdMenu_ZHIFUBAO),
                       @"basePath":@"rechargeAction",
                       @"orderId":self.order.orderId
                       };
    }
    else if (self.choosedButtton == self.weixingButton)
    {
        //微信支付
        dictionary = @{
                       @"platform":@"微信iOS",
                       //@"money":@"0.01",
                       @"money":@([[self.moneyLbael.text substringFromIndex:1] doubleValue]),
                       @"payModeId": @(PayModeIdMenu_WCHAT),
                       @"basePath":@"rechargeAction",
                       @"orderId":self.order.orderId,
                       @"remoteAddr" : [NSString deviceIPAddress]
                       };
    }
    return dictionary;
}

- (void)beginTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
    [timer fire];
}
- (void)timerLabelShow
{
    NSString *ms = [NSString stringWithFormat:@"%d",timeOut / 60];
    NSString *ss = [NSString stringWithFormat:@"%d",timeOut % 60];
    NSString *m1 = @"0";
    NSString *m2 = @"0";
    NSString *s1 = @"0";
    NSString *s2 = @"0";
    if (ms.length == 1) {
        m2 = ms;
    }else
    {
        for (int i=0; i<ms.length; i++) {
            NSString *as = [ms substringWithRange:NSMakeRange(i, 1)];
            if (i==0) {
                m1 = as;
            }else
            {
                m2 = as;
            }
        }
    }
    if (ss.length == 1) {
        s2 = ss;
    }else
    {
        for (int i=0; i<ss.length; i++) {
            NSString *as = [ss substringWithRange:NSMakeRange(i, 1)];
            if (i==0) {
                s1 = as;
            }else
            {
                s2 = as;
            }
        }
    }
    self.m1_time.text = m1;
    self.m2_time.text = m2;
    self.s1_time.text = s1;
    self.s2_time.text = s2;
    
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
