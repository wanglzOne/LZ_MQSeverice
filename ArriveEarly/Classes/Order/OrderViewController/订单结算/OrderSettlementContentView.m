//
//  OrderSettlementContentView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderSettlementContentView.h"
#import "OrderNormalTableViewCell.h"
#import "AddAddressCellTableViewCell.h"
#import "OrderPaymentTableViewCell.h"
#import "MyRedPacketViewController.h"
#import "OrderSetlementData.h"
#import "OrderAddPriceBuyTableViewCell.h"
#import "PayMentShowTableViewCell.h"
#import "OtherActivityTableViewCell.h"
#import "RiceTableViewCell.h"
#import "PayViewController.h"
#import "OrderNoteViewController.h"
//做一个 管理器  专门处理  价格 优惠价啊     总价格啊     之类的额
#import "RootViewController.h"
#import "OrderViewController.h"


#import "ClosingTimeView.h"



/// MVVM 好点   添加 一个数据 管理类  ViewModel


@interface OrderSettlementContentView ()<UITableViewDelegate, UITableViewDataSource,OrderAddPriceBuyDelegate>
{
    OrderSetlementData *orderData;
}

/**********  提交数据    **********/
//支付方式
@property (nonatomic, assign) PayModeIdMenu payment;
@property (nonatomic, strong) NSString *noteString;
@property (nonatomic, assign) NSInteger riceCount;
//选择的地址
@property (nonatomic, strong) Adress_Info *chooseAddressInfo;
// self.staticTitleDict  中的  key（sectionarray）  对于标题 index。row 取值
//key @"代金券" : RedPacketsInfo
@property (strong, nonatomic) NSMutableDictionary *dataContentDict;
///选择的超值加价购（超值折扣商品不参加活动）商品 数组  只存超值加价购（超值折扣商品不参加活动）的商品
@property (strong, nonatomic) NSMutableArray<AddPricetoBuyInfo *> *addCommitPricetoBuyDataArray;
///匹配的满减优惠
@property (strong, nonatomic) ReducePreferentialInfo *reducePreferentialInfo;
//匹配的满赠优惠
@property (strong, nonatomic) GevePreferentialInfo *gevePreferentialInfo;
///匹配的 最优红包
@property (strong, nonatomic) RedPacketsInfo *redPacketsInfo;
@property (strong, nonatomic) RedPacketsInfo *redPacketsInfo_newUser;

///购物车商品记录数组
@property (strong, nonatomic) NSMutableArray<OrderMessageProductInfo *> *addCommitProductModelDataArray;
///添加 平台默认商品  存储数组  查询这个数组中有的产品 shopCount有值得 defaultDataArray
///平台默认商品  类型 都是 普通商品，无活动商品    他可以参加满赠满减的活动
@property (strong, nonatomic) NSMutableArray<ProductModel *> *addDefaultCommitProductModelDataArray;
//
//服务器返回的 预计送达时间
@property (strong, nonatomic) NSDictionary *estimatedFinishTime;
///费用字典   posttagePrice:配送费  meelFee：餐盒费 preferentialPrice:优惠金额   orderPrice：订单价格（最终价格）
@property (strong, nonatomic) NSMutableDictionary *constDataDict;

//key
///门店信息
@property (strong, nonatomic) AreaStoreInfo *storeInfo;




/*********        UI      *******/
//已优惠 100
@property (weak, nonatomic) IBOutlet UILabel *label_preferential;
//待支付 100
@property (weak, nonatomic) IBOutlet UILabel *label_waitePey;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UIView *commitBgView;

/*********        data      *******/
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@property (strong, nonatomic) NSArray *showSectionArray;
@property (strong, nonatomic) NSArray *sectionArray;
@property (strong, nonatomic) NSMutableDictionary *staticTitleDict;
///存储拉取到的超值加价购（超值折扣商品不参加活动）商品列表
@property (strong, nonatomic) NSMutableArray<AddPricetoBuyInfo *> *addPricetoBuyDataArray;

///默认商品  可以   是能够参加满赠满减活动的      点击了  默认商品之后  要去重新匹配红包 和 满减满赠优惠
@property (strong, nonatomic) NSMutableArray<ProductModel *> *defaultDataArray;
///满减
@property (strong, nonatomic) NSMutableArray<ReducePreferentialInfo *> *reduceDataArray;
///满赠
@property (strong, nonatomic) NSMutableArray<GevePreferentialInfo *> *geveDataArray;
@property (strong, nonatomic) NSMutableArray<RedPacketsInfo *> *redPacketsDataArray;

@property (nonatomic, strong) ClosingTimeView *closeView;

@end

@implementation OrderSettlementContentView
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.commitButton setBackgroundColor:HWColor(255, 219, 0) forState:UIControlStateNormal];
    self.label_preferential.textColor = [UIColor blackColor];HWColor(184, 184, 184);
    self.lineV.backgroundColor = HWColor(228, 228, 228);
    self.commitBgView.backgroundColor = HWColor(252, 252, 252);
}

+ (instancetype)loadXIB
{
    OrderSettlementContentView *view = [[NSBundle mainBundle] loadNibNamed:@"OrderSettlementContentView" owner:nil options:nil][0];
    return view;
}



#pragma mark  - 获取超值加价购（超值折扣商品不参加活动）商品列表
- (void)getAddPricetoBuyProductModel
{
    [self showPopupLoading];
    
    self.addPricetoBuyDataArray = [[NSMutableArray alloc] init];
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"queryMore" url_ex] params:@{@"moreAreaId" : [ArriveEarlyManager shared].areaStoreInfo.areaId ? [ArriveEarlyManager shared].areaStoreInfo.areaId : @""} onCommonBlockCompletion:^(id  responseObject, NSError *error) {
        [self hidePopupLoadingAnimated:YES];
        if (error) {
            DLog(@"获取超值加价购（超值折扣商品不参加活动）商品列表 -- >> \n%@ %@",error,responseObject);
            //[weakSelf showPopupErrorMessage:error.domain];
            [self getAddPricetoBuyProductModel_fail];
            return ;
        }
        
        NSDictionary *dict = responseObject;
        NSArray *dataArr = dict[@"responseData"];
        if ([dataArr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDict in dataArr) {
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    AddPricetoBuyInfo *info = [AddPricetoBuyInfo yy_modelWithDictionary:dataDict];
                    NSMutableArray *m = [[NSMutableArray alloc] init];
                    if ([dataDict[@"productImage"] isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dict in dataDict[@"productImage"]) {
                            if ([dict isKindOfClass:[NSDictionary class]]) {
                                ProductImageInfo *proImg = [ProductImageInfo yy_modelWithDictionary:dict];
                                [m addObject:proImg];
                            }
                        }
                    }
                    info.productInfo.productImage = (NSArray <ProductImageInfo> *)m;
                    [self.addPricetoBuyDataArray addObject:info];
                }else
                {
                }
            }
        }else
        {
        }
        if (self.addPricetoBuyDataArray.count == 0) {
            [self getAddPricetoBuyProductModel_fail];
            return;
        }
        [self updateData];
    }];
}
- (void)getAddPricetoBuyProductModel_fail
{
    NSMutableArray *msectionArray = [self.sectionArray mutableCopy];
    [msectionArray removeObject:@"超值加价购（超值折扣商品不参加活动）"];
    self.sectionArray = msectionArray;
    
    NSMutableArray *mshowSectionArray = [self.showSectionArray mutableCopy];
    [mshowSectionArray removeObject:@"超值加价购（超值折扣商品不参加活动）"];
    self.showSectionArray = mshowSectionArray;

    [self updateData];
}
- (void)updateData
{
    [self.tableView reloadData];
    
    if ([ArriveEarlyManager shared].userInfo.isTheoldUser) {
        [self getQueryWhen];
        [self getQueryWhenGive];
        [self getOrderRedBag];
    }else
    {
        ///新用户的
        [self getOrderRedBag];
        [self getQueryWhenGive];
    }
    //获取门店信息    在对 self.chooseAddressInfo 赋值的时候做
    if (self.chooseAddressInfo) {
        [self getAreaStoreInfo:CLLocationCoordinate2DMake(self.chooseAddressInfo.latitude, self.chooseAddressInfo.longtitude)];
    }
    [self getDefaultProduct];
    [self updatePackagingConst];
    [self updatePreferentialPrice];
}

