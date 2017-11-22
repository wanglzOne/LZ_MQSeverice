//
//  AEHomeViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEHomeViewController.h"
#import "AppDelegate.h"
#import "AETopCollectionViewController.h" //滚动 广告视图

#import "AEHomeTableViewCell.h"
#import "AESecondView.h"
#import "AECellDetailViewController.h"//菜品详情
#import "MyMessageViewController.h"
#import "AEChooseShoppingAddressViewController.h"
#import "AEThirdView.h"//五大活动View
#import "AETopSearchView.h"//定位
#import "HomeSearchViewController.h"//搜索界面
#import "AEAllFoodTpyeViewController.h"//菜单界面
#import "LoginViewController.h"
#import "SeckillViewController.h"//秒杀活动
#import "OtherActivityViewController.h"//其他活动
#import "ProductModel.h"
#import "MJRefreshAutoFooter.h"
#import "RedPacketViewController.h"
#import "LocationManager.h"
#import "CellDetailsViewController.h"
#import "ClosingTimeView.h"
#import "AutomaticRollingView.h"
#import "CSView.h"

//#import "RSAEncryptor.h"

@interface AEHomeViewController ()<UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,AESecondViewDelegate,AEThirdViewDelegate, UIScrollViewDelegate>
{
    long long  suplus;//五大活动剩余时间
    NSMutableArray *ImageURLAry;//八大类按钮图片
    
    BOOL isViewDid;
    __weak IBOutlet UIButton *redBackButton;
    
    AETopSearchView *  searchView ;
    UIButton * _searchBtn;
    UIButton * _clockButton;
    
    CGFloat _BANNERHeight;
    
    UIView *navView;
    UIView *navBGView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewDisPlay;
@property (nonatomic, strong) AutomaticRollingView *topScrollCollectionView;
@property (nonatomic, strong) AETopCollectionViewController * topScrollCollectionVC;///滚动视图的

@property (nonatomic, strong) AESecondView * secondView;//八大类的 view


@property (nonatomic, strong) AEThirdView * thirdView;/// 活动的view

@property (nonatomic, strong) UIView * backGroundView;//表头视图


@property (nonatomic, strong)  NSTimer * timer;

@property (nonatomic, strong)  NSTimer *activityTimer;//活动秒杀刷新数据定时器

@property (nonatomic, strong)NSMutableArray *baseActivityDataAry;//存五大活动数据
@property (nonatomic, strong)NSMutableArray *baseScrollerDataAry;//存滚动图片数据
@property (nonatomic, strong)NSMutableArray *baseButtonDataAry;//八大按钮
@property (nonatomic, strong)NSMutableArray *baseHotDataAry;//热门推荐


@end

@implementation AEHomeViewController

-(UIView *)backGroundView{
    //创建tableViewHeaderView
    
    if (!_backGroundView) {
        UIView * view = [[UIView alloc] init];
        _backGroundView = view;
        //    _backGroundView.size = CGSizeMake(self.view.bounds.size.width, _BANNERHeight + ScreenWith/2 + KHEIGHT_6(230) );  //需要适配
        _backGroundView.size = CGSizeMake(self.view.bounds.size.width, _BANNERHeight + KHEIGHT_6(180) + KHEIGHT_6(250) );  //需要适配
        _backGroundView.origin = CGPointMake(0,0);
        _backGroundView.backgroundColor =[UIColor groupTableViewBackgroundColor];
        [_backGroundView addSubview:self.topScrollCollectionView];
        [_backGroundView addSubview: self.secondView];
        
    }
    return _backGroundView;
}
-(AESecondView *)secondView{
    
    if (!_secondView) {
        _secondView = [[AESecondView alloc] init];
        _secondView.backgroundColor = [UIColor whiteColor];
        _secondView.delegate = self;
        //加载secondView
        [_secondView createSecondView];
        [_backGroundView addSubview:_secondView];
        [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(_backGroundView);
            make.top.mas_equalTo(self.topScrollCollectionView.mas_bottom);
            make.bottom.mas_equalTo(self.thirdView.mas_top).with.offset(-10);
            make.height.mas_equalTo(ScreenWith/2 ); //需要适配
        }];
        
    }
    return _secondView;
    
}
-(AEThirdView *)thirdView{
    if (!_thirdView) {
        _thirdView = [AEThirdView createThirdViewWithXib];
        _thirdView.delegate = self;
        _thirdView.frame = CGRectMake(0, 0, ScreenWith,KHEIGHT_6(250));
        _thirdView.backgroundColor = [UIColor whiteColor];
        //添加thirdView
        [_backGroundView addSubview:_thirdView];
        [_thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(_backGroundView);
            make.top.mas_equalTo(_secondView.mas_bottom);
            make.bottom.mas_equalTo(_backGroundView.mas_bottom);
        }];
        
    }
    return _thirdView;
}
-(AutomaticRollingView *)topScrollCollectionView{
    if (!_topScrollCollectionView) {
        _topScrollCollectionView = [[AutomaticRollingView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, _BANNERHeight) WithNetImageUrls:@[@"",@"",@""] localPlaceholderImages:@[@"banner",@"banner1",@"banner2"]];
        _topScrollCollectionView.autoScrollDelay = 2;
    }
    return _topScrollCollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _BANNERHeight = KHEIGHT_6(210);
    redBackButton.hidden = YES;
    [self initData];
    isViewDid = YES;
    
    
    /*
    [self.view showPopupLoading];
    [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *error) {
        [self.view hidePopupLoading];
        //  带区域id的   加载数据
        //kShowProgress(self);
        
        
        
        [self updateAllData];
        if (![ArriveEarlyManager shared].address) {
            searchView.locationLabel.text = @"定位失败";
        }else
            searchView.locationLabel.text = [ArriveEarlyManager shared].address;
        //aetop locationLabel.text = areaStoreInfo.address;
        if (!areaStoreInfo  || areaStoreInfo.isOpen==0) {
            ClosingTimeView *clos =[ClosingTimeView initCustomView];
            [clos show_custom];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.launchIntroductionView.superview bringSubviewToFront:app.launchIntroductionView];
        }
        
    }];
     */
    //加载页面
    [self initInterFace];
    [self createActivityTimer];
    [self loadNormalStateData];
    
    [self.tableViewDisPlay.mj_header beginRefreshing];
}


 

