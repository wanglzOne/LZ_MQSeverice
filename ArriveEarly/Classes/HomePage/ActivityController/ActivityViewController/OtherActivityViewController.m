//
//  OtherActivityViewController.m
//  ArriveEarly
//
//  Created by m on 2016/11/12.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OtherActivityViewController.h"
#import "OtherActivityTableViewCell.h"
#import "AECellDetailViewController.h"
#import "CellDetailsViewController.h"
#import "ProductModel.h"
#import "ProductTypeModel.h"
#import "ShoppingCarView.h"
#import "OrderSettlementViewController.h"

#import "AutomaticRollingView.h"

@interface OtherActivityViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingCarViewDelegate>
{
    BOOL isRefresh;
    PackagMet *packagMet;
    AutomaticRollingView *scView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;

@property (weak, nonatomic) IBOutlet UIButton *settleAcountBtn;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;



@property (nonatomic ,strong) ShoppingCarView *shoppingView;
@property (nonatomic ,strong) PageHelper *helper;

@property (weak, nonatomic) IBOutlet UIView *shhopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;



@end

@implementation OtherActivityViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [scView removeTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.configDict[@"activityName"];;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initData];
    //[self initNetWorking];
    [self initInterFace];
    [self reloadLocationData];
    //[self initSettleBtnAndShoppingCarBtn];
    [self loadNormalStateData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:@"refreshView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"haveNoData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"cellDetailRefresh" object:nil];
    NSMutableArray *placeIma = [[NSMutableArray alloc] initWithObjects:@"banner2", nil];
    for (int i=1; i<self.configModel.listImage_isCover0.count; i++) {
        [placeIma addObject:@"banner2"];
    }
    
    scView = [[AutomaticRollingView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth*0.5345) WithNetImageUrls:self.configModel.listImage_isCover0 localPlaceholderImages:placeIma];
    scView.autoScrollDelay = 2;
    
    self.tableView.tableHeaderView  = scView;
    self.tableView.contentInset = UIEdgeInsetsMake(20,0,0,0);

    
}

-(void)reloadLocationData{
    [self initSettleBtnAndShoppingCarBtn];
}

-(void)initData
{
    self.dataSource = [[NSMutableArray alloc]init];
    isRefresh = NO;
    packagMet = [[PackagMet alloc]init];
    [packagMet initHUDProgresSelfView:self title:@"正在加载..."];
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
        
        self.shhopView.hidden = NO;
        [self.tableBottom setConstant:0.01];
        
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

        [self.tableBottom setConstant:-CGRectGetHeight(self.shhopView.frame)];

        self.shhopView.hidden = YES;
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

-(void)initNetWorking
{
    //NSMutableDictionary * parm = [[NSMutableDictionary alloc]init];
    NSMutableDictionary * parm = [[NSMutableDictionary alloc]initWithDictionary:self.helper.params];
    AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
    WEAK(weakSelf);
    
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        [parm setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId forKey:@"areaId"];
    }
    
    NSString *areaid = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaid = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }
    [parm setObject:@{@"activityId":self.activityID == nil ? @(0):self.activityID,
                      @"areaId" : areaid } forKey:@"params"];
    [parm setObject:areaid forKey:@"areaId"];
    
    [net post:[@"activityProducts" url_ex] params:parm progress:nil responseObject:^(id responseObject) {
        [weakSelf endRefreshing];
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            //weakSelf.titleLabel.text = responseObject[@"responseData"][@"object"][0][@"activityConfig"][@"activityName"];
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
            if (isRefresh == YES) {
                [weakSelf.dataSource removeAllObjects];
            }
            [weakSelf.dataSource addObjectsFromArray:ary];
            
        }
        else{
            //
            //weakSelf.dataSource = [[NSMutableArray alloc]init];
        }
        //
        if (weakSelf.dataSource.count < weakSelf.helper.total) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            weakSelf.tableView.mj_footer.hidden = YES;

        }
        
        [weakSelf.tableView reloadData];
        
        isRefresh = NO;
        [packagMet initHideProgressHud];
    }
      onError:^(NSError *error) {
          
          [weakSelf endRefreshing];
          [weakSelf.helper falseAdd];
          [packagMet initHideProgressHud];
      }];
    
}

-(void)initInterFace
{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark ------UITableViewDelegateDataSource------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherActivityTableViewCell *cell = [OtherActivityTableViewCell creatCell:tableView];
    [cell.originalView setHidden:NO];
    
    cell.model = self.dataSource[indexPath.row];
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
    return 105;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    AECellDetailViewController *vc = [[AECellDetailViewController alloc]init];
//    vc.model = self.dataSource[indexPath.row];
//    vc.isActivity = YES;
//    vc.isStart = YES;
    
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
    vc.isStart = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -----cell中控件点击事件------
-(void)plusAction:(UIButton*)sender{
    NSInteger index = sender.tag - 1000;
    OtherActivityTableViewCell *cell = (OtherActivityTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.minus.hidden = NO;
    cell.addCount.hidden = NO;
    
    cell.addCount.text = [NSString stringWithFormat:@"%d",[cell.addCount.text intValue] + 1];
    NSLog(@"---------->%d",[cell.addCount.text intValue]);
    
    // 计算总价
    // 设置总价
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    
    [manager saveProduct:self.dataSource[index] andChangeAdditionalCopies:1 andProductConfig:self.configModel];
    
    for (ProductModel *shopData in manager.productData) {
        for (int i =0; i < self.dataSource.count; i++) {
            ProductModel *allData = self.dataSource[i];
            if ([shopData.productId isEqualToString:allData.productId] && shopData.isActivity == allData.isActivity) {
                allData.shopCount = shopData.shopCount;
                //[self.dataSource replaceObjectAtIndex:i withObject:shopData];
            }
        }
    }
    [self.tableView reloadData];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
    [self initSettleBtnAndShoppingCarBtn];
}
-(void)minusAction:(UIButton *)sender{
    NSInteger index = sender.tag -2000;
    OtherActivityTableViewCell *cell = (OtherActivityTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
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
//        for (ProductModel *shopData in manager.productData) {
//            for (int i =0; i < self.dataSource.count; i++) {
//                ProductModel *allData = self.dataSource[i];
//                if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
//                    allData.shopCount = shopData.shopCount;
//                    //[self.dataSource replaceObjectAtIndex:i withObject:shopData];
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
    
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
    [self initSettleBtnAndShoppingCarBtn];
}



- (IBAction)shoppingCarBtnAction:(UIButton *)sender {
    [self.shoppingView isHidden:NO];
    [self.view bringSubviewToFront:self.shoppingView];
}

- (IBAction)settleAcountBtnAction:(UIButton *)sender {
    
    [OrderSettlementViewController changeFormeViewController:self onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
        [self initSettleBtnAndShoppingCarBtn];
        [self.tableView.mj_header beginRefreshing];
    }];
    
}
#pragma mark -----ShoppingCarViewDelegate-----
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

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