#pragma mark  - 匹配满减优惠 满赠优惠
//满减
- (void)getQueryWhen
{
    NSMutableDictionary *parma = [[NSMutableDictionary alloc]init];
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        [parma setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId forKey:@"whenAreaId"];
    }else
    {
        [parma setObject:@"" forKey:@"whenAreaId"];
    }
    WEAK(weakSelf)
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"queryWhen" url_ex] params:parma onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        NSDictionary *dataDict = responseObject;
        NSArray *arr = dataDict[@"responseData"];
        weakSelf.reduceDataArray = [[NSMutableArray alloc] init];
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *data in arr) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    ReducePreferentialInfo *info = [ReducePreferentialInfo yy_modelWithDictionary:data];
                    if (info.whenId) {
                        [weakSelf.reduceDataArray addObject:info];
                    }
                }
            }
        }
        [weakSelf matchingQueryWhen];
        NSInteger section = [weakSelf.sectionArray indexOfObject:@"youhui"];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf getOrderRedBag];
        [weakSelf getQueryWhenGive];
        [weakSelf updatePreferentialPrice];
    }];
}
- (void)matchingQueryWhen
{
    ReducePreferentialInfo *re = nil;
    BOOL issss = NO;
    for (ReducePreferentialInfo *info in self.reduceDataArray) {
        if (info.whenLimitValue <= [self getNormalProductPrice]) {//self.orderInfo.orderNormalPrice
            if (info.whenValue > re.whenValue) {
                re = info;
                self.reducePreferentialInfo = info;
                issss = YES;
            }
        }
    }
    if (!issss) {
        self.reducePreferentialInfo = nil;
    }
//    BOOL issss = NO;
//    for (ReducePreferentialInfo *info in self.reduceDataArray) {
//        if (info.whenLimitValue <= [self getNormalProductPrice]) {//self.orderInfo.orderNormalPrice
//            if (info.whenValue > self.reducePreferentialInfo.whenValue) {
//                self.reducePreferentialInfo = info;
//                issss = YES;
//            }
//        }
//    }
//    if (!issss) {
//        self.reducePreferentialInfo = nil;
//    }
}
- (void)matchingQueryWhenGive
{
    BOOL issss = NO;
    for (GevePreferentialInfo *info in self.geveDataArray) {
        
        if (info.whenGiveTrigger <= [self getLimitValueOrderWhenGive]) {
            self.gevePreferentialInfo = info;
            issss = YES;
            break;
        
        }
    }
    if (!issss) {
        self.gevePreferentialInfo = nil;
    }
}
//满赠
- (void)getQueryWhenGive
{
    WEAK(weakSelf)
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"queryWhenGive" url_ex] params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        weakSelf.geveDataArray = [[NSMutableArray alloc] init];
        NSDictionary *dataDict = responseObject;
        NSArray *arr = dataDict[@"responseData"];
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *data in arr) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    GevePreferentialInfo *info = [GevePreferentialInfo yy_modelWithDictionary:data];
                    if (info.whenGiveId) {
                        [self.geveDataArray addObject:info];
                    }
                }
            }
        }
        [weakSelf matchingQueryWhenGive];
        NSInteger section = [weakSelf.sectionArray indexOfObject:@"youhui"];
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)matchingOrderRedBag
{
    for (RedPacketsInfo *info in self.redPacketsDataArray) {
        if (![ArriveEarlyManager shared].userInfo.isTheoldUser && [info.rbType intValue] == RedPacketType_NewUser) {
            self.redPacketsInfo_newUser = info;
            break;
        }
    }
    BOOL issss = NO;
    for (RedPacketsInfo *info in self.redPacketsDataArray) {
        if ([self getLimitValueOrderRedBag] >= info.rbLimitValue && [info.rbType intValue] != RedPacketType_NewUser) {
            self.redPacketsInfo = info;
            issss = YES;
            break;
        }
    }
    if (!issss) {
        self.redPacketsInfo = nil;
    }
}
- (CGFloat)getLimitValueOrderWhenGive
{
    [self matchingOrderRedBag];
    CGFloat currValue = [self getNormalProductPrice]  + [self getActivityProductPrice] -self.reducePreferentialInfo.whenValue;
    if(self.redPacketsInfo){
        currValue -= self.redPacketsInfo.rbValue;
    }
    return currValue;
}

- (CGFloat)getLimitValueOrderRedBag
{
    return [self getNormalProductPrice] + [self getActivityProductPrice]-self.reducePreferentialInfo.whenValue;
}
///匹配最优红包  红包（除开新用户红包）的使用  只 针对老用户，普通菜品在满减了之后的钱 看是否满足红包出发金额。
- (void)getOrderRedBag
{
    WEAK(weakSelf);
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"findRegBag" url_ex] pageParams:[PageHelper new].params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        if (error) {
            return ;
        }
        weakSelf.redPacketsDataArray = [[NSMutableArray alloc] init];
        NSArray *dataA = responseObject[@"responseData"];
        if ([dataA isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataD in dataA) {
                if ([dataD isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dataDic = dataD[@"rbConfig"];
                    if ([dataDic isKindOfClass:[NSDictionary class]]) {
                        //注意一个红包的条件  不能减出-的了   先计算了  满减优惠之后的价格 在-红包的钱
                        RedPacketsInfo *info = [RedPacketsInfo yy_modelWithDictionary:dataDic];
                        //(self.orderInfo.orderNormalPrice - self.reducePreferentialInfo.whenValue)
                        [weakSelf.redPacketsDataArray addObject:info];
                    }
                }
            }
        }
        [weakSelf matchingOrderRedBag];
        [weakSelf getQueryWhenGive];
        [self reloadSectionWithSectionTitle:@"red"];
        [self reloadSectionWithSectionTitle:@"youhui"];
        
        [weakSelf updatePreferentialPrice];
    }];
}
- (NSString *)areaId
{
    NSString *areaId = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaId = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }
    return areaId;
}

///获取默认商品 平台
- (void)getDefaultProduct
{
    WEAK(weakSelf);
    [self.superVC.view showPopupLoading];
    
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"queryDefault" url_ex] params:@{@"areaId" : [self areaId]} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self.superVC.view hidePopupLoading];
        
        if (error) {
            
            return ;
        }
        NSMutableArray *array = [NSMutableArray new];
        NSDictionary *dict =responseObject;
        NSArray *products = dict[@"responseData"];
        if ([products isKindOfClass:[NSArray class]]) {
            for (NSDictionary *data in products) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    ProductModel *model = [ProductModel yy_modelWithDictionary:data];
                    [array addObject:model];
                }
            }
        }
        weakSelf.defaultDataArray = array;
        [weakSelf.tableView reloadData];
    }];
    
    ArriveEarlyManager *earlyManager = [ArriveEarlyManager shared];
    [earlyManager loadDefaultAddress:^{
        if (earlyManager.defaultAddress) {
            self.chooseAddressInfo = earlyManager.defaultAddress;
            if (self.chooseAddressInfo) {
                [self getAreaStoreInfo:CLLocationCoordinate2DMake(self.chooseAddressInfo.latitude, self.chooseAddressInfo.longtitude)];
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self getEstimatedFinishTime];
        }
    }];
}