- (void)loadNormalStateData
{
    WEAK(weakSelf);
    if (!self.tableViewDisPlay.mj_header) {
        self.tableViewDisPlay.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
}
/// 更新所有的信息  重新定位。 获取门店信息  拉取商品信息。
- (void)headerRefresh
{
    [self.view showPopupLoading];
    [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *error) {
        if (![ArriveEarlyManager shared].address) {
            searchView.locationLabel.text = @"定位失败";
        }else
            searchView.locationLabel.text = [ArriveEarlyManager shared].address;
        
        if (areaStoreInfo  && areaStoreInfo.isOpen==0) {
            ClosingTimeView *clos =[ClosingTimeView initCustomView];
            [clos show_custom];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.launchIntroductionView.superview bringSubviewToFront:app.launchIntroductionView];
            [self endUpdateAllData];
        }else
        {
            [self updateProductData];
        }
        
        if (error && error.code == 2) {
            //[self.view showPopupErrorMessage:error.domain];
            CSView *clos =[CSView initCSView];
            [clos show_custom];

            return ;
        }
    }];
    

}
- (void)updateProductData
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // something
//        [self.view hidePopupLoading];
//        [self.view showPopupLoading];
//    });
    
    dispatch_group_t group = dispatch_group_create();
    [self addBannerInfoSemaphoreforGroup:group];
    [self addQueryByOneSemaphoreforGroup:group];
    [self addActivityConfigSemaphoreforGroup:group];
    [self addQueryHotSemaphoreforGroup:group];
    ///  更新 秒杀活动配置
    [self refreshSecondsKillConfig];
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endUpdateAllData];
        });
    });
}
- (void)updateAllData
{
    [self.tableViewDisPlay.mj_header beginRefreshing];
}
- (void)endUpdateAllData
{
    kHiddenProgress(self);
    [self.view hidePopupLoading];
    [self.tableViewDisPlay.mj_header endRefreshing];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![ArriveEarlyManager shared].areaStoreInfo) {
        [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *erroe) {
            if (erroe) {
                if (!self.baseScrollerDataAry.count) {
                    [self initScrollerImageNetWorking];
                }
                if (!self.baseButtonDataAry.count) {
                    [self initButtonNetWorking];
                }
                if (!self.baseActivityDataAry.count) {
                    [self initActivityNetWorking];
                }
                if (!self.baseHotDataAry.count) {
                    [self initQueryHotNetWorking];
                }
                
                if(erroe.code == 2){
                    //[self.view showPopupErrorMessage:erroe.domain];
                    CSView *clos =[CSView initCSView];
                    [clos show_custom];

                }
                
                return ;
            }
            
        
            
            searchView.locationLabel.text = [ArriveEarlyManager shared].address;
            //  带区域id的   加载数据
            [self initScrollerImageNetWorking];
            [self initButtonNetWorking];
            [self initActivityNetWorking];
            [self initQueryHotNetWorking];
        }];
    }
    else if (!isViewDid)
    {
        if (!self.baseScrollerDataAry.count) {
            [self initScrollerImageNetWorking];
        }
        if (!self.baseButtonDataAry.count) {
            [self initButtonNetWorking];
        }
        if (!self.baseActivityDataAry.count) {
            [self initActivityNetWorking];
        }
        if (!self.baseHotDataAry.count) {
            [self initQueryHotNetWorking];
        }
        
         }
    isViewDid = NO;
}

