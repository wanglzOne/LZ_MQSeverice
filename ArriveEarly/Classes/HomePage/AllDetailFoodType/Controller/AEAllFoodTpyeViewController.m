//
//  AEAllFoodTpyeViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEAllFoodTpyeViewController.h"
#import "AEAllFoodTypeTableViewCell.h"

#import "AECellDetailViewController.h"
#import "CellDetailsViewController.h"
#import "BaseTableView.h"
#import "BasePopTableView.h"
#import "ProductModel.h"//商品模型
#import "ProductTypeModel.h"

#import "ShoppingCarView.h"//购物车界面
#import "OrderSettlementViewController.h"
#import "AutomaticRollingView.h"
#import "ClosingTimeView.h"

@interface AEAllFoodTpyeViewController ()<UITableViewDelegate,UITableViewDataSource,AEAllFoodTypeTableViewCellDelegate,BaseTableViewDelegate,BasePopTableView,ShoppingCarViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *typeAry;
    NSMutableArray *tasteAry;
    NSArray *sortAry;
    
    UIButton *titleBackGroundBtn;//弹出八大类背景按钮
    
    NSMutableArray *titleType;
    NSMutableArray *titleTaste;
    NSMutableArray *titleSort;
    
    int tagsId ;
    int sort;
    NSString *clsID;
    
    UIImageView *failView;
    BOOL isRefresh;
    
    PackagMet *packagMet;
    AutomaticRollingView *scView;
    UIImageView *imgView;
    
    NSString *manjianStr;
    
    CGFloat scrollViewHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *DisplayTableView;
///只是用于记录 标题的 被选择的id
@property (nonatomic,copy) NSString *maxClassID;

@property (nonatomic,strong)NSMutableArray *dataSource;//存返回商品
@property (nonatomic ,strong)NSMutableArray *locationDataSource;//


//导航栏弹出菜单
@property (nonatomic ,strong) BaseTableView *pop;
@property (nonatomic ,strong) BasePopTableView *typePop;
@property (nonatomic ,strong) BasePopTableView *tagPop;
@property (nonatomic ,strong) BasePopTableView *sortPop;

@property (nonatomic ,strong) ShoppingCarView *shoppingView;
@property (nonatomic ,strong) PageHelper *helper;
@property (nonatomic ,strong) PageHelper *secondHelper;

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;//分类
@property (weak, nonatomic) IBOutlet UIButton *tagBtn;//口感
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;//排序

@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;//购物车
@property (weak, nonatomic) IBOutlet UIButton *settleAcountBtn;//结算
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *waitPaylabel;


@property (weak, nonatomic) IBOutlet UIView *norShopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *norShopViewBottom;





@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIView *chooseView;


@end

@implementation AEAllFoodTpyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollViewHeight = 95.0;

    [self.tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(85), 0, 0)];
    [self.tagBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(-10), 0, 0)];
    
    [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(85), 0, 0)];
    [self.sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(-10), 0, 0)];
    
    [self.typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(85), 0, 0)];
    [self.typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(-10), 0, 0)];
   
   
    
    [self.titleBtn setTitle:self.ButtonTitle forState:UIControlStateNormal];
    
    if (self.titleBtn.titleLabel.text.length == 2) {
        [self.titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(100), 0, 0)];
    }else if (self.titleBtn.titleLabel.text.length > 2){
        NSInteger i;
        NSInteger ig = self.titleBtn.titleLabel.text.length - 2;
        if (ig == 1) {
            i = ig*15 +100;
        }else{
            i = ig*10 +100;
        }
        [self.titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(i), 0, 0)];
    }
    
    [self initData];
    [self reloadLocationData];
    [self initSettleBtnAndShoppingCarBtn];
    //[self initNetWorkingID:clsID tagId:tagsId Sort:sort];
    //二级菜单数据的网络请求
    [self initManjianNetworking];
    [self initClassNetWorking];
    [self initTagsNetWorking];
    [self loadBaner];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHEIGHT_6(65), KScreenWidth, scrollViewHeight)];
     imgView.image = [UIImage imageNamed:@"cdbanner"];
    [self.headView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headView);
        make.bottom.equalTo(self.headView).offset(-40);
        make.top.equalTo(self.headView).offset(0);
    }];
   
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:@"refreshView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"haveNoData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backRefresh) name:@"cellDetailRefresh" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadNormalStateData];
    //判断是否打烊
    [self CloseToJudge];
}