///订单状态等待制作
#pragma mark - 提交订单
- (IBAction)commitOrderAction:(id)sender {
    //调用 满减 满赠 匹配  然后计算总价[self updateTotalPrice];
    [self updateAllPrice];
    [self.tableView reloadData];
    
    
    //[self updateTotalPrice];
    
    WEAK(weakSelf);
    
    [self validationDataComplete:^{
        kShowProgress(self.superVC);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.constDataDict];
        [dict setObject:self.chooseAddressInfo.id_address forKey:@"addressId"];
        NSString *rep = @"女士";
        if (self.chooseAddressInfo.isMr) {
            rep = @"先生";
        }
        NSString *uname = [NSString stringWithFormat:@"%@%@",self.chooseAddressInfo.contactName?self.chooseAddressInfo.contactName: @"",rep];
        [dict setObject:uname forKey:@"userName"];
        [dict setObject:self.chooseAddressInfo.contactPhone?self.chooseAddressInfo.contactPhone:@"" forKey:@"userPhone"];
        NSString *address = [NSString stringWithFormat:@"%@ %@", (self.chooseAddressInfo.addressDetail?self.chooseAddressInfo.addressDetail :@""), (self.chooseAddressInfo.address?self.chooseAddressInfo.address :@"")];
        [dict setObject:address forKey:@"address"];
        
        //[dict setObject:@(1) forKey:@"orderType"];
        [dict setObject:@(self.payment) forKey:@"paymentMethod"];
        //[dict setObject: forKey:@"orderAreaId"];
        [dict setObject:@(1) forKey:@"orderStatus"];
        //[dict setObject:@(0) forKey:@"cityId"];
        if (self.reducePreferentialInfo.whenId) {
            [dict setObject:self.reducePreferentialInfo.whenId  forKey:@"whenId"];
        }
        if (self.gevePreferentialInfo.whenGiveId) {
            [dict setObject:self.gevePreferentialInfo.whenGiveId forKey:@"whenGiveId"];
        }
        
        [dict setObject:self.storeInfo.areaId forKey:@"areaId"];
        
        NSMutableArray *rbIds = [[NSMutableArray alloc] init];
        if (self.redPacketsInfo_newUser.id_redPackets) {
            [rbIds addObject:self.redPacketsInfo_newUser.id_redPackets];
        }
        if (self.redPacketsInfo.id_redPackets) {
            [rbIds addObject:self.redPacketsInfo.id_redPackets];
        }
        [dict setObject:[rbIds yy_modelToJSONString] forKey:@"rbIds"];//wanglz
        
        ///加价购
        NSMutableArray *maps = [[NSMutableArray alloc] init];
        for (AddPricetoBuyInfo *addInfo in self.addCommitPricetoBuyDataArray) {
            NSString *productName = [NSString stringWithFormat:@"%@[超值加价购（超值折扣商品不参加活动）]",addInfo.productInfo.productName];
            [maps addObject:[ @{@"productId" : addInfo.productId, @"productCnt" : @(addInfo.productCount), @"orderProductType" : @(2), @"apId" : @(0) , @"productName" : productName , @"activityName" : @"超值加价购（超值折扣商品不参加活动）", @"productPrice" : @(addInfo.morePrice)} mutableCopy]];
        }
        
        for (OrderMessageProductInfo *mInfo in self.addCommitProductModelDataArray) {
            int orderProductType = 0;
            NSString *activityName = mInfo.productInfo.activityName ? mInfo.productInfo.activityName : @"";
            CGFloat productPrice =  mInfo.productInfo.price;
            if (mInfo.productInfo.isActivity) {
                orderProductType = 1;
                productPrice =mInfo.productInfo.activityPrice;
            }
            if (mInfo.orderProductType == ProductTypeAddPriceBuy) {
                orderProductType = 2;
                productPrice = mInfo.moreConfigEntity.morePrice;
                if (!productPrice) {
                    productPrice = mInfo.productPrice;
                }
            }
            [maps addObject:[ @{@"productId" : mInfo.productInfo.productId, @"productCnt" : @(mInfo.productInfo.shopCount), @"orderProductType" : @(orderProductType),@"apId" : @(mInfo.productInfo.isActivity) , @"productName" : mInfo.productInfo.productName , @"activityName" : activityName , @"productPrice" : @(productPrice)} mutableCopy]];
        }
        
        
        for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
            if (mInfo.shopCount) {
                [maps addObject:[ @{@"productId" : mInfo.productId, @"productCnt" : @(mInfo.shopCount), @"orderProductType" : @(0), @"apId" : @(0) , @"productName" : mInfo.productName , @"activityName" : @"" , @"productPrice" : @(mInfo.price)} mutableCopy]];
            }
        }
        if (self.noteString.length) {
            [dict setObject:self.noteString forKey:@"remark"];
        }
        
        
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *adict in maps) {
            BOOL isExist = NO;
            for (NSMutableDictionary *dict in array) {
                if ([adict[@"productId"] isEqualToString:dict[@"productId"]] && [adict[@"orderProductType"] intValue] == [dict[@"orderProductType"] intValue]) {
                    isExist = YES;
                    int productCnt = [adict[@"productCnt"] intValue] + [dict[@"productCnt"] intValue];
                    [dict setObject:@(productCnt) forKey:@"productCnt"];
                }
            }
            if (!isExist) {
                [array addObject:adict];
            }
        }
        
        
        [dict setObject:@(_riceCount) forKey:@"meals"];
        [dict setObject:[array yy_modelToJSONString] forKey:@"map"];//wanglz
        
        
        //[dict setObject:@([[dict objectForKey:@"orderPrice"] floatValue] - 35.99) forKey:@"orderPrice"];
        
//      // wlz
//        NSError *parseError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
//        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        
//        NSString *str2 = @"{\n hhhhhhhhkkkkkkkkk \n}";
//        
//        NSString *RSAEncryptorStr = [RSAEncryptor encryptString:str publicKey:RSAPublicKey];
//
        
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"submitBook" url_ex] params:dict onCommonBlockCompletion:^(id responseObject, NSError *error) {
            
            
            kHiddenProgress(self.superVC);
            if (error) {
                [weakSelf showPopupErrorMessage:error.domain];
                return ;
            }
            [[ShoppingCarManager sharedManager] removeLocationData];
            if (weakSelf.payment != PayModeIdMenu_waiteGoods) {
                //跳转支付页面
                NSDictionary *data = responseObject;
                NSDictionary *dataDict = data[@"responseData"];
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    NSString* orderId = dataDict[@"orderId"];
                    CGFloat orderPrice = [dataDict[@"orderPrice"] floatValue];
                    if (orderId && orderPrice > 0 ) {
                        OrderMessageModelInfo *orderInfo = [OrderMessageModelInfo new];
                        OrderMessageBooksfo *books = [OrderMessageBooksfo yy_modelWithDictionary:dataDict];
                        orderInfo.booksInfo = books;
                        orderInfo.orderId = books.orderID;
                        [ArriveEarlyManager saveDefaultAddress:self.chooseAddressInfo];
                        
                        [PayViewController changefromeVC:self.superVC andOrderInfo:orderInfo onComplete:^(UIViewController *targetVienController, id changeContent) {
                            [self.superVC.navigationController popToRootViewControllerAnimated:YES];
                            [[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"恭喜支付成功，请在\"订单\"中查看详情"];
                        }];
                        return;
                    }
                }
                [weakSelf showPopupErrorMessage:@"订单处理异常请联系客服"];
            }
            else
            {
                
                [weakSelf.superVC.navigationController popToRootViewControllerAnimated:YES];
                
                NSDictionary *data = responseObject;
                NSDictionary *dataDict = data[@"responseData"];
                if ([dataDict isKindOfClass:[NSDictionary class]]) {
                    NSString* orderId = dataDict[@"orderId"];
                    CGFloat orderPrice = [dataDict[@"orderPrice"] floatValue];
                    if (orderId && orderPrice > 0 ) {
                        OrderMessageModelInfo *orderInfo = [OrderMessageModelInfo new];
                        OrderMessageBooksfo *books = [OrderMessageBooksfo yy_modelWithDictionary:dataDict];
                        orderInfo.booksInfo = books;
                        orderInfo.orderId = books.orderID;
                        UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
                        if ([nav isKindOfClass:[UINavigationController class]]) {
                            UIViewController *rootVC = [nav.viewControllers firstObject];
                            if ([rootVC isKindOfClass:[RootViewController class]]) {
                                RootViewController *root = (RootViewController *)rootVC;
                                
                                OrderViewController *orderVC = (OrderViewController *)[root changeToClass:[OrderViewController class]];
                                [orderVC changetoDetailsOrderViewControllerWithOrderid:books.orderID];
                            }
                        }
                    }
                }
                
                
                //[[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"恭喜提交成功，请在\"订单\"中查看详情"];
                //[weakSelf.superVC.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
            
            
        }];
        
        
    }];
}


