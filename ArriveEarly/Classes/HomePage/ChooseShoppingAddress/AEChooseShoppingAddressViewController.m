//
//  AEChooseShoppingAddressViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEChooseShoppingAddressViewController.h"
#import "AEAddressTableViewCell.h"
#import "AEIncreaseNewAddressViewController.h"
#import "LocationManager.h"

#import "AddNewAddressViewController.h"
#import "MyAddressTableViewCell.h"
#import "CityListViewController.h"
#import "PoiDataListView.h"
#import "LoginViewController.h"

@interface AEChooseShoppingAddressViewController ()<UITableViewDelegate,UITableViewDataSource,CityListViewDelegate, UITextFieldDelegate, PoiDataListViewDelegate>
{
    LocationManager *location;
    CityListViewController *cityListView;
    __weak IBOutlet UIView *inputAddressTextFieldSuperView;
    CGRect addresstfFrame;
    UIView *searchView;
    
    
    PoiDataListView *poiDataListView;
}



@property (strong, nonatomic) UIView *aDreaaview;

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (nonatomic, strong) NSArray * sectionTitleArray;
@property (nonatomic, strong) NSMutableArray * nearbyArray;

@property (nonatomic, strong) NSMutableArray * myAddressArray;

@property (weak, nonatomic) IBOutlet UIButton *locationCityButton;
@property (weak, nonatomic) IBOutlet UITextField *InputAddressTextField;


@end