#pragma mark 数据加载
-(void)initData{
    _baseActivityDataAry = [[NSMutableArray alloc]init];
    _baseScrollerDataAry = [[NSMutableArray alloc]init];
    _baseButtonDataAry = [[NSMutableArray alloc]init];
    _baseHotDataAry = [[NSMutableArray alloc]init];
}
#pragma mark -----网络请求获取滚动视图的数据-----
-(void)initScrollerImageNetWorking
{
    AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
    [net post:[@"bannerInfo" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            [self.baseScrollerDataAry removeAllObjects];
            self.baseScrollerDataAry = [[NSMutableArray alloc]initWithArray:responseObject[@"responseData"]];
            //[self.topScrollCollectionVC getScrollorImgDataSource:self.baseScrollerDataAry];
            
            NSMutableArray *m = [NSMutableArray array];
            NSMutableArray *pm = [NSMutableArray array];
            for (NSDictionary *dict in self.baseScrollerDataAry) {
                if ([dict[@"bannerHeadImgUrl"] isKindOfClass:[NSString class]]) {
                    [m addObject:[dict[@"bannerHeadImgUrl"] imageUrl]];
                    [pm addObject:@"banner1"];
                }
            }
            
            [self.topScrollCollectionView refreshWithNetImageUrls:m localPlaceholderImages:pm];
            
        }
        
        
        
    } onError:^(NSError *error) {
        
    }];
}
- (void)addBannerInfoSemaphoreforGroup:(dispatch_group_t)group
{
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
        [net post:[@"bannerInfo" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
            if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
                [self.baseScrollerDataAry removeAllObjects];
                self.baseScrollerDataAry = [[NSMutableArray alloc]initWithArray:responseObject[@"responseData"]];
                //[_topScrollCollectionVC getScrollorImgDataSource:self.baseScrollerDataAry];
                
                
                NSMutableArray *m = [NSMutableArray array];
                NSMutableArray *pm = [NSMutableArray array];
                for (NSDictionary *dict in self.baseScrollerDataAry) {
                    if ([dict[@"bannerHeadImgUrl"] isKindOfClass:[NSString class]]) {
                        [m addObject:[dict[@"bannerHeadImgUrl"] imageUrl]];
                        [pm addObject:@"banner1"];
                    }
                }
                
                [self.topScrollCollectionView refreshWithNetImageUrls:m localPlaceholderImages:pm];
                
            }
            dispatch_semaphore_signal(semaphore);
        } onError:^(NSError *error) {
            //[self.view showPlaneMessage:error.domain];
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}
- (void)addQueryByOneSemaphoreforGroup:(dispatch_group_t)group
{
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[[AFBaseNetWork alloc]init] post:[@"queryByOne" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
            
            if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *ary = [NSMutableArray arrayWithArray:responseObject[@"responseData"]];
                [self.secondView getSecondData:ary];
                
                NSMutableArray *titleAry = [[NSMutableArray alloc]init];
                NSMutableArray *imgURLAry = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in responseObject[@"responseData"]) {
                    [titleAry addObject:dic];
                    [imgURLAry addObject:dic[@"imgUrl"]];
                }
                self.baseButtonDataAry = [NSMutableArray arrayWithArray:titleAry];
                ImageURLAry = [NSMutableArray arrayWithArray:imgURLAry];
            }
            dispatch_semaphore_signal(semaphore);
        } onError:^(NSError *error) {
            //[self.view showPlaneMessage:error.domain];
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
}
- (void)addActivityConfigSemaphoreforGroup:(dispatch_group_t)group
{
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
        [net post:[@"activityConfig" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"responseData"][@"object"] isKindOfClass:[NSArray class]]) {
                    [self.baseActivityDataAry removeAllObjects];
                    self.baseActivityDataAry = [NSMutableArray arrayWithArray:responseObject[@"responseData"][@"object"]];
                    [_thirdView initGetDataSource:self.baseActivityDataAry Date:responseObject[@"responseData"][@"nowDate"]];
                    //计算活动剩余时间
                    if (responseObject[@"responseData"][@"object"][0][@"activityEffEnd"] != (id)kCFNull && responseObject[@"responseData"][@"nowDate"] != (id)kCFNull) {
                        suplus = ([responseObject[@"responseData"][@"object"][0][@"activityEffEnd"] longLongValue] - [responseObject[@"responseData"][@"nowDate"] longLongValue])/1000;
                    }
                    //suplus = ([responseObject[@"responseData"][@"object"][0][@"activityEffEnd"] longLongValue] - [responseObject[@"responseData"][@"nowDate"] longLongValue])/1000;
                }
            }
            dispatch_semaphore_signal(semaphore);
        } onError:^(NSError *error) {
            //[self.view showPlaneMessage:error.domain];
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
}
- (void)addQueryHotSemaphoreforGroup:(dispatch_group_t)group
{
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[[AFBaseNetWork alloc]init] post:[@"queryHot" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
            
            if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
                [self.baseHotDataAry removeAllObjects];
                NSMutableArray *ary = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in responseObject[@"responseData"]) {
                    ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
                    //model.isActivity = 0;
                    [ary addObject:model];
                }
                self.baseHotDataAry = [NSMutableArray arrayWithArray:ary];
                [self.tableViewDisPlay reloadData];
            }
            kHiddenProgress(self);
            dispatch_semaphore_signal(semaphore);
        } onError:^(NSError *error) {
            kHiddenProgress(self);
            dispatch_semaphore_signal(semaphore);
            //[self.view showPlaneMessage:error.domain];
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
}
#pragma mark -----八大按钮的网络请求------
-(void)initButtonNetWorking
{
    [[[AFBaseNetWork alloc]init] post:[@"queryByOne" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *ary = [NSMutableArray arrayWithArray:responseObject[@"responseData"]];
            [self.secondView getSecondData:ary];
            
            NSMutableArray *titleAry = [[NSMutableArray alloc]init];
            NSMutableArray *imgURLAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                [titleAry addObject:dic];
                [imgURLAry addObject:dic[@"imgUrl"]];
            }
            self.baseButtonDataAry = [NSMutableArray arrayWithArray:titleAry];
            ImageURLAry = [NSMutableArray arrayWithArray:imgURLAry];
        }
        
    } onError:^(NSError *error) {
        
        
    }];
}

