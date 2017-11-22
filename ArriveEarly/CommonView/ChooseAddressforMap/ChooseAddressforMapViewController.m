//
//  ChooseAddressforMapViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ChooseAddressforMapViewController.h"

#import "AddressComTableViewCell.h"
#import "CustomBaiDuMapView.h"

#import <UINavigationController+FDFullscreenPopGesture.h>

typedef enum : NSUInteger {
    TableViewFrameTop,
    TableViewFrameCenter,
    TableViewFrameBottom,
} TableViewFrame;

@interface ChooseAddressforMapViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UISearchBarDelegate,BMKMapViewDelegate,CLLocationManagerDelegate>
{
    CGFloat tableViewRowHeight;
    LocationManager *locationServer;
    BOOL isBeginSlidingChoiceUdateArress;
}

@property (strong, nonatomic) NSMutableArray <BMKPoiInfo*>*dataArray;


@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeFrameButton;

@property (nonatomic, copy) ChooseAddressforMapBlock addressBlock;
@property (nonatomic, assign) TableViewFrame tableViewFrame;
@property (nonatomic, strong) CustomBaiDuMapView *cusBMMapView;


@property (weak, nonatomic) IBOutlet UIView *tableViewSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressContentHieght;

@end

@implementation ChooseAddressforMapViewController

+ (instancetype)chooseAddressFormVC:(UIViewController *)fromVC onCompleteBlock:(ChooseAddressforMapBlock)block
{
    ChooseAddressforMapViewController *vc = [[ChooseAddressforMapViewController alloc] initWithNibName:@"ChooseAddressforMapViewController" bundle:nil];
    vc.addressBlock = block;
//    [fromVC presentViewController:vc animated:YES completion:nil];
    [fromVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationController.delegate = self;
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    
    [self.changeFrameButton setBackgroundColor:HWColor(245, 245, 245) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.alpha = 0;
    tableViewRowHeight = KHEIGHT_6(75.0);
    [self.addressContentHieght setConstant:KHEIGHT_6(570.0/2)];
    
    self.cusBMMapView = [[CustomBaiDuMapView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64 - KHEIGHT_6(570.0/2))];
    [self.view addSubview:self.cusBMMapView];
    [self.view bringSubviewToFront:self.tableViewSuperView];
    [self.view bringSubviewToFront:self.changeFrameButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressComTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressDescCell"];
    //[self.view bringSubviewToFront:self.cusBMMapView];
    if (isBeginSlidingChoiceUdateArress) {
        [self.cusBMMapView beginSlidingChoiceUpdateArress:^(CLLocationCoordinate2D corr2d) {
            [self refreshData:corr2d];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!locationServer) {
        locationServer = [[LocationManager alloc] initOther];
        locationServer.locationOnce_stopUserLocationService = YES;
    }
    
    [self.cusBMMapView viewWillAppear];
    [self refreshData:[LocationManager sharedManager].coordinate];
    [self.cusBMMapView.mapBMKView setCenterCoordinate:[LocationManager sharedManager].coordinate animated:YES];
    
}

- (void)beginSlidingChoiceUdateArress
{
    isBeginSlidingChoiceUdateArress = YES;
}


- (void)refreshData:(CLLocationCoordinate2D)coordinate
{
    [self.view showPopupLoading];
    
    WEAK(weakSelf);
    self.dataArray =[[NSMutableArray alloc] init];
    BMKPoiInfo *info = [BMKPoiInfo new];
    info.name = [NSString stringWithFormat:@"%@%@",[LocationManager sharedManager].streetName,[LocationManager sharedManager].streetNumber];
    info.address = [LocationManager sharedManager].address;
    info.pt = [LocationManager sharedManager].coordinate;
    if ([info.address isKindOfClass:[NSString class]] && info.pt.latitude>0) {
        [_dataArray addObject:info];
    }
    [locationServer updateLocationMssagefor:coordinate Success:^{
        STRONG(strong_weakSelf, weakSelf);
        DLog(@"%@",strong_weakSelf->locationServer.poiList);
        if (strong_weakSelf->locationServer.poiList.count) {
            for (BMKPoiInfo *pInfo in locationServer.poiList) {
                if ([pInfo.address isKindOfClass:[NSString class]] && pInfo.pt.latitude>0) {
                    [self.dataArray addObject:pInfo];
                }
            }
            [self.tableView reloadData];
            
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [weakSelf.view showPopupErrorMessage:@"检索失败"];
            });
        }
        [self.view hidePopupLoading];

    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [weakSelf.view showPopupErrorMessage:@"检索失败"];
        });
        [self.view hidePopupLoading];
    }];
}

- (IBAction)backFromViewController:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)heightControllerButttonAction:(id)sender {
    self.changeFrameButton.selected = !self.changeFrameButton.selected;
    if (self.changeFrameButton.selected) {
        self.tableViewFrame = TableViewFrameTop;
    }else
    {
        self.tableViewFrame = TableViewFrameCenter;
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.changeFrameButton.selected = !self.changeFrameButton.selected;
    self.tableViewFrame = TableViewFrameTop;
    return YES;
}
//拖动按钮 让其 出于 最下方  全部收缩 表视图
#pragma mark ----------UISearchBarDelegate-------------
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if (content) {
    
        
        [locationServer poiSearch:content forCity:locationServer.city Success:^{
            if (locationServer.poiList.count) {
                [self.dataArray removeAllObjects];
            }
            
            for (BMKPoiInfo *pInfo in locationServer.poiResult.poiInfoList) {
                if ([pInfo isKindOfClass:[BMKPoiInfo class]]) {
                    if (pInfo.address && pInfo.pt.latitude>0) {
                        [self.dataArray addObject:pInfo];
                    }
                }
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    return YES;
}

#pragma mark ----------UITableViewDelegateDataSource-------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableViewFrame == TableViewFrameTop) {
        if (scrollView.contentOffset.y < -30.0)
        {
//            self.tableView.delegate = nil;
            [self heightControllerButttonAction:self.changeFrameButton];
        }
    }else if (self.tableViewFrame == TableViewFrameCenter)
    {
        if (scrollView.contentOffset.y > 2*tableViewRowHeight) {
//            self.tableView.delegate = nil;
            [self heightControllerButttonAction:self.changeFrameButton];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"AddressDescCell";
    AddressComTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    BMKPoiInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    cell.addressDesc.text  = info.name;
    cell.address.text = info.address;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewRowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKPoiInfo *info = [self.dataArray objectAtIndex:indexPath.row];
    BLOCK_EXIST(self.addressBlock, info);
    [self.navigationController popViewControllerAnimated:YES];
}

- (TableViewFrame)tableViewFrame
{
    if (self.addressContentHieght.constant > KHEIGHT_6(1000.0/2))
    {
        return TableViewFrameTop;
    }
    else if (self.addressContentHieght.constant < KHEIGHT_6(700/2))
    {
        return TableViewFrameCenter;
    }
    return TableViewFrameCenter;
}

- (void)setTableViewFrame:(TableViewFrame)tableViewFrame
{
    CGFloat height = 570.0;
    if (tableViewFrame == TableViewFrameTop) {
        height = 1100.0;
    }else
    {
        [self.view endEditing:YES];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.addressContentHieght setConstant:KHEIGHT_6(height/2)];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
//        self.tableView.delegate = self;
//        [self.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //必须清理掉 locationServer
    [locationServer stopLocation];
    locationServer = nil;
    [self.cusBMMapView clear];
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
