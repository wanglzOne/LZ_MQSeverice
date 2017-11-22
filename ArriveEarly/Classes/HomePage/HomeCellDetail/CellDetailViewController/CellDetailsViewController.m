//
//  CellDetailsViewController.m
//  ArriveEarly
//
//  Created by m on 2016/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "CellDetailsViewController.h"
#import "CellDetailsCollectionViewCell.h"
#import "CommentViewController.h"
#import "ShoppingCarView.h"
#import "OrderSettlementViewController.h"
#import "EvalutionModel.h"
#import "LoginViewController.h"

@interface CellDetailsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ShoppingCarViewDelegate,UIScrollViewDelegate>
{
    PackagMet *packagMet;
    //加载collectionView的一个方法时在ViewDidApper中调用一次
    BOOL isDone;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) ShoppingCarView *shoppingView;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *settleAcountBtn;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;
@property (nonatomic ,strong) AutomaticRollingView *scView;

@property (nonatomic ,strong) NSMutableArray *evalutionAry;//存各商品的评论信息


@property (weak, nonatomic) IBOutlet UIView *navLeftView;
@property (weak, nonatomic) IBOutlet UIButton *navRigthButton;
@property (weak, nonatomic) IBOutlet UIView *norShopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *norShopViewBottom;

@end

@implementation CellDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadLocationData];
    [self initData];
    [self initEvaluateNetWoriking];    
    [self initInterFace];
    [self initSettleBtnAndShoppingCarBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"refreshDetail" object:nil];
    isDone = YES;
    
    ProductModel *model = self.dataSource[self.index];
    
    self.scView = [[AutomaticRollingView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth*0.5345) WithNetImageUrls:[self getImagefor:model] localPlaceholderImages:[self getPlacefor:model]];
    [self.view addSubview:self.scView];
    
    [self.view bringSubviewToFront:self.navLeftView];
    [self.view bringSubviewToFront:self.navRigthButton];
    
    
    //_collectionView.visibleCells;
}

- (IBAction)rightShareButton:(id)sender {
    [self shareAction:sender];
}

-(void)reloadLocationData{
    [self initSettleBtnAndShoppingCarBtn];
}

-(void)initData{
    self.evalutionAry = [[NSMutableArray alloc]init];
    packagMet = [[PackagMet alloc]init];
    [packagMet initHUDProgresSelfView:self title:@"正在加载..."];
}
//评论信息网络请求
-(void)initEvaluateNetWoriking
{
    NSMutableArray *idsAry = [[NSMutableArray alloc]init];
    for (ProductModel *model in self.dataSource) {
        [idsAry addObject:model.productId];
    }
    [packagMet initShowProgressHud:self];
    [[[AFBaseNetWork alloc] init] post:[@"findGoodEva" url_ex] params:@{@"ids":[idsAry yy_modelToJSONString]} progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                EvalutionModel *model = [EvalutionModel yy_modelWithDictionary:dic];
                [ary addObject:model];
            }
            [self.evalutionAry removeAllObjects];
            self.evalutionAry = [NSMutableArray arrayWithArray:ary];
            [self.collectionView reloadData];
            [packagMet initHideProgressHud];
        }
        
    } onError:^(NSError *error) {
      
        [packagMet initHideProgressHud];
    }];
    
}

-(void)initInterFace
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ScreenWith, ScreenHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource= self;
    self.collectionView.pagingEnabled = YES;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CellDetailsCollectionViewCell"];
    
    
    //  wanglz
    
    
    //指定显示cell
//    self.collectionView.contentOffset = CGPointMake(KScreenWidth* self.index, 0);
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    if (_collectionView == scrollView) {
        
        NSInteger  index = scrollView.contentOffset.x/KScreenWidth;
        ProductModel *model = self.dataSource[index];
        [self.scView refreshWithNetImageUrls:[self getImagefor:model] localPlaceholderImages:[self getPlacefor:model]];
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_collectionView == scrollView) {
        
        NSInteger  index = scrollView.contentOffset.x/KScreenWidth;
        
        NSLog(@"%ld",index);
        
    }
}