#pragma mark -----网络请求获取秒杀等五大活动区的数据-----
-(void)initActivityNetWorking
{
    
    AFBaseNetWork *net = [[AFBaseNetWork alloc]init];
    [net post:[@"activityConfig" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"responseData"][@"object"] isKindOfClass:[NSArray class]]) {
                [self.baseActivityDataAry removeAllObjects];
                self.baseActivityDataAry = [NSMutableArray arrayWithArray:responseObject[@"responseData"][@"object"]];
                [_thirdView initGetDataSource:self.baseActivityDataAry Date:responseObject[@"responseData"][@"nowDate"]];
                //计算活动剩余时间
                suplus = 0;
                if (responseObject[@"responseData"][@"object"][0][@"activityEffEnd"] != (id)kCFNull && responseObject[@"responseData"][@"nowDate"] != (id)kCFNull) {
                    suplus = 0;
                    if (responseObject[@"responseData"][@"object"][0][@"activityEffEnd"] != (id)kCFNull && responseObject[@"responseData"][@"nowDate"] != (id)kCFNull) {
                        suplus = ([responseObject[@"responseData"][@"object"][0][@"activityEffEnd"] longLongValue] - [responseObject[@"responseData"][@"nowDate"] longLongValue])/1000;
                    }
                }
            }
        }
    } onError:^(NSError *error) {
        
    }];
}



