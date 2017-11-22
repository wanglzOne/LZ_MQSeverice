//
//  SeckillViewController.m
//  ArriveEarly
//
//  Created by m on 2016/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "SeckillViewController.h"
#import "SeckillTableViewCell.h"
#import "AECellDetailViewController.h"
#import "CellDetailsViewController.h"
#import "ShoppingCarView.h"
#import "ProductModel.h"
#import "ProductTypeModel.h"
#import "OrderSettlementViewController.h"
#import "AutomaticRollingView.h"
#import "SeckillRulesViewController.h"

@interface SeckillViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingCarViewDelegate>
{
    BOOL isRefresh;
    PackagMet *packagMet;
    AutomaticRollingView *scView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic ,assign)long long suplus;
@property (nonatomic ,strong) ShoppingCarView * shoppingView;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *settleAcountBtn;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;//

@property (nonatomic ,strong) PageHelper *helper;
@property (weak, nonatomic) IBOutlet UIView *norShopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *norShopViewBottom;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation SeckillViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self.timer invalidate];
    //self.timer = nil ;
    //[scView removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"haveNoData" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellDetailRefresh" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.suplus = -1;
    self.titleLabel.text = self.configDict[@"activityName"];
    
    [self initData];
    //[self initNetWorking];
    [self initInterFace];
    [self reloadLocationData];
    //[self initSettleBtnAndShoppingCarBtn];
    [self loadNormalStateData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"refreshView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backRefresh) name:@"haveNoData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backRefresh) name:@"cellDetailRefresh" object:nil];
    NSMutableArray *placeIma = [[NSMutableArray alloc] initWithObjects:@"banner3", nil];
    for (int i=1; i<self.configModel.listImage_isCover0.count; i++) {
        [placeIma addObject:@"banner3"];
    }
    
    scView = [[AutomaticRollingView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200) WithNetImageUrls:self.configModel.listImage_isCover0 localPlaceholderImages:placeIma];
    scView.autoScrollDelay = 2;
    
//    [self.view addSubview:scView];
    [self.headView addSubview:scView];
    [self.headView sendSubviewToBack:scView];
    WEAK(weakSelf);
    [scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.headView);
        make.bottom.equalTo(weakSelf.headView).offset(0);
        make.top.equalTo(weakSelf.headView).offset(0);
    }];
    //self.tableView.tableHeaderView = self.headView;
}

-(void)reloadLocationData{
    [self initSettleBtnAndShoppingCarBtn];
}

-(void)initData{
    //
    ActivityConfigModel *secondsKillModel = [ArriveEaryDefaultConfigManager shared].secondsKillEveryDayConfigModel;
    SecondsKillActivityState sate = [ArriveEaryDefaultConfigManager shared].activityState;
    if (sate == SecondsKillActivityState_NO) {
        
        self.suplus = 0;
        self.toEndlabel.text = @"暂时没活动";
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
    }else if(sate == SecondsKillActivityState_NOStart) {
        self.toEndlabel.text = @"距离活动开始";
        self.suplus = (secondsKillModel.activityEffStart - secondsKillModel.newDate)/1000;
        [self updateTimer];
    }
    else if(sate == SecondsKillActivityState_AlreadyStart) {
        self.toEndlabel.text = @"距离活动结束";
        self.suplus = (secondsKillModel.activityEffEnd - secondsKillModel.newDate)/1000;
        [self updateTimer];
    }else if(sate == SecondsKillActivityState_End) {

        self.toEndlabel.text = @"活动已经结束";
        self.suplus = 0;
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
    }
    
    
    
    self.dataSource = [[NSMutableArray alloc]init];
    
    isRefresh = NO;
    packagMet = [[PackagMet alloc]init];
    //[packagMet initHUDProgresSelfView:self title:@"正在加载..."];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    
    
}