-(void)CloseToJudge{
    [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *error) {
      
        if (areaStoreInfo && areaStoreInfo.isOpen==0) {
            [[ClosingTimeView initCustomView] show_custom];
        }

    }];

}
-(void)reloadLocationData{
    [self initSettleBtnAndShoppingCarBtn];

}

#pragma mark ---------加载数据----------
-(void)initData{
    
    titleType = [[NSMutableArray alloc]init];
    titleTaste = [[NSMutableArray alloc]init];
    titleSort = [[NSMutableArray alloc]init];
    
    typeAry = [[NSMutableArray alloc]init];
    tasteAry = [[NSMutableArray alloc]init];
    //@"按销量",@"按价格",@"好评度"
    sortAry = [[NSArray alloc]initWithObjects:@"新品上市",/*@"按价格",*/@"按销量",@"好评度", nil];
    
    self.locationDataSource = [[NSMutableArray alloc]init];
    self.dataSource = [[NSMutableArray alloc]init];

    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in self.buttonAry) {
        [ary addObject:dic[@"className"]];
    }
    self.titleAry = [NSMutableArray arrayWithArray:ary];
    self.titleBtn.selected = NO;
    self.typeBtn.selected = NO;
    self.tagBtn.selected = NO;
    self.sortBtn.selected = NO;
    
    clsID = self.classID;
    self.maxClassID = self.classID;
    tagsId = -1;
    sort = -1;
    
    self.helper = [[PageHelper alloc]init];
    self.secondHelper = [[PageHelper alloc]init];
    
    isRefresh = NO;
    
    
    packagMet = [[PackagMet alloc]init];
    //[packagMet initHUDProgresSelfView:self title:@"正在加载..."];
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
        self.redLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)data.count];
        self.redLabel.hidden =NO;
        self.priceView.hidden = NO;
        self.waitPaylabel.text = MoneySymbol(manager.totalPrice);
        
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
- (void)loadNormalStateData
{
    WEAK(weakSelf);
    if (!self.DisplayTableView.mj_footer) {
        self.DisplayTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }
    if (!self.DisplayTableView.mj_header) {
        self.DisplayTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
    [self.DisplayTableView.mj_header beginRefreshing];
}
//下拉刷新
- (void)headerRefresh
{
    isRefresh = YES;
    self.helper = [[PageHelper alloc]init];
    
    //[self.DisplayTableView reloadData];
    [self.DisplayTableView.mj_footer setHidden:NO];
    [self initNetWorkingID:clsID tagId:tagsId Sort:sort];
    
}
//上拉加载
- (void)footerRefresh
{
    [self.helper add];
    [self initNetWorkingID:clsID tagId:tagsId Sort:sort];
    
}
- (void)endRefreshing
{
    [self.DisplayTableView.mj_header endRefreshing];
    [self.DisplayTableView.mj_footer endRefreshing];
}

#pragma mark --------商品网络请求---------
-(void)initNetWorkingID:(NSString *)clasID tagId:(int)tagId Sort:(int )sorts
{
    //[packagMet initShowProgressHud:self];
    
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:clasID forKey:@"productClassId"]; //
    // 选择 类型的全部 传
    
    
    [dic setObject:@(tagId) forKey:@"tagId"];//口感    全部 传-1
    [dic setObject:@(sorts) forKey:@"sort"];
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        [dic setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId forKey:@"areaId"];
    }else
    {
        [dic setObject:@"" forKey:@"areaId"];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:self.helper.params];
    [param setObject:dic forKey:@"params"];
    AFBaseNetWork *new = [[AFBaseNetWork alloc] init];
    WEAK(weakSelf);
    
    
    [new post:[@"conditionInfo" url_ex] params:param progress:nil responseObject:^(id responseObject) {
        [weakSelf endRefreshing];
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            
            if (isRefresh == YES) {
                [weakSelf.dataSource removeAllObjects];
            }
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
                //model.isActivity = 0;
                [ary addObject:model];
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
            //热搜跳转后的数据处理 ------ 商品为减为0 用了次refresh ------
            if (!self.hotModel || self.isChange == NO) {
                if (isRefresh) {
                    weakSelf.dataSource = [NSMutableArray arrayWithArray:ary];
                }else
                {
                    [weakSelf.dataSource addObjectsFromArray:ary];
                }
            }
            else{
                [weakSelf.dataSource addObject:self.hotModel];
                for (int i =0; i< ary.count; i++) {
                    ProductModel *mod = ary[i];
                    if ([mod.productId isEqualToString:self.hotModel.productId]) {
                        [ary removeObjectAtIndex:i];
                    }
                }
                //ary 请求数据   shop 本地加入购物车的数据
                BOOL isexist = NO;
                for (ProductModel *shopData in shop) {
                    if ([shopData.productId isEqualToString:self.hotModel.productId] && shopData.isActivity == self.hotModel.isActivity) {
                        self.hotModel.shopCount = shopData.shopCount;
                        isexist = YES;
                    }
                }
                if (!isexist) {
                    self.hotModel.shopCount = 0;
                }
                [weakSelf.dataSource addObjectsFromArray:ary];
            }
            if (weakSelf.dataSource.count < weakSelf.helper.total) {
                [weakSelf.DisplayTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        
       else{
           //请求正确，但是网络差，数据不正确的情况
            //weakSelf.dataSource = [[NSMutableArray alloc]init];
           if (isRefresh == YES) {
               [weakSelf.dataSource removeAllObjects];
           }
        }
        
        
        [weakSelf initInterFace];
        [weakSelf.DisplayTableView reloadData];
        isRefresh = NO;
        [packagMet initHideProgressHud];
    }
      onError:^(NSError *error) {
          
          [weakSelf.helper falseAdd];
          [weakSelf endRefreshing];
          [packagMet initHideProgressHud];
          
      }];
}

#pragma mark ----二级菜单网络请求-----
-(void)initClassNetWorking
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:self.secondHelper.params];
    [params setObject:@{@"classId":clsID} forKey:@"params"];
    ///类型查询   分类查询
    [[[AFBaseNetWork alloc]init] post:[@"queryByTwo" url_ex] params:params progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            [titleType removeAllObjects];
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                [ary addObject:dic];//imgUrl
            }
            titleType = [NSMutableArray arrayWithArray:ary];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"全部" forKey:@"className"];
            [titleType insertObject:dict atIndex:0];
            
            NSMutableArray *title = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in titleType) {
                [title addObject:dic[@"className"]];
            }
            typeAry = [NSMutableArray arrayWithArray:title];
            //
            
        }
        else{
            [titleType removeAllObjects];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"全部" forKey:@"className"];
            [titleType insertObject:dict atIndex:0];\
            
            typeAry = [[NSMutableArray alloc]init];
            [typeAry addObject:@"全部"];
        }
        
    } onError:^(NSError *error) {
       
    }];
    
}
- (void)loadBaner
{
    
    //添加请求参数 -----modify by luojian 2017-3-11
    if(![ArriveEarlyManager shared].areaStoreInfo.areaId) return;
    NSDictionary *param = @{@"areaId":[ArriveEarlyManager shared].areaStoreInfo.areaId,
                                        @"classId":self.classID};
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"advertisementImage" url_ex] params:param onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        imgView.image = [UIImage imageNamed:@""];
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dic = responseObject;
        if ([dic[@"responseData"] isKindOfClass:[NSArray class]]) {
            for (NSString *str in dic[@"responseData"]) {
                if ([str isKindOfClass:[NSString class]]) {
                    [arr addObject:[str imageUrl]];
                }
            }
        }
        NSMutableArray *place = [NSMutableArray array];
        for (NSString *ss in arr) {
            [place addObject:@"cdbanner"];
        }
        if (arr.count) {
            scView = [[AutomaticRollingView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, scrollViewHeight) WithNetImageUrls:arr localPlaceholderImages:place];
            scView.autoScrollDelay = 2;
            [self.headView addSubview:scView];
            [scView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.headView);
                make.bottom.equalTo(self.headView).offset(-40);
                make.top.equalTo(self.headView).offset(0);
            }];
        }else{
            imgView.image = [UIImage imageNamed:@"cdbanner"];
            
        }
    }];
    
    
}
-(void)initTagsNetWorking{
    [[[AFBaseNetWork alloc]init] post:[@"tags" url_ex] params:nil progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            [titleTaste removeAllObjects];
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                [ary addObject:dic];
            }
            titleTaste = [NSMutableArray arrayWithArray:ary];
            [titleTaste insertObject:@{@"id" : @(-1),@"tagId":@(-1),@"tagName":@"全部",@"tagParentld":@(0)} atIndex:0];
            NSMutableArray *taste = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in titleTaste) {
                [taste addObject:dic[@"tagName"]];
            }
            tasteAry = [NSMutableArray arrayWithArray:taste];
        }
        else{
            [titleTaste removeAllObjects];
            tasteAry = [[NSMutableArray alloc]init];
            [titleTaste insertObject:@{@"id" : @(-1),@"tagId":@(-1),@"tagName":@"全部",@"tagParentld":@(0)} atIndex:0];
            [tasteAry insertObject:@"全部" atIndex:0];
        }
        
    } onError:^(NSError *error) {
        
    }];
}