#pragma mark ---------UITableViewDelegateDataSource-----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *name = self.sectionArray[section];
    if ([name isEqualToString:@"已点菜品"])
    {
        return self.addCommitProductModelDataArray.count;  //只是展示 普通商品  和
        return self.addCommitPricetoBuyDataArray.count + self.addCommitProductModelDataArray.count;
        return self.orderInfo.orderProducts.count;
    }
    else if ([name isEqualToString:@"默认商品"])
    {
        return self.defaultDataArray.count; //
    }
    NSArray *names = [self.staticTitleDict objectForKey:name];
    return names.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.sectionArray.count - 1) {
        return KHEIGHT_6(10.0);
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *name = self.sectionArray[section];
    if ([name isEqualToString:@"red"]) {
        return 0.01;
    }
    
    if ([name isEqualToString:@"youhui"] || [name isEqualToString:@"配送费用"] || [name isEqualToString:@"备注"]) {
        return 0.01;
    }
    if ([name isEqualToString:@"默认商品"])
    {
        if (!self.defaultDataArray.count) {
            return 0.0;
        }
    }
    if ([self.showSectionArray containsObject:name]) {
        return KHEIGHT_6(40.0);
    }
    
    return KHEIGHT_6(10.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = KHEIGHT_6(44.0) > 44.0  ? 44.0 : KHEIGHT_6(44.0);
    NSString *name = self.sectionArray[indexPath.section];
    if ([name isEqualToString:@"支付方式"]) {
        if (indexPath.row == 0) {
            return height;
        }else
        {
            return height;
        }
    }
    if ([name isEqualToString:@"address"] && indexPath.row == 0) {
        return KHEIGHT_6(153.0/2);
    }else if ([name containsString:@"超值加价购（超值折扣商品不参加活动）"])
    {
        if (KScreenWidth < 325.0) {
            return 230.0;
        }
        return KHEIGHT_6(230.0);
    }
    else if ([name isEqualToString:@"默认商品"])
    {
        return 105.0;;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *name = self.sectionArray[section];
    if ([self.showSectionArray containsObject:name]) {
        return name;
    }
    return @"";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK(weakSelf);
    NSString *sectionName = self.sectionArray[indexPath.section];
    NSArray *titles = [self.staticTitleDict objectForKey:sectionName];
    if ([sectionName isEqualToString:@"address"] && indexPath.row == 0) {
        AddAddressCellTableViewCell *addAddressCell = [tableView dequeueReusableCellWithIdentifier:@"AddAddressCell" forIndexPath:indexPath];
        addAddressCell.superVC = self.superVC;
        addAddressCell.chooseAddressInfo = self.chooseAddressInfo;
        
        
        [addAddressCell setChooiceAddressOnCompleteBlock:^(NSArray<Adress_Info *> *adresss) {
            Adress_Info *adInfo = adresss[0];
            
            if (self.chooseAddressInfo.id_address != adInfo.id_address) {
                self.chooseAddressInfo = adInfo;
                [self getAreaStoreInfo:CLLocationCoordinate2DMake(self.chooseAddressInfo.latitude, self.chooseAddressInfo.longtitude)];
            }
            
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf getEstimatedFinishTime];
        }];
        return addAddressCell;
    }
    else if ([sectionName isEqualToString:@"支付方式"]) {
        if (indexPath.row == 0) {
            PayMentShowTableViewCell *paymentSsowCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentShowCell" forIndexPath:indexPath];
            NSString *payStr = @"在线支付";
            if (self.payment == PayModeIdMenu_WCHAT){
                payStr = @"在线支付";
            }
            else if (self.payment == PayModeIdMenu_waiteGoods){
                payStr = @"货到付款";
            }
            NSArray *content = self.staticTitleDict[@"支付方式"];
            if (content.count>1) {
                paymentSsowCell.payChooseButtton.selected = YES;
            }else
            {
                paymentSsowCell.payChooseButtton.selected = NO;
            }
            [paymentSsowCell.payChooseButtton addTarget:self action:@selector(paymentChooseSwitch:) forControlEvents:UIControlEventTouchUpInside];
            
            [paymentSsowCell.payChooseButtton setTitle:payStr forState:UIControlStateNormal];
            //paymentSsowCell.label_paymentShow.text = payStr;
            paymentSsowCell.payChooseButtton.hidden = NO;
            paymentSsowCell.label_paymentShow.textColor = [UIColor darkGrayColor];
            if (self.payments.count > indexPath.row-1) {
                int payModel = [self.payments[indexPath.row - 1] intValue];
                if (payModel == PayModeIdMenu_ZHIFUBAO && indexPath.row == 1) {
                    paymentSsowCell.payChooseButtton.hidden = NO;
                    paymentSsowCell.label_paymentShow.textColor = [UIColor blackColor];
                }else if (payModel == PayModeIdMenu_WCHAT && indexPath.row == 2) {
                    paymentSsowCell.payChooseButtton.hidden = NO;
                    paymentSsowCell.label_paymentShow.textColor = [UIColor blackColor];
                }else if (payModel == PayModeIdMenu_waiteGoods && indexPath.row == 3) {
                    paymentSsowCell.payChooseButtton.hidden = NO;
                    paymentSsowCell.label_paymentShow.textColor = [UIColor blackColor];
                }
            }
            return paymentSsowCell;
        }
        OrderPaymentTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentCell" forIndexPath:indexPath];
        paymentCell.label_title.text = titles[indexPath.row];
        if (self.payment == PayModeIdMenu_ZHIFUBAO && (indexPath.row == 1)) {
            paymentCell.seleted_button.selected = YES;
        } else if (self.payment == PayModeIdMenu_WCHAT&& (indexPath.row == 2)){
            paymentCell.seleted_button.selected = YES;
        }
        else if (self.payment == PayModeIdMenu_waiteGoods && (indexPath.row == 1)){
            paymentCell.seleted_button.selected = YES;
        }
        else{
            paymentCell.seleted_button.selected = NO;
        }
        if (self.payment == PayModeIdMenu_waiteGoods ) {
            paymentCell.PaymentArray = @[@(PayModeIdMenu_waiteGoods)];
        }else
        {
            paymentCell.PaymentArray = @[@(PayModeIdMenu_ZHIFUBAO),@(PayModeIdMenu_WCHAT)];
        }
        [paymentCell setChooicewith:indexPath payMent:^(PayModeIdMenu payment) {
            weakSelf.payment = payment;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return paymentCell;
    }
    else if ([sectionName containsString:@"超值加价购（超值折扣商品不参加活动）"])
    {
        OrderAddPriceBuyTableViewCell *addProceCell = [tableView dequeueReusableCellWithIdentifier:@"AddProceCell"];
        if (!addProceCell) {
            addProceCell = [[OrderAddPriceBuyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddProceCell"];
        }
        if (self.addPricetoBuyDataArray.count) {
            addProceCell.dataArray = self.addPricetoBuyDataArray;
        }
        //在增加了 之后 要修改 这个值
        addProceCell.delegate = self;
        
        return addProceCell;
    }
    else if ([sectionName isEqualToString:@"用餐人数"])
    {
        
        RiceTableViewCell *riceCell = [tableView dequeueReusableCellWithIdentifier:@"RiceCell" forIndexPath:indexPath];
        riceCell.label_title.text = @"用餐人数";
        riceCell.tf_content.placeholder = @"以方便商家给您带够餐具";
        if (self.riceCount>0) {
            NSString *numbe = [NSString stringWithFormat:@"%ld人",(long)self.riceCount];
            if (self.riceCount == 10) {
                numbe = [NSString stringWithFormat:@"%ld人以上",(long)self.riceCount];
            }
            riceCell.tf_content.text = numbe;
        }else
        {
            riceCell.tf_content.text = @"";
        }
        riceCell.clickButtton.tag = indexPath.section;
        [riceCell.clickButtton addTarget:self action:@selector(riceCountAction:) forControlEvents:UIControlEventTouchUpInside];
        return riceCell;
    }
    else if ([sectionName isEqualToString:@"默认商品"])
    {
        ProductModel *defaultProduct  = self.defaultDataArray[indexPath.row];
        OtherActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
        [activityCell.originalView setHidden:YES];
        activityCell.model = defaultProduct;
        
        activityCell.price.text = [NSString stringWithFormat:@"¥%@",Money(defaultProduct.isActivity ? defaultProduct.activityPrice : defaultProduct.price)];
        ;
        
        activityCell.plus.tag = indexPath.row+1;
        activityCell.minus.tag = indexPath.row+1;
        // -
        [activityCell.minus addTarget:self action:@selector(reduceButton_defaultProduct:) forControlEvents:UIControlEventTouchUpInside];
        // +
        [activityCell.plus addTarget:self action:@selector(addButton_defaultProduct:) forControlEvents:UIControlEventTouchUpInside];
        activityCell.addCount.text = [NSString stringWithFormat:@"%d",defaultProduct.shopCount];
        return activityCell;
    }
    else if ([sectionName isEqualToString:@"备注"])
    {
        RiceTableViewCell *riceCell = [tableView dequeueReusableCellWithIdentifier:@"RiceCell" forIndexPath:indexPath];
        riceCell.label_title.text = @"备注";
        riceCell.clickButtton.tag = indexPath.section;
        [riceCell.clickButtton addTarget:self action:@selector(riceCountAction:) forControlEvents:UIControlEventTouchUpInside];
        riceCell.tf_content.placeholder = @"口味、偏好等要求";
        riceCell.tf_content.text = self.noteString;
        return riceCell;
    }
    else
    {
        OrderNormalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"OrderNormalCell" forIndexPath:indexPath];
        normalCell.lineView.hidden = NO;
        [normalCell.henadWidth setConstant:0.01];
        normalCell.headLabel.hidden = YES;
        if (titles) {
            normalCell.label_title.text = titles[indexPath.row];
            if (indexPath.row == titles.count-1) {
                normalCell.lineView.hidden = NO;YES;
            }
        }
        
        [normalCell configUI:sectionName];
        //红包
        if ([sectionName isEqualToString:@"red"]) {
            if (self.redPacketsInfo) {
                normalCell.label_content.text = self.redPacketsInfo.rbName;
                NSString *redS = [NSString stringWithFormat:@"优惠￥%@",Money(self.redPacketsInfo.rbValue)];
                NSString *con = [NSString stringWithFormat:@"%@(%@)",self.redPacketsInfo.rbName,redS];
                normalCell.label_content.attributedText = [con setStrColor:[UIColor redColor] colorStr:redS];
            }else
            {
                normalCell.label_content.text = @"暂无红包可用";
            }
        }else if ([sectionName isEqualToString:@"youhui"])
        {
            normalCell.label_content.text = @"不可享受优惠";
            [normalCell.henadWidth setConstant:17.0];
            normalCell.headLabel.hidden = NO;
            normalCell.headLabel.backgroundColor = [UIColor redColor];
            if ([normalCell.label_title.text isEqualToString:@"满减优惠"]) {
                if (self.reducePreferentialInfo) {
                    normalCell.label_content.text = self.reducePreferentialInfo.whenName;
                }
                normalCell.headLabel.text = @"减";
            }
            if ([normalCell.label_title.text isEqualToString:@"满赠活动"]) {
                if (self.gevePreferentialInfo) {
                    normalCell.label_content.text = self.gevePreferentialInfo.whenGiveName;
                }
                normalCell.headLabel.text = @"赠";
                normalCell.headLabel.backgroundColor = [UIColor orangeColor];
            }
            if ([normalCell.label_title.text isEqualToString:@"新用户红包"]) {
                if (self.redPacketsInfo_newUser) {
                    if ([self isAvialibleForRedPacketsInfo_newUser]) {
                        normalCell.label_content.text = [NSString stringWithFormat:@"￥-%@",Money(self.redPacketsInfo_newUser.rbValue)];
                    }else
                    {
                        normalCell.label_content.text = [NSString stringWithFormat:@"差￥%@可用",Money(self.redPacketsInfo_newUser.rbLimitValue - [self getNormalProductPriceNORedPacketsInfo_newUser] )];
                    }
                }
                normalCell.headLabel.text = @"首";
            }
        }else if ([sectionName isEqualToString:@"已点菜品"])
        {
            normalCell.lineView.hidden = NO;YES;
            if (indexPath.row < (self.addCommitProductModelDataArray.count)) {
                
                OrderMessageProductInfo *product = self.addCommitProductModelDataArray[indexPath.row];
                normalCell.label_title.text = product.productInfo.productName;
                CGFloat pri = product.productInfo.newPrice;
                if (product.orderProductType == ProductTypeAddPriceBuy) {
                    pri = product.productPrice;
                }
                normalCell.label_content.text = [NSString stringWithFormat:@"X%d     %@",product.productInfo.shopCount,MoneySymbol(pri)];
                
            }
        }
        else if ([sectionName isEqualToString:@"address"] && indexPath.row == 1)
        {
            //送达时间
            if (!self.chooseAddressInfo) {
                normalCell.label_content.text = @"请选择地址...";
            }else
            {
                int time = [[self.estimatedFinishTime objectForKey:@"time"] intValue];
                normalCell.label_content.text = [NSString stringWithFormat:@"预计%d分钟后送达",time];
            }
        }
        else if ([sectionName isEqualToString:@"配送费用"])
        {
            if ([normalCell.label_title.text containsString:@"配送费"]) {
                normalCell.label_content.text = MoneySymbol([self.constDataDict[@"posttagePrice"] floatValue]);
            }
            else if ([normalCell.label_title.text containsString:@"餐盒费"])
            {
                normalCell.label_content.text = MoneySymbol([self.constDataDict[@"meelFee"] floatValue]);
            }
        }
        else
        {
            normalCell.label_content.text = @"";
        }
        return normalCell;
    }
}

- (void)paymentChooseSwitch:(UIButton *)btn
{
    //[];
    
    [NormalAlertView showAlertViewForsubTitles:@[@"在线支付",@"货到付款"] invalIndexs:@[@(1)] andClickTitleBlcok:^(NSInteger clickIndex, NSString *title) {
        /*
         NSInteger section = [self.sectionArray indexOfObject:@"支付方式"];
         NSArray *content = self.staticTitleDict[@"支付方式"];
         */
        if (clickIndex == 0) {
            [self.staticTitleDict setObject:@[@"在线支付(微信、支付宝)", @"支付宝", @"微信" ] forKey:@"支付方式"];
            self.payment = PayModeIdMenu_ZHIFUBAO;
        }else
        {
            [self.staticTitleDict setObject:@[@"在线支付(微信、支付宝)", @"货到付款"] forKey:@"支付方式"];
            self.payment = PayModeIdMenu_waiteGoods;
        }
        [self reloadSectionWithSectionTitle:@"支付方式"];
    }];
}
//备注
- (void)inputNoteAction
{
    OrderNoteViewController *noteVC = [[OrderNoteViewController alloc] initWithNibName:@"OrderNoteViewController" bundle:nil];
    noteVC.noteString = self.noteString;
    
    [noteVC setNoteStringBlock:^(NSString *noteStr) {
        self.noteString = noteStr;
        [self reloadSectionWithSectionTitle:@"备注"];
    }];
    [self.superVC.navigationController pushViewController:noteVC animated:YES];
}
//米饭人数选择
- (void)riceCountAction:(UIButton *)btn
{
    NSString *name = self.sectionArray[btn.tag];
    if ([name isEqualToString:@"备注"]) {
        [self inputNoteAction];
        return;
    }
    NSArray *arr = @[@"1人",@"2人",@"3人",@"4人",@"5人",@"6人",@"7人",@"8人",@"9人",@"10人以上",];
    [UIAlertController showInViewController:self.superVC withTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:arr popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        self.riceCount = buttonIndex-1;
        [self updateAllPrice];
        [self reloadSectionWithSectionTitle:@"用餐人数"];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sectionName = self.sectionArray[indexPath.section];
    //NSArray *titles = [self.staticTitleDict objectForKey:sectionName];
    if ([sectionName isEqualToString:@"red"]) {
        //代金券
        MyRedPacketViewController *vc = [[MyRedPacketViewController alloc]init];
        vc.limitPrice = [self getLimitValueOrderRedBag];
        [self.superVC.navigationController pushViewController:vc animated:YES];
        WEAK(weakSelf);
        [vc setChooiceRedPacketInfoOnCompleteBlock:^(RedPacketsInfo *redPacketInfo) {
            weakSelf.redPacketsInfo = redPacketInfo;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf updatePackagingConst];
            [weakSelf updatePreferentialPrice];
        }];
    }
}


#pragma mark - 平台默认商品 的  +  -
- (void)addButton_defaultProduct:(UIButton *)btn
{
    [self changeDefaultProductWith:btn.tag-1 flag:YES];
}
- (void)reduceButton_defaultProduct:(UIButton *)btn
{
    [self changeDefaultProductWith:btn.tag-1 flag:NO];
}

- (void)changeDefaultProductWith:(NSInteger )index flag:(BOOL)isAdd
{
    //更新匹配的  满减 满赠活动  红包         刷新已经优惠 待支付 重新计算    在 提交商品中往map中放商品
    NSInteger section = [self.sectionArray indexOfObject:@"默认商品"];
    NSInteger row = index;
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
    ProductModel *info = self.defaultDataArray[path.row];
    if (isAdd) {
        info.shopCount = info.shopCount + 1;
    }else
    {
        if (info.shopCount>0) {
            info.shopCount = info.shopCount - 1;
        }
    }
    [self.defaultDataArray replaceObjectAtIndex:path.row withObject:info];
    [self updateAllPrice];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    
    [self reloadSectionWithSectionTitle:@"youhui"];
    [self reloadSectionWithSectionTitle:@"red"];
}


- (void)updateAllPrice
{
    [self matchingQueryWhen];
    
    [self matchingOrderRedBag];
    [self matchingQueryWhenGive];
    [self updatePackagingConst];
    [self updatePreferentialPrice];
    [self updateTotalPrice];
}

#pragma mark - OrderAddPriceBuyDelegate
- (void)updateHeadConfigData:(NSArray<AddPricetoBuyConfigInfo*> *)headArray andDataArray:(NSDictionary<id,NSArray<AddPricetoBuyInfo*>*> *)dataDict tableViewCell:(OrderAddPriceBuyTableViewCell *)cell
{
    self.addCommitPricetoBuyDataArray = [[NSMutableArray alloc] init];
    for (AddPricetoBuyConfigInfo *cinfo in headArray) {
        NSArray *arr = dataDict[cinfo.tagId];
        for (AddPricetoBuyInfo *buyInfo in arr) {
            if (buyInfo.productCount) {
                [self.addCommitPricetoBuyDataArray addObject:buyInfo];
            }
        }
    }
    //选择了 超值加价购（超值折扣商品不参加活动）的 菜品
    [self updatePackagingConst];
    [self updatePreferentialPrice];
}






///获取预计送达时间 请求
- (void)getEstimatedFinishTime
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.chooseAddressInfo.id_address forKey:@"id"];
    [params setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId ? [ArriveEarlyManager shared].areaStoreInfo.areaId : @"" forKey:@"areaId"];

    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"searchArrive" url_ex] params:params onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        NSDictionary *dict = responseObject;
        NSDictionary *data = dict[@"responseData"];
        self.estimatedFinishTime = [NSDictionary dictionaryWithObject:@([[data objectForKey:@"arrive"] intValue]) forKey:@"time"];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}
//获取配送费用
- (void)getPostage
{
    WEAK(weakSelf);
    [self showPopupLoading];
    //=====
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findArea" url_ex] params:@{@"areaId" : @"bf1630c6-1cc8-45f5-bf8f-cea0cce38d86"} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self hidePopupLoading];
        if (error) {
            return ;
        }
        NSDictionary *dict = responseObject;
        if ([dict[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            weakSelf.storeInfo = [AreaStoreInfo yy_modelWithDictionary:dict[@"responseData"]];
        }
        [weakSelf.constDataDict setObject:@(weakSelf.storeInfo.dispatchPrice) forKey:@"posttagePrice"];
        NSInteger section = [weakSelf.sectionArray indexOfObject:@"配送费用"];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        [self updateTotalPrice];
    }];
}
#pragma mark - 获取门店信息  (提交订单时候 匹配 起送价格startPrice    营业时间  areaState状态  信息).
- (void)getAreaStoreInfo:(CLLocationCoordinate2D)coordinate
{
    self.storeInfo = nil;
    [self showPopupLoading];
    NSString *areaLocations = [NSString stringWithFormat:@"%f#%f", coordinate.longitude, coordinate.latitude];
    [[[AFBaseNetWork alloc] init] post:[@"findAreaByPoint" url_ex] params:@{@"areaLocations" : areaLocations} progress:nil responseObject:^(id responseObject) {
        [self hidePopupLoading];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            NSString *errStr = dic[@"responseDescription"];
            if ([dic[@"responseCode"] intValue] == 1) {
                NSDictionary *dateDict = dic[@"responseData"];
                if ([dateDict isKindOfClass:[NSDictionary class]]) {
                    self.storeInfo = [AreaStoreInfo yy_modelWithDictionary:dateDict];
                }
            }
        }

        if (self.storeInfo) {
            //更新   起送价格startPrice    营业时间  areaState状态   配送费dispatchPrice
            [self updatedAreaStoreInfo];
        }else
        {
            [self showPopupErrorMessage:@"所选地址不在配送范围内"];
        }
    } onError:^(NSError *error) {
        [self showPopupErrorMessage:error.domain];
    }];

}
//门店信息  更新成功之后  需要去更新的  信息。
- (void)updatedAreaStoreInfo
{
    [self.constDataDict setObject:@(self.storeInfo.dispatchPrice) forKey:@"posttagePrice"];
    [self reloadSectionWithSectionTitle:@"配送费用"];
    [self updateTotalPrice];
    
    //起送
}
//计算 餐盒费  根据点餐实时计算   点击了 超值加价购（超值折扣商品不参加活动） 要更新餐盒费
- (void)updatePackagingConst
{
    CGFloat packagingConst = 0.0;

    for (OrderMessageProductInfo *info in self.addCommitProductModelDataArray) {
        packagingConst = packagingConst + (info.productInfo.meelFee * info.productInfo.shopCount);
    }
    
    ///超值加价购（超值折扣商品不参加活动）商品餐盒费
    for (AddPricetoBuyInfo *addPriceModel in self.addCommitPricetoBuyDataArray) {
        packagingConst = packagingConst + (addPriceModel.productInfo.meelFee * addPriceModel.productCount);
    }
    
    for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
        if (mInfo.shopCount) {
            packagingConst = packagingConst + (mInfo.meelFee * mInfo.shopCount);
        }
    }
    
    [self.constDataDict setObject:@(packagingConst) forKey:@"meelFee"];
    NSInteger section = [self.sectionArray indexOfObject:@"配送费用"];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    [self updateTotalPrice];
}
//更新优惠金额
- (void)updatePreferentialPrice
{
    //正常价格比较+ 满减   红包
    
    //商品活动价 + vipPrice     超值加价购（超值折扣商品不参加活动）价格morePrice
    CGFloat preferentialPrice = 0.0;
    //超值加价购（超值折扣商品不参加活动）
    for (AddPricetoBuyInfo *info in self.addCommitPricetoBuyDataArray) {
        preferentialPrice = preferentialPrice + ((info.productInfo.price - info.morePrice) *info.productCount);
    }
    ///满减   红包
    preferentialPrice = preferentialPrice + self.reducePreferentialInfo.whenValue + self.redPacketsInfo.rbValue;
    for (OrderMessageProductInfo *pInfo in self.addCommitProductModelDataArray) {
        if (pInfo.orderProductType == ProductTypeAddPriceBuy) {
            preferentialPrice = preferentialPrice + ((pInfo.productInfo.price - pInfo.moreConfigEntity.morePrice) * pInfo.productInfo.shopCount);
        }
        else if (pInfo.productInfo.isActivity) {
            preferentialPrice = preferentialPrice + ((pInfo.productInfo.price - pInfo.productInfo.activityPrice) * pInfo.productInfo.shopCount);
        }
    }
    
    for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
        if (mInfo.shopCount) {
            if (mInfo.isActivity) {
                preferentialPrice = preferentialPrice + ((mInfo.price - mInfo.activityPrice) * mInfo.shopCount);
            }
        }
    }
    if (self.redPacketsInfo_newUser && [self isAvialibleForRedPacketsInfo_newUser]) {
        preferentialPrice = preferentialPrice + self.redPacketsInfo_newUser.rbValue;
    }
    [self.constDataDict setObject:@(preferentialPrice) forKey:@"preferentialPrice"];
    
    //self.label_preferential.text = [NSString stringWithFormat:@"已优惠%@",MoneySymbol(preferentialPrice)];
    [self updateTotalPrice];
}
///获取 普通商品 能够参加优惠活动的商品价格
- (CGFloat)getNormalProductPrice
{
    CGFloat price = 0.0;

    for (OrderMessageProductInfo *pInfo in self.addCommitProductModelDataArray) {
//        if (pInfo.orderProductType == ProductTypeAddPriceBuy) {
//            price = price + (pInfo.moreConfigEntity.morePrice * pInfo.productInfo.shopCount);
//        }else
        if (!pInfo.productInfo.isActivity && pInfo.orderProductType != ProductTypeAddPriceBuy) {
            price = price + (pInfo.productInfo.price * pInfo.productInfo.shopCount);
        }
        
    }
    
    
    
    for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
        if (mInfo.shopCount) {
            price = price + (mInfo.price * mInfo.shopCount);
        }
    }
    /// 减去了  新用户红包 在去匹配其他活动
    if (self.redPacketsInfo_newUser && [self isAvialibleForRedPacketsInfo_newUser]) {
        price = price - self.redPacketsInfo_newUser.rbValue;
    }
    
    return price;
}

