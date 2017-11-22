//
//  AECellDetailViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/26.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AECellDetailViewController.h"
#import "CommentViewController.h"
#import "ShoppingCarView.h"
#import "OrderSettlementViewController.h"


@interface AECellDetailViewController ()<ShoppingCarViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addShoppingBtn;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *settleAcountBtn;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;

@property (nonatomic ,assign) int count;

@property (nonatomic ,strong) ShoppingCarView *shoppingView;

@end

@implementation AECellDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNetWorking];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"haveNoData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"deletCar" object:nil];
    [self initInterFace];
    [self reloadLocationData];
    
    
    
}
//用于刷新界面


-(void)initNetWorking
{
    NSMutableArray *idAry = [[NSMutableArray alloc]init];
    [idAry addObject:self.model.productId];
    NSLog(@"idAry is %@",idAry);
    [[[AFBaseNetWork alloc]init] post:[@"findGoodEva" url_ex] params:@{@"ids":[idAry yy_modelToJSONString]} progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
           
            int num = [responseObject[@"responseData"][0][@"evaCount"] intValue];
            
            NSString *numStr = [NSString stringWithFormat:@"%d条评论>",num];
            [self.numberValuation setTitle:numStr forState:UIControlStateNormal];
    
            double valu = [responseObject[@"responseData"][0][@"goodEva"] doubleValue];
            NSString * valuStr = [NSString stringWithFormat:@"%.3f",valu];
            int d = [valuStr doubleValue]  *1000 ;
            if (d % 100 < 5) {
                int va = d / 10;
                self.valuation.text = [NSString stringWithFormat:@"%d%%",va];
            }else{
                int va = d / 10 + 1;
                self.valuation.text = [NSString stringWithFormat:@"%d%%",va];
            }
            self.valutionProgress.progress = valu;
        }
        
    } onError:^(NSError *error) {
        
    }];
    
    
}

-(void)initInterFace{
    //动态更新Model数据否则界面无法正常刷新
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSMutableArray *data = [manager getLcationData];
//不减为0 的情况
        for (int i = 0 ; i < data.count; i++) {
            ProductModel *newModel = data[i];
            if ([self.model.productId isEqualToString:newModel.productId] && self.model.isActivity == newModel.isActivity) {
                self.model.shopCount = newModel.shopCount;
            }
        }

    if(data.count == 0){
        
     self.model.shopCount = 0;
        
    }else{
        
    }
    
    
    self.tagLabel.text = self.model.showSaleand;

    self.productName.text = [NSString stringWithFormat:@"%@",self.model.productName];
    
    self.productInfo.text = [NSString stringWithFormat:@"%@",self.model.productDesc];
    
    if (self.model.isActivity) {
        self.price.text = MoneySymbol(self.model.activityPrice);
    }else{
    self.price.text = MoneySymbol(self.model.price);
    }
    self.addCount.text = [NSString stringWithFormat:@"%d",self.model.shopCount];
    
    self.count = [self.addCount.text intValue];
    if (self.count == 0) {
        self.addShoppingBtn.hidden = NO;
        self.footView.hidden = YES;
    }
    else{
        self.addShoppingBtn.hidden = YES;
        self.footView.hidden = NO;
    }
    [self initSettleBtnAndShoppingCarBtn];
    
    if (self.isStart == NO) {
        
        self.footView.hidden = YES;
        self.addShoppingBtn.enabled = NO;
        [self.addShoppingBtn setTitle:@"即将开始" forState:UIControlStateNormal];
        self.addShoppingBtn.backgroundColor = [UIColor whiteColor];
        self.addShoppingBtn.layer.cornerRadius = 11;
        self.addShoppingBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.addShoppingBtn.layer.borderWidth=0.4;
    }
    
}
-(void)reloadLocationData{
     [self initSettleBtnAndShoppingCarBtn];
}