-(void)updateTimer
{
    --self.suplus;
    if (self.suplus <0) {
        self.suplus = 0;
    }
    //赋值
    if(self.suplus / 3600 < 10)
    {
        self.hourLabel.text = [NSString stringWithFormat:@"0%lld",self.suplus / 3600];
    }
    else{
        self.hourLabel.text = [NSString stringWithFormat:@"%lld",self.suplus / 3600];
    }
    if (self.suplus % 3600 / 60 < 10) {
        self.minuteLabel.text = [NSString stringWithFormat:@"0%lld",self.suplus % 3600 / 60];
    }
    else{
        self.minuteLabel.text = [NSString stringWithFormat:@"%lld",self.suplus % 3600 / 60];
    }
    if (self.suplus % 3600 % 60 < 10) {
        self.secondLabel.text = [NSString stringWithFormat:@"0%lld",self.suplus % 3600 % 60];
    }
    else{
        self.secondLabel.text = [NSString stringWithFormat:@"%lld",self.suplus % 3600 % 60];
    }
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
        
        self.norShopView.hidden = YES;
        [self.norShopViewBottom setConstant:-CGRectGetHeight(self.norShopView.frame)];
    }
    
}
- (void)loadNormalStateData
{
    WEAK(weakSelf);
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }
    if (!self.tableView.mj_header) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
    [self.tableView.mj_header beginRefreshing];
}
//下拉刷新
- (void)headerRefresh
{
    isRefresh = YES;
    self.helper = [[PageHelper alloc]init];    
    [self.tableView.mj_footer setHidden:NO];
    [self initNetWorking];
    
    
}
//上拉加载
- (void)footerRefresh
{
    self.tableView.mj_footer.hidden = NO;

    [self.helper add];
    [self initNetWorking];
    
}
- (void)endRefreshing
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)endFooterRefreshing
{
    [self.tableView.mj_footer endRefreshing];
}
-(void)initNetWorking
{
    [packagMet initShowProgressHud:self];
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]initWithDictionary:self.helper.params];
    
    NSString *areaid = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaid = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }
    [parm setObject:@{@"activityId":self.activityID == nil ? @(0):self.activityID,
                      @"areaId" : areaid } forKey:@"params"];
    [parm setObject:areaid forKey:@"areaId"];
    
    
    AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
    WEAK(weakSelf);
    [net post:[@"activityProducts" url_ex] params:parm progress:nil responseObject:^(id responseObject) {
        
        [self endRefreshing];
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            
            //计算活动剩余时间
            if ([responseObject[@"responseData"][@"object"] isKindOfClass:[NSArray class]]) {
                NSArray *bject = responseObject[@"responseData"][@"object"];
                if (bject.count && [bject[0] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *objectDict = responseObject[@"responseData"][@"object"][0];
                    if ([objectDict[@"activityConfig"] isKindOfClass:[NSDictionary class]] && objectDict[@"activityConfig"][@"activityEffEnd"] != (id)kCFNull ){
                        long long activityEffStart = [responseObject[@"responseData"][@"object"][0][@"activityConfig"][@"activityEffStart"] longLongValue];
                        long long activityEffEnd = [responseObject[@"responseData"][@"object"][0][@"activityConfig"][@"activityEffEnd"] longLongValue];
                        long long nowDate = [responseObject[@"responseData"][@"nowDate"] longLongValue];
                        if (activityEffStart < nowDate && activityEffEnd > nowDate) {
                        }else
                        {
                        }
                        if (activityEffStart > nowDate) {
                            //活动未开始
                            
                        }
                    }
                }
            }
            
            
            
            
            
            
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]] && [responseObject[@"responseData"][@"object"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in responseObject[@"responseData"][@"object"]) {
                    ProductModel *model = [ProductModel special_yy_modelWithDictionary:dic];
                    if (model) {
                        [ary addObject:model];
                    }
                }
            }
            
            //来处理和本地数据对比加载界面
            ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
            NSMutableArray *shop = [[NSMutableArray alloc]init];
            shop = [manager getLcationData];
            //ary 请求数据   shop 本地加入购物车的数据
            for (ProductModel *shopData in shop) {
                for (int i =0; i < ary.count; i++) {
                    ProductModel *allData = ary[i];
                    if ([shopData.productId isEqualToString:allData.productId] && shopData.isActivity == allData.isActivity) {
                        allData.shopCount = shopData.shopCount;
                    }
                }
            }
            //
           
            if (isRefresh == YES) {
                [weakSelf.dataSource removeAllObjects];
            }
            [weakSelf.dataSource addObjectsFromArray:ary];
            //if (weakSelf.dataSource.count < weakSelf.helper.total) {
             //   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            //   weakSelf.tableView.mj_footer.hidden = YES;
           // }
           //[self.tableView reloadData];
            
        }
        else{
        //
            //self.dataSource = [[NSMutableArray alloc]init];
            //[weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            //.tableView.mj_footer.hidden = YES;

        }
        if (weakSelf.dataSource.count < weakSelf.helper.total) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
           weakSelf.tableView.mj_footer.hidden = YES;
            
        }
        
        [weakSelf.tableView reloadData];
        

        
        isRefresh = NO;
        [packagMet initHideProgressHud];
    }
      onError:^(NSError *error) {
          
          [self.helper falseAdd];
          [self endRefreshing];
          [packagMet initHideProgressHud];
      }];
    
    
}
-(void)initInterFace{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(void)toEndtime
{
    if (self.suplus == 0 ) {
        //__________________当时间走完以后__________________进行处理______________
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
        [self.timer invalidate];
        self.timer = nil ;
        self.sunImageView.image = [UIImage imageNamed:@"zc"];
        self.toEndlabel.textColor = HWColor(207, 206, 204);
    }
    if (self.suplus < 0) {
        //
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
        [self.timer invalidate];
        self.timer = nil ;
        self.sunImageView.image = [UIImage imageNamed:@"zc"];
        self.toEndlabel.textColor = HWColor(207, 206, 204);
    }
    if(self.suplus > 0){
        
        self.sunImageView.image = [UIImage imageNamed:@"zcon"];
        
    }
}
#pragma  mark ------UITableViewDelegateDataSource-------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeckillTableViewCell *cell = [SeckillTableViewCell creatCell:tableView];
    cell.model = self.dataSource[indexPath.row];
    
    if (self.isShow == YES) {
        cell.btnView.hidden = NO;
        cell.btnLabel.layer.cornerRadius = 11;
        cell.btnLabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
        cell.btnLabel.layer.borderWidth=0.4;
        
        cell.minus.hidden = YES;
        cell.addCount.hidden = YES;
        cell.plus.hidden = YES;
    }
    else{
        cell.btnView.hidden = YES;
    }
    
    cell.plus.tag = indexPath.row + 1000;
    cell.minus.tag = indexPath.row +2000;
    [cell.plus addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minus addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([cell.addCount.text intValue] <= 0 ) {
        cell.minus.hidden = YES;
        cell.addCount.hidden = YES;
    }
    else
    {
        cell.minus.hidden = NO;
        cell.addCount.hidden = NO;
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    AECellDetailViewController *vc = [[AECellDetailViewController alloc]init];
//    vc.model = self.dataSource[indexPath.row];
//    vc.isActivity = YES;
    
    
    //来处理和本地数据对比加载界面
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSMutableArray *shop = [[NSMutableArray alloc]init];
    shop = [manager getLcationData];
    //ary 请求数据   shop 本地加入购物车的数据
    for (ProductModel *shopData in shop) {
        for (int i =0; i < self.dataSource.count; i++) {
            ProductModel *allData = self.dataSource[i];
            if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
                allData.shopCount = shopData.shopCount;
            }
        }
    }
    ProductModel *am = self.dataSource[indexPath.row];
    NSString *aa = [NSString stringWithFormat:@"%d",am.shopCount];
    NSLog(@".............................该商品购物车数量为%@,isActivity is %d",aa,am.isActivity);
    CellDetailsViewController *vc = [[CellDetailsViewController alloc]init];
    vc.dataSource = [NSMutableArray arrayWithArray:self.dataSource];
    vc.index = indexPath.row;
    vc.activityConfig = self.configModel;
    vc.isActivity = YES;
    if (self.isShow == YES) {
        vc.isStart = NO;
    }
    else
    {
        vc.isStart = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -----cell中控件点击事件------
-(void)plusAction:(UIButton*)sender{
    NSInteger index = sender.tag - 1000;
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.configModel onComplete:^(BOOL isFlag, NSError *error) {
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        
        SeckillTableViewCell *cell = (SeckillTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.minus.hidden = NO;
        cell.addCount.hidden = NO;
        
        //    z
        if ([cell.addCount.text isEqualToString:@"1"]) {
            cell.addCount.text = @"1";
            
        }else{
            cell.addCount.text = [NSString stringWithFormat:@"%d",[cell.addCount.text intValue] + 1];
        }
        for (ProductModel *shopData in manager.productData) {
            for (int i =0; i < self.dataSource.count; i++) {
                ProductModel *allData = self.dataSource[i];
                if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
                    allData = shopData;
                    [self.dataSource replaceObjectAtIndex:i withObject:shopData];
                }
            }
        }
        [self.tableView reloadData];
        [self initSettleBtnAndShoppingCarBtn];
        [self.shoppingView reloadData];
        [self.shoppingView.tableView reloadData];
    }];
    //[manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.configModel];
}
-(void)minusAction:(UIButton *)sender{
    NSInteger index = sender.tag -2000;
    SeckillTableViewCell *cell = (SeckillTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.addCount.text = [NSString stringWithFormat:@"%d",[cell.addCount.text intValue] - 1];
    // 计算总价
    // 设置总价
    // 将商品从购物车中移除
    NSLog(@"---------->%d",[cell.addCount.text intValue]);
    
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:-1 andProductConfig:self.configModel];
//    if([cell.addCount.text intValue] <= 0){
//        isRefresh = YES;
//        [self initNetWorking];
//    }
//    else{
//        cell.minus.hidden = NO;
//        cell.addCount.hidden = NO;
//        for (ProductModel *shopData in manager.productData) {
//            for (int i =0; i < self.dataSource.count; i++) {
//                ProductModel *allData = self.dataSource[i];
//                if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
//                    allData = shopData;
//                    [self.dataSource replaceObjectAtIndex:i withObject:shopData];
//                }
//            }
//        }
//        [self.tableView reloadData];
//    }
    
    for (int i =0; i < self.dataSource.count; i++) {
        ProductModel *allData = self.dataSource[i];
        BOOL seeked = FALSE;
        for (ProductModel *shopData in manager.productData) {
            if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
                allData = shopData;
                seeked = TRUE;
                [self.dataSource replaceObjectAtIndex:i withObject:shopData];
            }
        }
        if(!seeked){
            allData.shopCount = 0;
        }
        
    }
    [self.tableView reloadData];
    
    
    [self initSettleBtnAndShoppingCarBtn];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
}

#pragma mark -----ShoppingCarView-----
-(void)refreshControllerView
{
    isRefresh = YES;
    [self initNetWorking];
    [self initSettleBtnAndShoppingCarBtn];
}
-(void)backRefresh
{
    //isRefresh = YES;
    //[self initNetWorking];
    [self initSettleBtnAndShoppingCarBtn];
    
     ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    for (int i =0; i < self.dataSource.count; i++) {
        ProductModel *allData = self.dataSource[i];
        BOOL seeked = FALSE;
        for (ProductModel *shopData in manager.productData) {
            if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
                allData = shopData;
                seeked = TRUE;
                [self.dataSource replaceObjectAtIndex:i withObject:shopData];
            }
        }
        if(!seeked){
            allData.shopCount = 0;
        }
        
    }

    [self.tableView reloadData];
    
}
#pragma mark 接受通知后的操作
-(void)refreshView
{
    isRefresh = YES;
    [self initNetWorking];
    [self initSettleBtnAndShoppingCarBtn];
}