-(void)initManjianNetworking{
   
    NSMutableDictionary *parma = [[NSMutableDictionary alloc]init];
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        [parma setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId forKey:@"whenAreaId"];
    }else
    {
        [parma setObject:@"" forKey:@"whenAreaId"];
    }
    [[[AFBaseNetWork alloc]init] post:[@"queryWhenStr" url_ex] params:parma progress:nil responseObject:^(id responseObject) {
        if ([responseObject[@"responseCode"] integerValue] == 1) {
            manjianStr = [NSString stringWithFormat:@"%@", responseObject[@"responseData"]];
        }
        
        [self.DisplayTableView reloadData];
    } onError:^(NSError *error) {
         DLog(@"error=======%@",error);
    }];
}

#pragma mark -----------加载界面-------------
-(void)initInterFace
{
    self.DisplayTableView.rowHeight = UITableViewAutomaticDimension;
    self.DisplayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.DisplayTableView registerNib:[UINib nibWithNibName:@"AEAllFoodTypeTableViewCell" bundle:nil] forCellReuseIdentifier:@"FirstFoodTypeView"];
    CGFloat height = KHEIGHT_6(44) * self.titleAry.count;
    if (height > KScreenHeight/2) {
        height = KScreenHeight/2;
    }
    self.pop = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, height) style:UITableViewStyleGrouped];
    self.pop.eventDelegate = self;
    self.pop.hidden = YES;
    
    [_pop reloadData:self.titleAry ImageURLAry:self.imageURLAry];
    
    [self.view addSubview:self.pop];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    titleBackGroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.pop.bounds.size.height + 64, KScreenWidth, KScreenHeight - self.pop.bounds.size.height + 64)];
    titleBackGroundBtn.backgroundColor = [UIColor blackColor];
    titleBackGroundBtn.alpha = 0.3;
    [titleBackGroundBtn addTarget:self action:@selector(popHiddenAction:) forControlEvents:UIControlEventTouchUpInside];
    titleBackGroundBtn.hidden = YES;
    [self.view addSubview:titleBackGroundBtn];
  
    [self initSecondToolView];
    
    
   
}