- (NSString *)areaId
{
    NSString *areaId = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaId = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }
    //return @"5d45bc31-9369-4116-b8e4-609a779b3503";
    return areaId;
}
#pragma mark 热门推荐网络请求
-(void)initQueryHotNetWorking
{
    [[[AFBaseNetWork alloc]init] post:[@"queryHot" url_ex] params:@{@"areaId" : [self areaId]} progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            [self.baseHotDataAry removeAllObjects];
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
                //model.isActivity = 0;
                [ary addObject:model];
            }
            self.baseHotDataAry = [NSMutableArray arrayWithArray:ary];
            [self.tableViewDisPlay reloadData];
        }
        kHiddenProgress(self);
    } onError:^(NSError *error) {
        kHiddenProgress(self);
        
    }];
}

#pragma mark ----加载界面----
-(void)initInterFace
{
    self.tableViewDisPlay.estimatedRowHeight = EstimatedHeight;
    self.tableViewDisPlay.rowHeight = UITableViewAutomaticDimension;
    self.tableViewDisPlay.bounces = YES;
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    //加载背景大View
    //顶部🔍框
    searchView = [AETopSearchView createTopSearchButton];
    
    navBGView = [[UIView alloc] initWithFrame:navView.bounds];
    navBGView.backgroundColor = [UIColor clearColor];
    [navView addSubview:navBGView];
    searchView.frame = CGRectMake(kScreenSize.width/2 - 200 / 2, 24, 187, 30);
    [navView addSubview:searchView];
    [searchView SearchViewClickWithTarget:self action:@selector(SearchClick:)];
    //创建搜素按钮
    
    _searchBtn = [UIButton createButtonWithCGRect:CGRectMake(ButtonMargion,  24, searchBtnWidth, searchBtnWidth) title:nil titleColor:nil titleFont:nil image:nil normalBackImage:[UIImage imageNamed:@"toprtbss"] selectedImage:nil];
    [_searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.layer.cornerRadius = searchBtnWidth / 2.0;
    
    [navView addSubview:_searchBtn];
    
    
    
    //消息
    _clockButton = [UIButton createButtonWithCGRect:CGRectMake(KScreenWidth - searchBtnWidth - ButtonMargion,  24, searchBtnWidth, searchBtnWidth) title:nil titleColor:nil titleFont:nil image:nil normalBackImage:[UIImage imageNamed:@"toprtbxx"] selectedImage:nil];
    //    clockButton.backgroundColor = [UIColor redColor];
    [_clockButton addTarget:self action:@selector(clockClick) forControlEvents:UIControlEventTouchUpInside];
    _clockButton.layer.cornerRadius = searchBtnWidth / 2.0;
    
    [navView addSubview:_clockButton];
    
    
    
    //创建一个tableViewHeaderView
    self.tableViewDisPlay.tableHeaderView =  self.backGroundView;
    
    [self.view addSubview:navView];
}


-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark ---实现我的消息点击方法
-(void) clockClick{
    NSLog(@"——————————消息——————————");
    
    
    [ArriveEarlyManager loginSuccess:^{
        MyMessageViewController *vc = [[MyMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } fail:^{
        [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
            
        }];
    }];
}

#pragma mark ---实现搜索按钮点击方法
-(void) searchBtnClick:(UIButton*)sender{
    NSLog(@"searchBtn");
    HomeSearchViewController *vc = [[HomeSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---滚动已经结束
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.topScrollCollectionVC.topCollectionVC) {
        
        
        
    }
    else{
        
        if (scrollView.contentOffset.y == _BANNERHeight) {
            //            [self.navigationController.navigationBar setHidden:NO];
            //            [self.navigationController.navigationBar setBackgroundColor:[UIColor orangeColor]];
            CGFloat minAlphaOffset = - 64;
            CGFloat maxAlphaOffset = _BANNERHeight;
            CGFloat offset = scrollView.contentOffset.y;
            CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
            self.navigationController.navigationBar.alpha = alpha;
            
        }
        
    }
    if (scrollView ==  self.tableViewDisPlay && scrollView.contentOffset.y) {
        [self updateNavView:scrollView.contentOffset.y];
    }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.tableViewDisPlay) {
        if ( scrollView.contentOffset.x == HomeTopScrollPictureHeight) {
            //            [self.navigationController setNavigationBarHidden:NO];
        }
    }
}

#pragma mark --- UITableView的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.baseHotDataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"热门推荐";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AEHomeTableViewCell * cell = [AEHomeTableViewCell cellWithTableView:tableView];
    cell.model = self.baseHotDataAry[indexPath.row];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.baseHotDataAry[indexPath.row] yy_modelToJSONObject];
    NSString *str = [NSString stringWithFormat:@"%@",dic[@"productClassId"]];
    int cid = [str intValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@{@"classId":@(cid)} forKey:@"params"];
    [params setObject:@(20) forKey:@"pageSize"];
    [params setObject:@(1) forKey:@"currentPage"];
    [[[AFBaseNetWork alloc]init] post:[@"findClass" url_ex] params:params progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:responseObject[@"responseData"]];
            
            NSString *str = [NSString stringWithFormat:@"%@",dic[@"classId"]];
            NSString *clasName = [NSString stringWithFormat:@"%@",dic[@"className"]];
            
            AEAllFoodTpyeViewController *vc = [[AEAllFoodTpyeViewController alloc]init];
            vc.hotModel = [self.baseHotDataAry[indexPath.row] yy_modelCopy];
            vc.classID = str;
            vc.ButtonTitle = clasName;
            vc.isChange = YES;
            
            vc.buttonAry = [NSMutableArray arrayWithArray:self.baseButtonDataAry];
            vc.imageURLAry = [NSMutableArray arrayWithArray:ImageURLAry];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    } onError:^(NSError *error) {
        
    }];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113.5;
}