#pragma mark ----购物车按钮点击----
- (IBAction)shoppingCarBtnAction:(UIButton *)sender {
    [self.shoppingView isHidden:NO];
    [self.view bringSubviewToFront:self.shoppingView];
}
#pragma mark ----结算按钮点击----
- (IBAction)settleAcountBtnAction:(UIButton *)sender {
    
    [OrderSettlementViewController changeFormeViewController:self onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
        [self initSettleBtnAndShoppingCarBtn];
        [self.tableView.mj_header beginRefreshing];
    }];
}

//规则介绍
- (IBAction)ruleIntroduction:(UIButton *)sender {
    DLog(@"规则介绍");
    SeckillRulesViewController *ruleVC = [[SeckillRulesViewController alloc]init];
    
    [self.navigationController pushViewController:ruleVC animated:YES];
}



- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scView setUpTimer];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //购物车
    self.shoppingView = [ShoppingCarView initCustomView];
    self.shoppingView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.shoppingView.delegate =self;
    self.shoppingView.vc = self;
    self.shoppingView.isActivity = YES;
    [self.shoppingView isHidden:YES];
    [self.shoppingView reloadData];//到时候有数据了理一下传过来的顺序
    [self.view addSubview:self.shoppingView];
}
- (ActivityConfigModel *)configModel
{
    if (!_configModel) {
        _configModel = [ActivityConfigModel yy_modelWithDictionary:self.configDict];
    }
    return _configModel;
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