- (CGFloat)getActivityProductPrice
{
    CGFloat price = 0.0;
    
    for (OrderMessageProductInfo *pInfo in self.addCommitProductModelDataArray) {
        //        if (pInfo.orderProductType == ProductTypeAddPriceBuy) {
        //            price = price + (pInfo.moreConfigEntity.morePrice * pInfo.productInfo.shopCount);
        //        }else
        if (pInfo.productInfo.isActivity && pInfo.orderProductType != ProductTypeAddPriceBuy) {
            price = price + (pInfo.productInfo.activityPrice * pInfo.productInfo.shopCount);
        }
        
    }
  
      return price;
}

///新用户红包是否可用
- (BOOL)isAvialibleForRedPacketsInfo_newUser
{
    CGFloat price = 0.0;
    //for (OrderMessageProductInfo *pInfo in self.addCommitProductModelDataArray) {
    //    if (!pInfo.productInfo.isActivity && pInfo.orderProductType != ProductTypeAddPriceBuy) {
    //        price = price + (pInfo.productInfo.price * pInfo.productInfo.shopCount);
    //    }
    //}
    //for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
    //    if (mInfo.shopCount) {
    //        price = price + (mInfo.price * mInfo.shopCount);
     //   }
    //}
    //if (price >= self.redPacketsInfo_newUser.rbLimitValue) {
    //    return YES;
    //}
    //return NO;
    return YES;
}
- (CGFloat)getNormalProductPriceNORedPacketsInfo_newUser
{
    CGFloat price = 0.0;
    for (OrderMessageProductInfo *pInfo in self.addCommitProductModelDataArray) {
        if (!pInfo.productInfo.isActivity && pInfo.orderProductType != ProductTypeAddPriceBuy) {
            price = price + (pInfo.productInfo.price * pInfo.productInfo.shopCount);
        }
    }
    for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
        if (mInfo.shopCount) {
            price = price + (mInfo.price * mInfo.shopCount);
        }
    }
    return price;
}
- (void)updateTotalPrice
{
    // + self.addCommitPricetoBuyDataArray  超值加价购（超值折扣商品不参加活动）      超值加价购（超值折扣商品不参加活动）商品价格
    // + self.addCommitProductModelDataArray   购物车   分普通商品和活动商品
    // + 公共商品（比如：米饭）
    // + 配送费 + 餐盒费
    // - 红包 - 满减     活动
    CGFloat totalPrice = 0.0;
    for (AddPricetoBuyInfo *info in self.addCommitPricetoBuyDataArray) {
        totalPrice = totalPrice + (info.morePrice * info.productCount);
    }
    
    for (OrderMessageProductInfo *pInfo in self.addCommitProductModelDataArray) {
        if (pInfo.orderProductType == ProductTypeAddPriceBuy) {// pInfo.moreConfigEntity.morePrice
            totalPrice = totalPrice + (pInfo.productPrice * pInfo.productInfo.shopCount);
        }else if (pInfo.productInfo.isActivity) {
            totalPrice = totalPrice + (pInfo.productInfo.activityPrice * pInfo.productInfo.shopCount);
        }else if (!pInfo.productInfo.isActivity)
        {
            totalPrice = totalPrice + (pInfo.productInfo.price * pInfo.productInfo.shopCount);
        }
    }
    
    
    //  默认商品 类型  判断 不能使用 isActivity
    for (ProductModel *mInfo in self.addDefaultCommitProductModelDataArray) {
        if (mInfo.shopCount) {
            totalPrice = totalPrice + (mInfo.price * mInfo.shopCount);
        }
    }
    
    totalPrice = totalPrice + [self.constDataDict[@"posttagePrice"] floatValue] + [self.constDataDict[@"meelFee"] floatValue];
    totalPrice = totalPrice - self.reducePreferentialInfo.whenValue - self.redPacketsInfo.rbValue;
    
    if (self.redPacketsInfo_newUser && [self isAvialibleForRedPacketsInfo_newUser]) {
        totalPrice = totalPrice - self.redPacketsInfo_newUser.rbValue;
    }
    
    
    [self.constDataDict setObject:@(totalPrice) forKey:@"orderPrice"];
    
    NSString *colorstr = MoneySymbol(totalPrice);
    NSString *str = [NSString stringWithFormat:@"待支付%@",colorstr];
    self.label_waitePey.attributedText = [str setStrColor:UIColorFromRGBA(0xfb3c30, 1) colorStr:colorstr];
    
    CGFloat preferentialPrice = [[self.constDataDict objectForKey:@"preferentialPrice"] floatValue];
    
    NSString *yuanjia = [NSString stringWithFormat:@"原价%@",MoneySymbol(preferentialPrice + totalPrice)];
    NSString *youhuiPrice = MoneySymbol(preferentialPrice);
    NSString *youhui = [NSString stringWithFormat:@"已优惠%@",youhuiPrice];

    NSString *con = [NSString stringWithFormat:@"%@  %@",yuanjia,youhui];
    
    
    self.label_preferential.attributedText = [con setStrColor:UIColorFromRGBA(0xfb3c30, 1) colorStr:youhuiPrice];
}