#pragma mark ------UICollectionViewDelegateDataSource-------
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *identifer = @"CellDetailsCollectionViewCell";
    CellDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
    
    
    
    //测试
    ProductModel *am = self.dataSource[indexPath.row];
    NSString *aa = [NSString stringWithFormat:@"%d",am.shopCount];
    NSLog(@"collectionView.............................该商品购物车数量为%@",aa);
    
    cell.isStart = self.isStart;
    cell.model = self.dataSource[indexPath.row];
    
    if (self.evalutionAry.count <= 0) {
        
    }else{
        cell.evaModel = self.evalutionAry[indexPath.row];
    }
    cell.addShoppingBtn.tag = indexPath.row + 10000;
    cell.plusBtn.tag = indexPath.row + 20000;
    cell.minusBtn.tag = indexPath.row + 30000;
    cell.shareBtn.tag = indexPath.row + 40000;
    cell.numberValuation.tag = indexPath.row + 50000;
    
    cell.collectionButton.tag = indexPath.row + 60000;
    
    [cell.addShoppingBtn addTarget:self action:@selector(addShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [cell.plusBtn addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusBtn addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.numberValuation addTarget:self action:@selector(valutionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectionButton.selected = am.isCollection==2?YES:NO;
    [cell.collectionButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#pragma mark ------collectionViewCell 中点击事件
//收藏
- (void)collectionButtonAction:(UIButton *)collectionButton
{
    [ArriveEarlyManager loginSuccess:^{
        NSInteger row = collectionButton.tag - 60000;
        CellDetailsCollectionViewCell *cell = (CellDetailsCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        cell.collectionButton.selected = !cell.collectionButton.selected;
        ProductModel *am = self.dataSource[row];
        int flog = cell.collectionButton.selected? 2 : 1;
        kShowProgress(self);
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"addCollection" url_ex] params:@{@"products" : [@[am.productId] yy_modelToJSONString],
                                                                                  @"flag" : @(flog)} onCommonBlockCompletion:^(id responseObject, NSError *error) {
                                                                                      kHiddenProgress(self);
            if (error) {
                [self.view showPopupErrorMessage:error.domain];
                return ;
            }
            if (cell.collectionButton.selected) {
                am.isCollection = 2;
            }else{
                am.isCollection = 1;
                
            }
        }];
        
        
        
    } fail:^{
        [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
            [self.view showPopupOKMessage:@"请重新操作"];
        }];
        return ;
    }];
}
-(void)addShoppingCar:(UIButton *)sender
{
    NSInteger index = sender.tag - 10000;
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    
    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.activityConfig onComplete:^(BOOL isFlag, NSError *error) {
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        
        CellDetailsCollectionViewCell *cell = (CellDetailsCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        cell.addShoppingBtn.hidden = YES;
        cell.footView.hidden = NO;
        
        cell.addCount.text = [NSString stringWithFormat:@"%d",[cell.addCount.text intValue] + 1];
        
        //[manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.activityConfig];
        [self initSettleBtnAndShoppingCarBtn];
        [self.shoppingView reloadData];
        [self.shoppingView.tableView reloadData];
        
    }];
    
    
    
    
}
-(void)plusAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 20000;
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];

    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.activityConfig onComplete:^(BOOL isFlag, NSError *error) {
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        CellDetailsCollectionViewCell *cell = (CellDetailsCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.addCount.text = [NSString stringWithFormat:@"%d",[cell.addCount.text intValue] + 1];
        
        //[manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.activityConfig];
        [self.shoppingView reloadData];
        [self.shoppingView.tableView reloadData];
        [self initSettleBtnAndShoppingCarBtn];
    }];
    
    
    
    
}
-(void)minusAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 30000;
    CellDetailsCollectionViewCell *cell = (CellDetailsCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.addCount.text = [NSString stringWithFormat:@"%d",[cell.addCount.text intValue] - 1];
    NSLog(@"_______________self.addCount.text");
    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:-1 andProductConfig:self.activityConfig];
    if ([cell.addCount.text intValue] <= 0) {
        cell.addShoppingBtn.hidden = NO;
        cell.footView.hidden = YES;
    }
    [self initSettleBtnAndShoppingCarBtn];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
}