-(void)initSecondToolView{
    
    self.typePop = [BasePopTableView initCustomView];
    CGFloat space = 80+64 + 40.0;
    self.typePop.frame = CGRectMake(0, space, KScreenWidth, KScreenHeight - space);
    [self.typePop isHidden:YES];
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in titleType) {
        if ([dict[@"imgUrl"] isKindOfClass:[NSString class]]) {
            [urls addObject:[dict[@"imgUrl"] imageUrl]];
        }else
        {
            [urls addObject:@""];
        }
    }
    self.typePop.imgArray = urls;
    [self.typePop reloadData:typeAry];
    
    self.typePop.delegate = self;
    [self.view addSubview:self.typePop];
    
    self.tagPop = [BasePopTableView initCustomView];
    self.tagPop.frame = CGRectMake(0, space, KScreenWidth, KScreenHeight - space);
    [self.tagPop isHidden:YES];
    [self.tagPop reloadData:tasteAry];
    self.tagPop.delegate = self;
    [self.view addSubview:self.tagPop];
    
    self.sortPop = [BasePopTableView initCustomView];
    self.sortPop.frame = CGRectMake(0, space, KScreenWidth, KScreenHeight - space);
    [self.sortPop isHidden:YES];
    [self.sortPop reloadData:sortAry];
   
    self.sortPop.delegate = self;
    [self.view addSubview:self.sortPop];
    
}
#pragma mark popViewDelegate
-(void)popView:(UITableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    self.isChange = NO;
    if (tableView == self.typePop.tableView) {
        
        clsID = titleType[indexPath.row][@"classId"];
        if (indexPath.row == 0) {
            NSDictionary *dict = titleType[0];
            if ([dict[@"className"] isEqualToString:@"全部"]) {
                clsID = self.maxClassID;
            }
        }
        
        
        DLog(@"菜单栏分类下拉选择的是第%ld个:%@",index,[typeAry objectAtIndex:index]);
        [self.typeBtn setTitle:[typeAry objectAtIndex:index] forState:UIControlStateNormal];
        self.typeBtn.selected = NO;
        [self.typePop isHidden:YES];
        
        if (self.typeBtn.titleLabel.text.length == 2) {
            [self.typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(85), 0, 0)];
        }else if (self.typeBtn.titleLabel.text.length > 2){
            NSInteger ig = self.typeBtn.titleLabel.text.length - 2;
            NSInteger i = ig*10 +85;
            [self.typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(i), 0, 0)];
        }
        isRefresh = YES;
    }
    if (tableView == self.tagPop.tableView) {
        
        tagsId = [titleTaste[indexPath.row][@"id"] intValue];
       DLog(@"菜单栏口感下拉选择的是第%ld个:%@",index,[tasteAry objectAtIndex:index]);
        [self.tagBtn setTitle:[tasteAry objectAtIndex:index] forState:UIControlStateNormal];
        self.tagBtn.selected = NO;
        [self.tagPop isHidden:YES];
        
        if (self.tagBtn.titleLabel.text.length == 2) {
             [self.tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(85), 0, 0)];
        }else if (self.tagBtn.titleLabel.text.length > 2){
            NSInteger ig = self.tagBtn.titleLabel.text.length - 2;
            NSInteger i = ig*10 +85;
             [self.tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(i), 0, 0)];
        }
     
        
    }
    if (tableView == self.sortPop.tableView) {
        //这里写的 什么鬼。。。。哎
        if (indexPath.row == 0) {
            sort = (int)indexPath.row + 4;
        }else{
            if(indexPath.row == 1) sort = 1;
            if(indexPath.row == 2) sort = 3;
                  }
        DLog(@"菜单栏排序下拉选择的是第%ld个:%@",index,[sortAry objectAtIndex:index]);
        [self.sortBtn setTitle:[sortAry objectAtIndex:index] forState:UIControlStateNormal];
        self.sortBtn.selected = NO;
        [self.sortPop isHidden:YES];
        
        if (self.sortBtn.titleLabel.text.length == 2) {
            [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(85), 0, 0)];
        }else if (self.sortBtn.titleLabel.text.length > 2){
            NSInteger ig = self.sortBtn.titleLabel.text.length - 2;
            NSInteger i = ig*10 +85;
            [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(i), 0, 0)];
        }
    }
    
    [self.DisplayTableView.mj_header  beginRefreshing];

    //[self initNetWorkingID:clsID tagId:tagsId Sort:sort];
}