#pragma mark - 验证数据
- (void)validationDataComplete:(void (^)(void))completion
{
    NSString *errStr = nil;
    
    //double time = [NSDate geiNewTimefromeZero];
    
    CGFloat orderPrice = [self.constDataDict[@"orderPrice"] floatValue];
    if (!self.chooseAddressInfo || !self.chooseAddressInfo.id_address || !self.storeInfo) {//选择地址之后 要验证是否在配送范围  使用门店信息去判断
        errStr = @"请选择送货地址";
    }
    else if (orderPrice < self.storeInfo.startPrice)
    {
        //errStr = [NSString stringWithFormat:@"不满足起送价（%@）,无法提交订单...",Money(self.storeInfo.startPrice)];
        errStr = nil;

    }
    else if (self.storeInfo.areaState != AreaStoreState_available)//起送价格startPrice    营业时间  areaState状态
    {
        errStr = @"门店已打烊";
    }
//    else if (time < self.storeInfo.startTime/1000 || time > self.storeInfo.endTime/1000)
//    {
//        errStr = @"现在不在营业时间之内";
//    }
    if ([errStr isEqualToString:@"门店已打烊"]) {
        if (!self.closeView) {
            self.closeView = [ClosingTimeView initCustomView];
        }
        self.closeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        [self.closeView.closeButton addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeView show_custom];
        
        
    }else{
        if (errStr) {
            [self showPopupErrorMessage:errStr];
        }else
        {
            completion();
        }
    }
    
   
}