-(void)shareAction:(UIButton *)sender
{
    //NSInteger index = sender.tag - 40000;
    //CellDetailsCollectionViewCell *cell = (CellDetailsCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
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
    
    CellDetailsCollectionViewCell *cell = self.collectionView.visibleCells.firstObject;
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    ProductModel *am = self.dataSource[path.row];
    //NSString *url = [NSString stringWithFormat:@"www.myquan.com.cn/mq/webs/proid=%@",am.productId];
    NSString *url = @"www.myquan.com.cn/app.html";

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:am.productName descr:am.productDesc thumImage:am.mainCoverImageUrl?[am.mainCoverImageUrl imageUrl]:[UIImage imageNamed:@"AppIcon"]];
    

    //设置网页地址
    shareObject.webpageUrl = url;

    
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
-(void)valutionBtnAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 50000;
    CellDetailsCollectionViewCell *cell = (CellDetailsCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    if([cell.numberValuation.titleLabel.text isEqualToString:@"暂无任何评论>"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂无任何评论" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        CommentViewController *vc = [[CommentViewController alloc]init];
        NSDictionary *dic = [self.dataSource[index] yy_modelToJSONObject];
        
        vc.productId = dic[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark-----底部购物车的状态栏
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
        
        
        self.norShopView.hidden = NO;
        [self.norShopViewBottom setConstant:0.01];
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
        
        [self.norShopViewBottom setConstant:-CGRectGetHeight(self.norShopView.frame)];
        self.norShopView.hidden = YES;
    }
    
}
#pragma mark-----购物车点击事件
- (IBAction)shoppingAction:(UIButton *)sender {
    
     [self.shoppingView isHidden:NO];
}

#pragma mark-----结算按钮点击事件
- (IBAction)settleAction:(UIButton *)sender {
    
    [OrderSettlementViewController changeFormeViewController:self onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
    }];
}
#pragma  mark  -------SHoppingViewDelegate------
-(void)refreshControllerView
{
    //动态更新Model数据否则界面无法正常刷新
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSMutableArray *data = [manager getLcationData];
    
    NSMutableArray *idAry = [[NSMutableArray alloc]init];
    for (int i = 0; i < data.count; i++) {
        ProductModel *newModel = data[i];
        [idAry addObject:newModel.productId];
    }
    //不减为0 的情况
    for (int i = 0 ; i < data.count; i++) {
        ProductModel *newModel = data[i];
        for (int j=0; j < self.dataSource.count; j++) {
            ProductModel *nowModel = self.dataSource[j];
            if ([nowModel.productId isEqualToString:newModel.productId] && nowModel.isActivity == newModel.isActivity) {
                nowModel.shopCount = newModel.shopCount;
            }
            if (![idAry containsObject:nowModel.productId]) {
                nowModel.shopCount = 0;
            }
        }
    }
    if (data.count <= 0) {
        
        for (int j=0; j < self.dataSource.count; j++) {
            ProductModel *nowModel = self.dataSource[j];
            nowModel.shopCount = 0;
        }
        
    }
    
    [self.collectionView reloadData];
    [self initSettleBtnAndShoppingCarBtn];
}
-(void)backRefresh
{
    //动态更新Model数据否则界面无法正常刷新
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSMutableArray *data = [manager getLcationData];
    
    NSMutableArray *idAry = [[NSMutableArray alloc]init];
    for (int i = 0; i < data.count; i++) {
        ProductModel *newModel = data[i];
        [idAry addObject:newModel.productId];
    }
    //不减为0 的情况
    for (int i = 0 ; i < data.count; i++) {
        ProductModel *newModel = data[i];
        for (int j=0; j < self.dataSource.count; j++) {
            ProductModel *nowModel = self.dataSource[j];
            if ([nowModel.productId isEqualToString:newModel.productId] && nowModel.isActivity == newModel.isActivity) {
                nowModel.shopCount = newModel.shopCount;
            }
            //
            if (![idAry containsObject:nowModel.productId]) {
                nowModel.shopCount = 0;
            }
        }
    }
    if (data.count <= 0) {
        
            for (int j=0; j < self.dataSource.count; j++) {
                ProductModel *nowModel = self.dataSource[j];
                    nowModel.shopCount = 0;                
            }
        
    }
    
    [self.collectionView reloadData];
    [self initSettleBtnAndShoppingCarBtn];
}


- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //返回，刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellDetailRefresh" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
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
    
    if (isDone == YES) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        isDone = NO;
        [self uplodProductCollectionMessage:self.index];
    }
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.scView removeTimer];
    self.collectionView.delegate = nil;
}
///查询知道 商品的 收藏状态
- (void)uplodProductCollectionMessage:(NSInteger)row
{
    ProductModel *am = self.dataSource[row];
    if (am.isCollection != 0) {
        return;
    }
    [ArriveEarlyManager loginSuccess:^{
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"isCollection" url_ex] params:@{@"productId" : am.productId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            if (error) {
                return ;
            }
            NSDictionary *dic = responseObject;
            if (dic[@"responseData"] != (id)kCFNull) {
                am.isCollection = [dic[@"responseData"] intValue];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.index inSection:0]]];
            }
        }];
    } fail:^{
        
    }];

    

}
- (NSArray *)getImagefor:(ProductModel   *)model
{
    NSMutableArray *img = [[NSMutableArray alloc] init];
    for (ProductImageInfo *info in model.productImage) {
        if ([info.image_url isKindOfClass:[NSString class]] && info.is_cover==0) {
            [img addObject:[info.image_url imageUrl]];
        }
    }
    return img;
}
- (NSArray *)getPlacefor:(ProductModel   *)model
{
    NSMutableArray *img = [[NSMutableArray alloc] init];
    for (ProductImageInfo *info in model.productImage) {
        if ([info.image_url isKindOfClass:[NSString class]] && info.is_cover==0) {
            [img addObject:@"banner1"];
        }
    }
    if (!img.count) {
        [img addObject:@"banner1"];
    }
    return img;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    
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
