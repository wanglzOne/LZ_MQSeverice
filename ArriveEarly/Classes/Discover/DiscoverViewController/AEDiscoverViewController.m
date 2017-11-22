//
//  AEDiscoverViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/11.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "AEDiscoverViewController.h"
#import "DiscoverInfo.h"
#import "DisCoverTableViewCell.h"
#import "DiscoverDetailViewController.h"
#import "CSView.h"
@interface AEDiscoverViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    PageHelper *page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <DiscoverInfo *>*tableViewDatas;

@end

@implementation AEDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.frame = CGRectMake(0, 48, KScreenWidth, KScreenHeight - 48.0 - 44.0);
    [self addCustomNavigationWithTitle:@"发现"];
    self.cusNavView.backButton.hidden = YES;
    self.cusNavView.backgroundColor = [UIColor whiteColor];
    
    //[self.cusNavView createRightButtonWithTitle:nil image:[UIImage imageNamed:@"bianji"] target:self action:@selector(riughtButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DisCoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiscoverCell"];
    self.tableViewDatas = [[NSMutableArray alloc] init];
    [self loadNormalStateData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHEIGHT_6(10.0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableViewDatas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DiscoverCell";
//    NSInteger index = indexPath.section;
    DisCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    //cell.constraints
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscoverInfo *info = self.tableViewDatas[indexPath.section];
    DiscoverDetailViewController *vc = [[DiscoverDetailViewController alloc] initWithNibName:@"DiscoverDetailViewController" bundle:nil];
    
    vc.info = info;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 自动计算cell的高度
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath*)indexPath
{
    static DisCoverTableViewCell* sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //            sizingCell = [DisCoverTableViewCell tableView:_tableView cellForRowAtIndexPath:indexPath order:nil identifier:@"KernelListTableViewCell"];
        //使用xib注册了cell 的写法
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"DiscoverCell"];
    });
    
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell atIndexPath:indexPath];
}

- (void)configureBasicCell:(DisCoverTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    DiscoverInfo *info = self.tableViewDatas[indexPath.section];
    cell.info = info;
}
- (CGFloat)calculateHeightForConfiguredSizingCell:(DisCoverTableViewCell *)sizingCell atIndexPath:(NSIndexPath*)indexPath
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    //    //UILayoutFittingExpandedSize  UILayoutFittingCompressedSize
    DiscoverInfo *info = self.tableViewDatas[indexPath.section];
    
 //   if (!info.foundImage.count) {
////        return CGRectGetMaxY(sizingCell.titleLabel.frame) + 20;
 //        return CGRectGetMaxY(sizingCell.titleLabel.frame) + KHEIGHT_6(10);
//    }
    
    [sizingCell.imageContentViewHeight setConstant:CGRectGetMaxY(sizingCell.imageView1.frame) + KHEIGHT_6(16)];
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return CGRectGetMaxY(sizingCell.placeContent.frame);; // Add 1.0f for the cell separator height
}



- (void)requestData
{
    NSString *areaid = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaid = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }else{
            [self endRefresh];
        CSView *clos =[CSView initCSView];
        [clos show_custom];
    

        return ;

    }
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"foundInfo" url_ex] pageParams:page.params params:@{@"areaId":areaid} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self endRefresh];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [page falseAdd];
            return ;
        }
        NSMutableArray *marray = [[NSMutableArray alloc] init];
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject[@"responseData"]) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    DiscoverInfo *info = [DiscoverInfo yy_modelWithDictionary:dict];
                    [marray addObject:info];
                }
            }
        }
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableViewDatas removeAllObjects];
        }
        [self.tableViewDatas addObjectsFromArray:marray];
        [self.tableView reloadData];
        
        
        if (self.tableViewDatas.count < page.total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)loadNormalStateData
{
    WEAK(weakSelf);
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }
    if (!self.tableView.mj_header) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
}
//下拉刷新
- (void)headerRefresh
{
    page = [[PageHelper alloc] init];
    [self requestData];
}
//上拉加载
- (void)footerRefresh
{
    if (self.tableView.mj_header.isRefreshing) {
        return;
    }
    [page add];
    [self requestData];
}
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


- (void)riughtButtonAction
{
    
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