-(void)closeBtnAction:(UIButton *)button{
    [self.closeView hide_custom];
}



- (void)configWith:(OrderMessageModelInfo *)info
{
    self.orderInfo = info;
    self.constDataDict = [[NSMutableDictionary alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"RiceCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PayMentShowTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentShowCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderNormalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddAddressCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderPaymentTableViewCell" bundle:nil] forCellReuseIdentifier:@"PaymentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityCell"];
    
    UserInfo *userInfo = [ArriveEarlyManager shared].userInfo;
    self.payment = PayModeIdMenu_ZHIFUBAO;
    
    //self.sectionArray = @[@"address", @"支付方式", @"red",@"已点菜品", @"youhui", @"配送费用", @"超值加价购（超值折扣商品不参加活动）", @"默认商品", @"用餐人数", @"备注"];
    
    self.sectionArray = @[@"address", @"支付方式", @"red",@"默认商品",@"已点菜品", @"youhui", @"配送费用", @"超值加价购（超值折扣商品不参加活动）", @"用餐人数", @"备注"];

    
    self.showSectionArray = @[@"超值加价购（超值折扣商品不参加活动）"];
    self.staticTitleDict = [[NSMutableDictionary alloc] init];
    [self.staticTitleDict setObject:@[@"address", @"预计送达时间" ] forKey:@"address"];
    NSMutableArray *pays = [[NSMutableArray alloc] initWithObjects:@"在线支付", nil];
    //[pays addObjectsFromArray:@[@"支付宝", @"微信", @"货到付款" ]];
    [pays addObjectsFromArray:@[@"支付宝", @"微信" ]];
    
    
    [self.staticTitleDict setObject:pays forKey:@"支付方式"];
    [self.staticTitleDict setObject:@[@"卖圈红包" ] forKey:@"red"];
    if ([self.sectionArray containsObject:@"youhui"]) {
        if (userInfo.isTheoldUser) {
            [self.staticTitleDict setObject:@[@"满减优惠", @"满赠活动" ] forKey:@"youhui"];
            
        }else
        {
            ///新用户的
            [self.staticTitleDict setObject:@[@"新用户红包", @"满赠活动"] forKey:@"youhui"];
        }
        
    }
    
    [self.staticTitleDict setObject:@[@"超值加价购（超值折扣商品不参加活动）" ] forKey:@"超值加价购（超值折扣商品不参加活动）"];
    [self.staticTitleDict setObject:@[@"配送费", @"餐盒费" ] forKey:@"配送费用"];
    [self.staticTitleDict setObject:@[@"用餐人数" ] forKey:@"用餐人数"];
    [self.staticTitleDict setObject:@[@"备注" ] forKey:@"备注"];
    
    //self.orderInfo.
    self.addCommitProductModelDataArray = [[NSMutableArray alloc] init];
    //购物车 取出所有商品    并且去服务器拉去  公有商品（比如：米饭）
    for (OrderMessageProductInfo *oinfo in info.orderProducts) {
        if (oinfo.productInfo) {
            
            [self.addCommitProductModelDataArray addObject:oinfo];
        }
    }
    
    [self.tableView reloadData];
    
    [self getAddPricetoBuyProductModel];

}

- (void)reloadSectionWithSectionTitle:(NSString *)secTittle
{
    if (!secTittle) {
        return;
    }
    NSInteger section = [self.sectionArray indexOfObject:secTittle];
    if (section>=0) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)_viewDidAppear:(BOOL)animated
{
    
}




- (NSMutableDictionary *)dataContentDict
{
    if (!_dataContentDict) {
        _dataContentDict  =[[NSMutableDictionary alloc] init];
    }
    return _dataContentDict;
}

- (NSMutableArray <ProductModel *>*)addDefaultCommitProductModelDataArray
{
    if (!_addDefaultCommitProductModelDataArray) {
        _addDefaultCommitProductModelDataArray  = (NSMutableArray <ProductModel *>*)[[NSMutableArray alloc] init];
    }
    [_addDefaultCommitProductModelDataArray removeAllObjects];
    for (ProductModel *mInfo in self.defaultDataArray) {
        if (mInfo.shopCount) {
            [_addDefaultCommitProductModelDataArray addObject:mInfo];
        }
    }
    return _addDefaultCommitProductModelDataArray;
}

- (void)dealloc
{
    DLogMethod();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