#pragma mark ---搜索地址点击实现方法
-(void) SearchClick:(UIButton *) btn{
    
    AEChooseShoppingAddressViewController * ChooseShoppingAddress = [[AEChooseShoppingAddressViewController alloc] initWithNibName:@"AEChooseShoppingAddressViewController" bundle:nil];
    
    ChooseShoppingAddress.updateBlock = ^(){
        //更新了  区域信息  然后更新  菜品信息
        searchView.locationLabel.text = [ArriveEarlyManager shared].address;
        //kShowProgress(self);
        [self updateProductData];
    };
    [self.navigationController pushViewController:ChooseShoppingAddress animated:YES];
    
}
#pragma mark ---集合视图的代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第几个item = %ld",indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 八大类点击  实现secondView中按钮点击方法
-(void)buttonClickWhichOneWithNumber:(UIButton *)number{
    
    NSInteger i = (NSInteger)self.secondView.state;
    AEAllFoodTpyeViewController * allFoodTpyeVC = [[AEAllFoodTpyeViewController alloc] init];
    NSString *str = [[NSString alloc]init];
    NSString *classID = [[NSString alloc]init];
    if (self.baseButtonDataAry.count == 0) {
        
    }else{
        str = self.baseButtonDataAry[i][@"className"];
        classID = [NSString stringWithFormat:@"%d",[self.baseButtonDataAry[i][@"classId"] intValue]];
        
        NSLog(@"按钮点击：第%ld个,主题＝＝%@",i,str);
        allFoodTpyeVC.ButtonTitle = str;
    }
    allFoodTpyeVC.classID = classID;//clssID : nsnumber   地址
    allFoodTpyeVC.buttonAry = [NSMutableArray arrayWithArray:self.baseButtonDataAry];
    allFoodTpyeVC.imageURLAry = [NSMutableArray arrayWithArray:ImageURLAry];
    NSLog(@"八大类classID---------->%@",allFoodTpyeVC.classID);
    NSLog(@"八大类数据------>%@",allFoodTpyeVC.buttonAry);
    [self.navigationController pushViewController:allFoodTpyeVC animated:YES];
    
}
#pragma mark ----AEThirdViewDelegate ------
-(void)buttonClickWithNumber:(UIButton *)number
{
    DLog(@"五大活动");
    switch (number.tag) {
        case 0:{
            DLog(@"天天秒杀");
            ActivityConfigModel *secondsKillModel = [ArriveEaryDefaultConfigManager shared].secondsKillEveryDayConfigModel;
            SecondsKillActivityState sate = [ArriveEaryDefaultConfigManager shared].activityState;
            SeckillViewController *vc = [[SeckillViewController alloc]init];
            vc.configModel = secondsKillModel;
            vc.activityID = secondsKillModel.activityId;
            vc.configDict = [secondsKillModel yy_modelToJSONObject];
            if (sate == SecondsKillActivityState_AlreadyStart) {
                vc.isShow = NO;
            }else
            {
                vc.isShow = YES;
            }
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
            break;
            
        default:
            break;
    }
    
    NSInteger index = number.tag-1;
    OtherActivityViewController *vc = [[OtherActivityViewController alloc]initWithNibName:@"OtherActivityViewController" bundle:nil];
    if (self.baseActivityDataAry.count && index < self.baseActivityDataAry.count) {
        if ([self.baseActivityDataAry[index] isKindOfClass:[NSDictionary class]]) {
            vc.activityID = [NSString stringWithFormat:@"%d",[self.baseActivityDataAry[index][@"activityId"] intValue]];
            vc.configDict = self.baseActivityDataAry[index];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)redPacketAction:(UIButton *)sender {
    RedPacketViewController *vc = [[RedPacketViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


//页面将要显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeActivity) name:@"backActivity" object:nil];
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeActivity) name:@"comeActivity" object:nil];
}

//页面消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backActivity" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"comeActivity" object:nil];
}
-(void)backActivity{
    //关闭定时器
    [self.activityTimer setFireDate:[NSDate distantFuture]];
}
-(void)comeActivity{
    //do your UI
    //[self initActivityNetWorking];
    [self.tableViewDisPlay.mj_header beginRefreshing];
    //开启定时器
    [self.activityTimer setFireDate:[NSDate distantPast]];
}


- (void)updateNavView:(CGFloat)offY
{
    if (offY < 0) {
        navBGView.backgroundColor = [UIColor clearColor];
    }else if (offY <= 100.0 && offY > 0) {
        navBGView.backgroundColor = [UIColor colorWithWhite:1.00 alpha:offY/140.0];
    }
    //searchView
    //_searchBtn
    //_clockButton
    if (offY < 64.0 + 10) {
        searchView.hidden = NO;
        _clockButton.hidden = NO;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            _searchBtn.frame = CGRectMake(_searchBtn.frame.origin.x, _searchBtn.frame.origin.y, _searchBtn.frame.size.height , _searchBtn.frame.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [_searchBtn setTitle:@"" forState:UIControlStateNormal];
                [_searchBtn setBackgroundImage:nil forState:UIControlStateNormal];
                [_searchBtn setImage:[UIImage imageNamed:@"toprtbss"] forState:UIControlStateNormal];
                //[self becomeNormalNav];
            }
        }];
        
        
    }
    else if (offY > (_BANNERHeight - 64.0 - 20.0 )) {
        searchView.hidden = YES;
        _clockButton.hidden = YES;
        
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"reseach"] forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
        [_searchBtn setTitle:@"  请输入关键字搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [UIView animateWithDuration:0.5 animations:^{
            _searchBtn.frame = CGRectMake(_searchBtn.frame.origin.x, _searchBtn.frame.origin.y, UIScreenWidth - _searchBtn.frame.origin.x*2 , _searchBtn.frame.size.height);
        }];
    }
}


#pragma mark ---------刷新活动倒计时的定时器创建-----------
-(void)createActivityTimer
{
    self.activityTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateActivityTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.activityTimer forMode:NSRunLoopCommonModes];
    
    [self updateActivityTimer];
}
-(void)updateActivityTimer
{
    [self refreshSecondsKillConfig];
}
#pragma mark - 刷新秒杀信息
- (void)refreshSecondsKillConfig
{
    [[ArriveEaryDefaultConfigManager shared] refreshSecondsKillConfigMessageWithOncompletion:^(NSDictionary *result, NSError *err) {
        
        [_thirdView refreshSecondsKillActivity];
        
    }];
}

@end