-(void)clickBackGroundBtn:(UIButton *)btn
{
    if (btn == self.typePop.backGroundBtn) {
        self.typeBtn.selected = NO;
        [self.typePop setHidden:YES];
    }
    if (btn == self.tagPop.backGroundBtn) {
        self.tagBtn.selected = NO;
        [self.tagPop setHidden:YES];
    }
    if (btn == self.sortPop.backGroundBtn) {
        self.sortBtn.selected = NO;
        [self.sortPop setHidden:YES];
    }
}

#pragma mark ------无数据，数据异常无网络情况等 加载的界面 ------
-(void)initOtherFace
{
    failView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 117, KScreenWidth, KScreenHeight - 117)];
    failView.image = [UIImage imageNamed:@"img-bj"];
    [self.view addSubview:failView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDelegateDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"FirstFoodTypeView";
    AEAllFoodTypeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    if (!cell) {
        cell = [[AEAllFoodTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    cell.index = indexPath.row;
    cell.delegate = self;
    ProductModel     *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.label_manjian.text = manjianStr;
    
    if (model.isNew) {
        cell.xin_View.hidden = NO;
        [cell.xinViewHeight setConstant:22.0];
    }else
    {
        cell.xin_View.hidden = YES;
        [cell.xinViewHeight setConstant:0.01];
    }
    if (manjianStr && manjianStr.length !=0) {
        cell.manjian_View.hidden = NO;
        [cell.manjianViewHeight setConstant:20.0];
    }else
    {
        cell.manjian_View.hidden = YES;
        [cell.manjianViewHeight setConstant:0.01];
    }
    
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideAllpop];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView == self.DisplayTableView) {
        //CGRectGetHeight(self.headView.frame) - CGRectGetHeight(self.chooseView.frame)
        
        if (scrollView.contentOffset.y >= scrollViewHeight) {
            if (self.chooseView.superview != self.view) {
                //[self updateChooseTableViewFrame:64 + 20.0];
                [self.view addSubview:self.chooseView];
                [self.chooseView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view);
                    make.top.equalTo(@(64));
                    make.height.equalTo(@40);
                    make.width.equalTo(@(UIScreenWidth));
                }];
            }
        }else
        {
            if (self.chooseView.superview != self.headView) {
                [self.chooseView removeFromSuperview];
                //[self updateChooseTableViewFrame:80 + 64 + 40.0];
                [self.headView addSubview:self.chooseView];
                [self.chooseView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.chooseView);
                    make.top.equalTo(@(scrollViewHeight));
                }];
            }
        }
    }
}
- (void)hideAllpop
{
    [self.typePop isHidden:YES];
    [self.tagPop isHidden:YES];
    [self.sortPop isHidden:YES];
    self.tagBtn.selected = NO;
    self.typeBtn.selected = NO;
    self.sortBtn.selected = NO;
}
- (void)updateChooseTableViewFrame:(CGFloat)space
{
    self.typePop.frame = CGRectMake(0, space, KScreenWidth, KScreenHeight - space);
    self.tagPop.frame = CGRectMake(0, space, KScreenWidth, KScreenHeight - space);
    self.sortPop.frame = CGRectMake(0, space, KScreenWidth, KScreenHeight - space);
    [self.typePop updateTableViewHeight];
    [self.tagPop updateTableViewHeight];
    [self.sortPop updateTableViewHeight];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //通过数据来决定显示哪一个cell(有没有下面那个满多少活着新用户赠送),然后来决定高度 // 0-111.5 1- 134.5 2-160
//    ProductModel *pr = self.dataSource[indexPath.row];
//    
//    if (!pr.isOpen && !pr.isOpenNew) {
//        return 112;
//    }
//    if (!pr.isOpenNew && pr.isOpen) {
//        return 135;
//    }
    ProductModel *model = self.dataSource[indexPath.row];
    CGFloat height = 112.0;
    if (model.isNew) {
        height = height + 24;
    }
    if (manjianStr && manjianStr.length !=0) {
        height = height + 24;
    }
  
    return  height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AECellDetailViewController * cellDetail = [[AECellDetailViewController alloc] init];
//    cellDetail.model = self.dataSource[indexPath.row];
//    cellDetail.isActivity = NO;
//    cellDetail.isStart = YES;
    
    //来处理和本地数据对比加载界面
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSMutableArray *shop = [[NSMutableArray alloc]init];
    shop = [manager getLcationData];
    //ary 请求数据   shop 本地加入购物车的数据
    for (ProductModel *shopData in shop) {
        for (int i =0; i < self.dataSource.count; i++) {
            ProductModel *allData = self.dataSource[i];
            if ([shopData.productId isEqualToString:allData.productId] && shopData.isActivity == allData.isActivity) {
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
    vc.isActivity = NO;
    vc.isStart = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ----cell代理的点击事件----
-(void)clickPlusBtn:(AEAllFoodTypeTableViewCell *)cell
{
    NSLog(@"---------->%d",cell.count);
   // 设置总价
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    NSIndexPath *indexPath = [self.DisplayTableView indexPathForCell:cell];
    [manager saveProduct:self.dataSource[indexPath.row]  andChangeAdditionalCopies:1 andProductConfig:nil];
    
    //要更新一下数据源
    for (ProductModel *shopData in manager.productData) {
        for (int i =0; i < self.dataSource.count; i++) {
            ProductModel *allData = self.dataSource[i];
            if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
                allData = shopData;
                [self.dataSource replaceObjectAtIndex:i withObject:shopData];
            }
        }
    }
    [self.DisplayTableView reloadData];
    [self initSettleBtnAndShoppingCarBtn];
    
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
}
-(void)clickMinusBtn:(AEAllFoodTypeTableViewCell *)cell
{
    NSLog(@"=====CELL-COUNT---------->%d",cell.count);
    // 计算总价
    // 设置总价
    // 将商品从购物车中移除
    ShoppingCarManager *manager = [ShoppingCarManager sharedManager];
    [manager saveProduct:self.dataSource[cell.index]  andChangeAdditionalCopies:-1 andProductConfig:nil];

//    if(cell.count <= 0){
//        //isRefresh = YES;
//        //[self initNetWorkingID:clsID tagId:tagsId Sort:sort];
//    }
//    else{
//        //刷新界面
//        for (ProductModel *shopData in manager.productData) {
//            for (int i =0; i < self.dataSource.count; i++) {
//                ProductModel *allData = self.dataSource[i];
//                if ([shopData.productId isEqualToString:allData.productId]  && shopData.isActivity == allData.isActivity) {
//                    allData = shopData;
//                    [self.dataSource replaceObjectAtIndex:i withObject:shopData];
//                }
 //           }
//        }
//        [self.DisplayTableView reloadData];
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
    [self.DisplayTableView reloadData];
    
    
    
    [self initSettleBtnAndShoppingCarBtn];
    [self.shoppingView reloadData];
    [self.shoppingView.tableView reloadData];
    
}
#pragma mark ----ShoppingViewDelegate----
-(void)refreshControllerView
{
    isRefresh = YES;
    [self initNetWorkingID:clsID tagId:tagsId Sort:sort];
    [self initSettleBtnAndShoppingCarBtn];
}

-(void)backRefresh{
    //isRefresh = YES;
    //[self initNetWorkingID:clsID tagId:tagsId Sort:sort];
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

    [self.DisplayTableView reloadData];

}
#pragma mark 二级菜单点击事件
- (IBAction)typeAction:(UIButton *)sender {
    
    [self updateChooseView];
    
    self.typePop.isSortCategory = NO;
    [self.typePop refreshUI];
    [self.view bringSubviewToFront:self.typePop];
    self.typeBtn.selected = !self.typeBtn.selected;
    
    if (sender.selected) {
        
        [self.typePop isHidden:NO];
        [self.tagPop isHidden:YES];
        [self.sortPop isHidden:YES];
        
        self.tagBtn.selected = NO;
        self.sortBtn.selected = NO;
        [self.pop isHidden:YES];
        self.titleBtn.selected = NO;
        
    }else{
        [self.typePop isHidden:YES];        
    }
    
}
- (IBAction)tagAction:(UIButton *)sender {
    [self updateChooseView];

    self.tagPop.isSortCategory = NO;
    [self.tagPop refreshUI];
    [self.view bringSubviewToFront:self.tagPop];
    self.tagBtn.selected = !self.tagBtn.selected;
    
    if (sender.selected) {
        [self.tagPop isHidden:NO];
        
        [self.typePop isHidden:YES];
        [self.sortPop isHidden:YES];
        self.typeBtn.selected = NO;
        self.sortBtn.selected = NO;
        [self.pop isHidden:YES];
        self.titleBtn.selected = NO;
        
    }else{
        [self.tagPop isHidden:YES];
    }
    
}
- (IBAction)sortAction:(UIButton *)sender {
    [self updateChooseView];
    
    self.sortPop.isSortCategory = YES;
    [self.sortPop refreshUI];
    [self.view bringSubviewToFront:self.sortPop];
    self.sortBtn.selected = !self.sortBtn.selected;
    
    if (sender.selected) {
        [self.sortPop isHidden:NO];
        
        [self.tagPop isHidden:YES];
        [self.typePop isHidden:YES];
        self.tagBtn.selected = NO;
        self.typeBtn.selected = NO;
        [self.pop isHidden:YES];
        self.titleBtn.selected = NO;
        
       
        
    }else{
        [self.sortPop isHidden:YES];
    }
   
}
- (void)updateChooseView
{
    CGRect re = [self.view convertRect:self.chooseView.frame fromView:self.chooseView.superview];
    [self updateChooseTableViewFrame:CGRectGetMaxY(re)-15.0];
}
#pragma mark -------弹出导航栏菜单---------
- (IBAction)showToolViewAction:(UIButton *)sender {
    _isChange = NO;
    [self.view bringSubviewToFront:self.pop];
    self.titleBtn.selected = !self.titleBtn.selected;
  
    if (sender.selected) {
        [self.pop isHidden:NO];
        titleBackGroundBtn.hidden = NO;
        [self.sortPop isHidden:YES];
        [self.typePop isHidden:YES];
        [self.tagPop isHidden:YES];
        
        self.typeBtn.selected = NO;
        self.tagBtn.selected = NO;
        self.sortBtn.selected = NO;
        
    }else{
        [self.pop isHidden:YES];
        titleBackGroundBtn.hidden = YES;
    }
}
-(void)popHiddenAction:(UIButton*)btn
{
    btn.hidden = YES;
    self.titleBtn.selected = NO;
    [self.pop setHidden:YES];
}
#pragma mark ---------BaseTableViewDelegate -----------
- (void)tableView:(UITableView *)tableView didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    NSLog(@"导航栏下拉选择的是第%ld个:%@",(long)index,[self.titleAry objectAtIndex:index]);
    [self.titleBtn setTitle:[self.titleAry objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    if (self.titleBtn.titleLabel.text.length == 2) {
        [self.titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(100), 0, 0)];
    }else if (self.titleBtn.titleLabel.text.length > 2){
        NSInteger i;
        NSInteger ig = self.titleBtn.titleLabel.text.length - 2;
        if (ig == 1) {
            i = ig*15 +100;
        }else{
            i = ig*10 +100;
        }
        [self.titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, KHEIGHT_6(i), 0, 0)];
    }
    
    self.titleBtn.selected = NO;
    [self.pop isHidden:YES];
    titleBackGroundBtn.hidden = YES;
    
    clsID = [NSString stringWithFormat:@"%@",self.buttonAry[index][@"classId"]];
    
    self.maxClassID = [NSString stringWithFormat:@"%@",self.buttonAry[index][@"classId"]];
    
    tagsId = -1;
    sort = -1;
    [self.typeBtn setTitle:@"分类" forState:UIControlStateNormal];
    self.typeBtn.selected = NO;
    [self.tagBtn setTitle:@"口感" forState:UIControlStateNormal];
    self.tagBtn.selected = NO;
    [self.sortBtn setTitle:@"排序" forState:UIControlStateNormal];
    self.sortBtn.selected = NO;
    
    [self.DisplayTableView.mj_header  beginRefreshing];
    //[self initNetWorkingID:clsID tagId:tagsId Sort:sort];
    [self initClassNetWorking];
}
#pragma mark ----bannaer点击事件-----
-(void)clickBanaerAction:(UIButton *)sender {
    NSLog(@"————————点击了广告栏————————");
}


- (IBAction)BackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -----购物车点击事件-----
- (IBAction)shoppingCarAction:(UIButton *)sender {
    [self.shoppingView isHidden:NO];
    [self.shoppingView reloadData];
}
#pragma mark -----结算点击事件-----
- (IBAction)settleAccountAction:(UIButton *)sender {
    NSLog(@"结算点击事件~");
    [OrderSettlementViewController changeFormeViewController:self onCompleteBlock:^(OrderMessageModelInfo *orderMessageInfo) {
        [self initSettleBtnAndShoppingCarBtn];
        [self.DisplayTableView.mj_header beginRefreshing];
    }];
}

#pragma mark 接受通知后的操作
-(void)refreshView
{
    [self initNetWorkingID:clsID tagId:tagsId Sort:sort];
    [self initSettleBtnAndShoppingCarBtn];
    
}

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
    self.shoppingView.delegate =self;
    self.shoppingView.vc = self;
    self.shoppingView.isActivity = NO;
    [self.shoppingView isHidden:YES];
    [self.shoppingView reloadData];//到时候有数据了理一下传过来的顺序
    [self.view addSubview:self.shoppingView];
    

}
- (void)viewDidDisappear:(BOOL)animated
{
    [scView removeTimer];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.titleBtn.selected = NO;
    [self.pop setHidden:YES];
    
}
-(void)dealloc
{
    DLogMethod();
}
//cdbanner
@end