//结算按钮购物车状态
-(void)initSettleBtnAndShoppingCarBtn
{
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSMutableArray *data = [[NSMutableArray alloc]init];
    data = [manager getLcationData];
    if (data.count > 0 ) {
        self.settleAcountBtn.enabled = YES;
        if (manager.totalPrice >= [ArriveEarlyManager shared].areaStoreInfo.startPrice ) {
            [self.settleAcountBtn setTitle:@"去结算" forState:UIControlStateNormal];
            [self.settleAcountBtn setBackgroundColor:HWColor(253, 213, 3) forState:UIControlStateNormal];
        }else
        {
            [self.settleAcountBtn setTitle:[NSString stringWithFormat:@"差%@起送",MoneySymbol([ArriveEarlyManager shared].areaStoreInfo.startPrice - manager.totalPrice)] forState:UIControlStateNormal];
            [self.settleAcountBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }

        [self.settleAcountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.shoppingCarBtn.enabled = YES;
        [self.shoppingCarBtn setImage:[UIImage imageNamed:@"gwc1"] forState:UIControlStateNormal];
       
        self.redLabel.text = [NSString stringWithFormat:@"%ld",data.count];
        self.redLabel.hidden =NO;
        self.priceView.hidden = NO;

        self.waitPayLabel.text = MoneySymbol(manager.totalPrice);
    }
    else{
        self.settleAcountBtn.enabled = NO;
        self.settleAcountBtn.backgroundColor = [UIColor lightGrayColor];
        [self.settleAcountBtn setTitle:[NSString stringWithFormat:@"%@起送",MoneySymbol([ArriveEarlyManager shared].areaStoreInfo.startPrice)] forState:UIControlStateNormal];
        [self.settleAcountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.shoppingCarBtn.enabled = NO;
        [self.shoppingCarBtn setImage:[UIImage imageNamed:@"gwc"] forState:UIControlStateNormal];
        
        self.redLabel.hidden =YES;
        self.priceView.hidden = YES;
    }

}

- (IBAction)addShoppingCar:(UIButton *)sender {
    
    self.addShoppingBtn.hidden = YES;
    self.footView.hidden = NO;
    
    self.addCount.text = [NSString stringWithFormat:@"%d",[self.addCount.text intValue] + 1];
    NSLog(@"_______________self.addCount.text");

    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    
    [manager saveProduct:self.model andChangeAdditionalCopies:1 andProductConfig:nil];
    
    [self initSettleBtnAndShoppingCarBtn];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
}

//分享
- (IBAction)shareAction:(UIButton *)sender {
    NSLog(@"点击分享");
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if (platformType == UMSocialPlatformType_WechatSession) {
            
            [self shareTextToPlatformType:platformType];
        }
        if (platformType == UMSocialPlatformType_WechatTimeLine) {
            
            [self shareTextToPlatformType:platformType];
        }
        if (platformType ==UMSocialPlatformType_QQ) {
            
            
            [self shareTextToPlatformType:platformType];
        }
        if (platformType == UMSocialPlatformType_Qzone) {
            
            
            
            [self shareTextToPlatformType:platformType];
        }
        
    }];
    
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"保全万岁" descr:@"冯记哥哥爱罗健" thumImage:[UIImage imageNamed:@"AppIcon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
        
        [self alertWithError:error];
    }];
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


//评论详情
- (IBAction)commentInfo:(UIButton *)sender {
    
    if([self.numberValuation.titleLabel.text isEqualToString:@"暂无任何评论>"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无任何评论" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
    CommentViewController *vc = [[CommentViewController alloc]init];
    vc.productId = self.model.productId;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
//返回
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    //返回就通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
}

- (IBAction)plusAction:(UIButton *)sender {
    self.addCount.text = [NSString stringWithFormat:@"%d",[self.addCount.text intValue] + 1];
    NSLog(@"_______________self.addCount.text");
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    [manager saveProduct:self.model andChangeAdditionalCopies:1 andProductConfig:nil];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
    [self initSettleBtnAndShoppingCarBtn];
}

- (IBAction)minusAction:(UIButton *)sender {
    self.addCount.text = [NSString stringWithFormat:@"%d",[self.addCount.text intValue] - 1];
    NSLog(@"_______________self.addCount.text");
    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    [manager saveProduct:self.model andChangeAdditionalCopies:1 andProductConfig:nil];

    if ([self.addCount.text intValue] <= 0) {
        self.addShoppingBtn.hidden = NO;
        self.footView.hidden = YES;
    }
    [self initSettleBtnAndShoppingCarBtn];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
}
- (IBAction)shoppingBtnAction:(UIButton *)sender {
    
    [self.shoppingView isHidden:NO];
}

- (IBAction)settleAccountBtnAction:(id)sender {
    [OrderSettlementViewController changeFormeViewController:self onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
    }];
}


#pragma  mark  -------SHoppingViewDelegate------
-(void)refreshControllerView
{
    [self initInterFace];
}
-(void)backRefresh
{
    [self initInterFace];
}
//隐藏导航栏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //购物车
    self.shoppingView = [ShoppingCarView initCustomView];
    self.shoppingView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.shoppingView.delegate = self;
    self.shoppingView.vc = self;
    [self.shoppingView isHidden:YES];
    [self.shoppingView reloadData];//到时候有数据了理一下传过来的顺序
    [self.view addSubview:self.shoppingView];
    
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