@implementation AEChooseShoppingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    location = [[LocationManager alloc] initOther];
    location.locationOnce_stopUserLocationService = YES;
    self.cusNavView.titleLabel.text = @"选择收货地址";
    [self.cusNavView createRightButtonWithTitle:@"新增地址" image:nil target:self action:@selector(newAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.addressTableView registerNib:[UINib nibWithNibName:@"MyAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAddressTableViewCell"];
    
    
    self.addressTableView.tableHeaderView = [self loadHeadView];
    [self.locationCityButton setTitle:@"定位中..." forState:UIControlStateNormal];
    //kShowProgress(self);
    [location startLocateAndGeoCurrentCityLocationWithSuccess:^{
        if (location.city.length) {
            [self.locationCityButton setTitle:location.city forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
    
    self.sectionTitleArray = [NSArray arrayWithObjects: @"附近地址",nil];
    //附近地址 是根据经纬度   获取出来的  poi——address
    self.nearbyArray = [NSMutableArray new];
    self.myAddressArray = [NSMutableArray new];
    
    
    [self refreshData];
    
}

- (void)refreshData
{
    self.nearbyArray =[[NSMutableArray alloc] init];
    BMKPoiInfo *info = [BMKPoiInfo new];
    info.name = [NSString stringWithFormat:@"%@%@",[LocationManager sharedManager].streetName,[LocationManager sharedManager].streetNumber];
    info.address = [LocationManager sharedManager].address;
    info.pt = [LocationManager sharedManager].coordinate;
    [_nearbyArray addObject:info];
    [location updateLocationMssagefor:[LocationManager sharedManager].coordinate Success:^{
        if (location.city.length) {
            [self.locationCityButton setTitle:location.city forState:UIControlStateNormal];
        }
        if (location.poiList.count) {
            [self.nearbyArray removeAllObjects];
            for (BMKPoiInfo *pInfo in location.poiList) {
                if (pInfo.address && pInfo.pt.latitude>0) {
                    [self.nearbyArray addObject:pInfo];
                }
            }
            [self.addressTableView reloadData];
        }else
        {
            [self.view showPopupErrorMessage:@"检索失败"];
        }
    } failure:^(NSError *error) {
        [self.view showPopupErrorMessage:@"检索失败"];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ArriveEarlyManager loginSuccess:^{
        [self loadMyAddress];
    } fail:^{
        
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    addresstfFrame = CGRectMake(92, 0, inputAddressTextFieldSuperView.frame.size.width - 92, inputAddressTextFieldSuperView.frame.size.height);
    if (self.InputAddressTextField.superview == inputAddressTextFieldSuperView) {
        self.InputAddressTextField.frame = addresstfFrame;
    }
}

#pragma - mark 新增地址
- (void)newAddress:(UIButton *)btn
{
    [ArriveEarlyManager loginSuccess:^{
        AddNewAddressViewController *vc = [[AddNewAddressViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } fail:^{
        [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
            
        }];
    }];
    
}
- (IBAction)chooseCityButttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    //cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
    //历史选择城市列表
    //cityListView.arrayHistoricalCity = [NSMutableArray arrayWithObjects:@"福州",@"厦门",@"泉州", nil];
    //定位城市列表
    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:location.city?location.city:@"定位失败", nil];
    cityListView.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:cityListView animated:YES completion:nil];

    
}
#pragma mark - CityListViewDelegate
- (void)didClickedWithCityName:(NSString*)cityName
{
    if (cityName.length) {
        [self.locationCityButton setTitle:cityName forState:UIControlStateNormal];
    }
}
#pragma mark  ---代理数据源方法


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitleArray.count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger result;
    
    NSString *secName = self.sectionTitleArray[section];
    if ([secName isEqualToString:@"我的地址"]) {
        result= self.myAddressArray.count;
    }else
    {
        result = self.nearbyArray.count;
    }
   return result;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *secName = self.sectionTitleArray[indexPath.section];
    if ([secName isEqualToString:@"我的地址"]) {
        Adress_Info *info = self.myAddressArray[indexPath.row];
        static NSString *identifer = @"MyAddressTableViewCell";
        MyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!cell) {
            cell = [[MyAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cell.edite = self.cusNavView.rightButton.selected;
        cell.addressInfo = info;
        return cell;
    }
    BMKPoiInfo *info = self.nearbyArray[indexPath.row];
    UITableViewCell * nearbyCell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if (!nearbyCell) {
        nearbyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
    }
    nearbyCell.textLabel.text = info.name;
    nearbyCell.textLabel.font = [UIFont systemFontOfSize:15.0];
    return nearbyCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *secName = self.sectionTitleArray[indexPath.section];
    if ([secName isEqualToString:@"我的地址"]) {
        return KHEIGHT_6(70.0);
    }else
    {
        return 44.0;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitleArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *secName = self.sectionTitleArray[indexPath.section];
    if ([secName isEqualToString:@"我的地址"]) {
        
        Adress_Info *info = [self.myAddressArray objectAtIndex:indexPath.row];
        
        [ArriveEarlyManager shared].coordinate = CLLocationCoordinate2DMake(info.latitude, info.longtitude);
        [ArriveEarlyManager shared].address = info.address;
        
        [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *erroe) {
            kHiddenProgress(self);
            if (erroe) {
                [self.view showPopupErrorMessage:erroe.domain];
                return ;
            }
            DLog(@"-------->>>>>>>\n请刷新首页信息");
            [self popTOFromeVC];
            
        }];
    }else
    {
        BMKPoiInfo *poiInfo = self.nearbyArray[indexPath.row];
        [ArriveEarlyManager shared].address = poiInfo.name;
        [self updateRegionalInformationfor:poiInfo.pt];
    }
}
#pragma mark - PoiDataListViewDelegate
- (void)poiDataListView:(PoiDataListView *)dataListView didIndexRow:(NSInteger)row didInfo:(id)info{
    BMKPoiInfo *poiInfo = info;
    if (![info isKindOfClass:[BMKPoiInfo class]]) {
        return;
    }
    [ArriveEarlyManager shared].address = poiInfo.address;
    [self updateRegionalInformationfor:poiInfo.pt];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *content = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (content) {
        NSString *city = [self.locationCityButton titleForState:UIControlStateNormal];
        if ([city containsString:@"定位中..."] || [city containsString:@"网络"]) {
            [self.view showPopupErrorMessage:@"正在定位当前城市"];
            return YES;
        }
        [location poiSearch:content forCity:city Success:^{
            if (location.poiResult.poiInfoList.count) {
                [poiDataListView reloadForData:location.poiResult.poiInfoList];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (!textField.text.length && self.InputAddressTextField.superview != inputAddressTextFieldSuperView) {
        [self changeInputAddressTextFieldToinputAddressTextFieldSuperView];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.InputAddressTextField.superview != searchView) {
        [self changeInputAddressTextFieldToSearchNavView];
    }
}




//加载我的地址
- (void)loadMyAddress
{
    kShowProgress(self);
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"userAddress" url_ex] pageParams:[PageHelper new].params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(self);
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.addressTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self dealWithDict:responseObject];
    }];
}

- (void)dealWithDict:(NSDictionary *)responseObject
{
    NSMutableArray *dataAry = [NSMutableArray new];
    NSArray *arr = responseObject[@"responseData"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in arr) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                Adress_Info *info = [Adress_Info yy_modelWithDictionary:dict];
                [dataAry addObject:info];
            }
        }
    }
    self.sectionTitleArray = [NSArray arrayWithObjects:@"我的地址", @"附近地址",nil];
    [self.myAddressArray removeAllObjects];
    self.myAddressArray = dataAry;
    [self.addressTableView reloadData];
}

#pragma mark - 定位当前位置
- (void)mylocationAddress:(UIButton *)btn
{
    kShowProgress(self);
    [location startLocateAndGeoCurrentCityLocationWithSuccess:^{
        kHiddenProgress(self);
        [ArriveEarlyManager shared].address = location.address;
        [self updateRegionalInformationfor:location.coordinate];
    } failure:^(NSError *error) {
        kHiddenProgress(self);
        [self.view showPopupErrorMessage:@"定位失败，请检查您的网络设置"];
    }];
}

- (void)updateRegionalInformationfor:(CLLocationCoordinate2D)coordinate
{
    kShowProgress(self);
    
    [ArriveEarlyManager shared].coordinate = coordinate;
    [[ArriveEarlyManager shared] updateRegionalInformationOnComplete:^(AreaStoreInfo *areaStoreInfo, NSError *erroe) {
        kHiddenProgress(self);
        if (erroe) {
            [self.view showPopupErrorMessage:erroe.domain];
            return ;
        }
        DLog(@"-------->>>>>>>\n请刷新首页信息");
        [self popTOFromeVC];
    }];
}

- (UIView *)loadHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44.0)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, CGRectGetWidth(headView.frame), CGRectGetHeight(headView.frame));
    [btn setImage:[UIImage imageNamed:@"myAddress"] forState:UIControlStateNormal];
    [btn setTitle:@"  定位当前位置" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn addTarget:self action:@selector(mylocationAddress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headView addSubview:btn];
    return headView;
}



- (void)changeInputAddressTextFieldToinputAddressTextFieldSuperView
{
    if (![searchView.superview isKindOfClass:[self.cusNavView class]]) {
        return;
    }
    [poiDataListView removeFromSuperview];
    self.InputAddressTextField.text = @"";
    [inputAddressTextFieldSuperView addSubview:self.InputAddressTextField];
    self.InputAddressTextField.frame = CGRectMake(58,  -54, KScreenWidth - 120, 44);
    [UIView animateWithDuration:0.45 animations:^{
        self.InputAddressTextField.frame = addresstfFrame;
        searchView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [searchView removeFromSuperview];
        [self.InputAddressTextField endEditing:YES];
    }];
}

- (void)changeInputAddressTextFieldToSearchNavView
{

    [self createSearchNavView];
    [self.cusNavView addSubview:searchView];
    [searchView addSubview:self.InputAddressTextField];
    [self.view addSubview:poiDataListView];
    self.InputAddressTextField.text = @"";
    self.InputAddressTextField.frame = CGRectMake(addresstfFrame.origin.x, 20 + 54, KScreenWidth - 120, 44);
    searchView.alpha = 0.0;
    [UIView animateWithDuration:0.45 animations:^{
        //self.InputAddressTextField.frame = CGRectMake(58, -54, KScreenWidth - 120, 44);
        self.InputAddressTextField.frame = CGRectMake(58, 20, KScreenWidth - 120, 44);
        searchView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}
- (void)createSearchNavView
{
    if (searchView) {
        return;
    }
    poiDataListView = [PoiDataListView loadXIB];
    
    
    searchView = [[UIView alloc] initWithFrame:self.cusNavView.bounds];
    searchView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-10, 20, 60, 44);
    [btn setImage:[UIImage imageNamed:@"top_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backToinputAddressTextFieldSuperView) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btn];
    
    poiDataListView.frame = CGRectMake(0, CGRectGetHeight(searchView.frame), searchView.frame.size.width, KScreenHeight - CGRectGetHeight(searchView.frame));
    [poiDataListView configUI];
    poiDataListView.delegate = self;
}
- (void)backToinputAddressTextFieldSuperView
{
    [self changeInputAddressTextFieldToinputAddressTextFieldSuperView];
}

- (void)popTOFromeVC{
    
    if (self.updateBlock) {
        self.updateBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
