//
//  AEMyCollectionViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEMyCollectionViewController.h"

#import "AECollectTableViewCell.h"

#import "CellDetailsViewController.h"

@interface AEMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    PageHelper *page;
    BOOL isviewDidLoad;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <ProductModel *>*dataAry;

//@property(nonatomic,strong) NSMutableDictionary *labelsDict;


@property(nonatomic,strong)NSMutableArray *deleteProductIDS;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewHeight;

@end

@implementation AEMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isviewDidLoad = YES;
    // Do any additional setup after loading the view from its nib.
    [_editViewHeight setConstant:50.0];
    [self.editViewBottom setConstant:-_editViewHeight.constant];
    self.cusNavView.titleLabel.text  = @"我的收藏";
    [self.cusNavView createRightButtonWithTitle:@"编辑" image:nil target:self action:@selector(eniteProDuct:) forControlEvents:UIControlEventTouchUpInside];
    [self.cusNavView.rightButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.tableView registerNib:[UINib nibWithNibName:@"AECollectTableViewCell" bundle:nil] forCellReuseIdentifier:@"AECollectCell"];
    [self loadNormalStateData];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.tableView.mj_header.isRefreshing && !self.tableView.mj_footer.isRefreshing && !isviewDidLoad) {
        [self.tableView.mj_header beginRefreshing];
    }
    isviewDidLoad = NO;
}
- (void)eniteProDuct:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.editViewBottom setConstant:0];
    }else
    {
        [self.deleteProductIDS removeAllObjects];
        [self.editViewBottom setConstant:-_editViewHeight.constant];
    }
    
    [self.tableView reloadData];
    
}

- (IBAction)deledateAction:(id)sender {
    if (!self.deleteProductIDS.count) {
        return;
    }
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"addCollection" url_ex] params:@{@"products" : [self.deleteProductIDS yy_modelToJSONString],@"flag" : @(1)} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        //成功
        for (ProductModel *model in [self.dataAry mutableCopy]) {
            if ([self.deleteProductIDS containsObject:model.productId]) {
                [self.dataAry removeObject:model];
            }
        }
        [self.deleteProductIDS removeAllObjects];
        [self eniteProDuct:self.cusNavView.rightButton];
        [self headerRefresh];
    }];
    
    
    
    
    
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ProductModel *product = self.dataAry[indexPath.row];
    AECollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AECollectCell" forIndexPath:indexPath];
    cell.product = product;
    cell.isEditing = self.cusNavView.rightButton.selected;
    if ([self.deleteProductIDS containsObject:product.productId]) {
        cell.chooseButton.selected = YES;
    }else
    {
        cell.chooseButton.selected = NO;
    }
    int star = product.goodEva * 5;
    if (star>=5) {
        cell.star = 5;
    }else
    {
        cell.star = star;
    }
    
    
    cell.chooseButton.tag = indexPath.row + 100;
    [cell.chooseButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.cusNavView.rightButton.selected) {
        return;
    }
    ProductModel *product = self.dataAry[indexPath.row];
    CellDetailsViewController *vc = [[CellDetailsViewController alloc]init];
//    vc.dataSource = [NSMutableArray arrayWithArray:self.dataAry];
//    vc.index = indexPath.row;
    vc.dataSource = [NSMutableArray arrayWithArray:@[product]];
    vc.index = 0;
    vc.isActivity = NO;
    vc.isStart = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    ProductModel *product = self.dataAry[btn.tag-100];
    if (btn.selected && product.productId) {
        [self.deleteProductIDS addObject:product.productId];
    }else
    {
        [self.deleteProductIDS removeObject:product.productId];
    }
}












- (void)loadNormalStateData
{
    WEAK(weakSelf);
    self.dataAry = [[NSMutableArray alloc] init];
    if (!self.tableView.mj_footer) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }
    
    if (!self.tableView.mj_header) {
        
        self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
}
- (void)headerRefresh
{
    if (self.cusNavView.rightButton.selected) {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        [dic setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId forKey:@"areaId"];
    }else
    {
        [dic setObject:@"" forKey:@"areaId"];
    }
    page = [[PageHelper alloc] init];
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"collectionList" url_ex] pageParams:page.params params:dic onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self.dataAry removeAllObjects];
        [self dealWithDict:responseObject];
    }];
}
- (void)footerRefresh
{
    if (self.cusNavView.rightButton.selected) {
        return;
    }
    [page add];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        [dic setObject:[ArriveEarlyManager shared].areaStoreInfo.areaId forKey:@"areaId"];
    }else
    {
        [dic setObject:@"" forKey:@"areaId"];
    }
    
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"collectionList" url_ex] pageParams:page.params params:dic onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [page falseAdd];
            return ;
        }
        [self dealWithDict:responseObject];
    }];
}
- (void)dealWithDict:(NSDictionary *)responseObject
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject[@"responseData"];
            if ([dict[@"total"] isKindOfClass:[NSNumber class]] && dict[@"total"] != (id)kCFNull) {
                self.cusNavView.titleLabel.text  = [NSString stringWithFormat:@"我的收藏(%d)",[dict[@"total"] intValue]];
            }
            if ([dict[@"rows"] isKindOfClass:[NSArray class]] && dict[@"rows"] != (id)kCFNull) {
                NSArray *rows = dict[@"rows"];
                for (NSDictionary *productDict in rows) {
                    if ([productDict isKindOfClass:[NSDictionary class]] && productDict != (id)kCFNull) {
                        if ([productDict[@"productInfo"] isKindOfClass:[NSDictionary class]] && productDict[@"productInfo"] != (id)kCFNull) {
                            ProductModel *model = [ProductModel special_yy_modelWithDictionary:productDict];
                            model.goodEva = [productDict[@"goodEva"] floatValue];
                            if (model) {
                                [self.dataAry addObject:model];
                            }
                        }
                    }
                }
            }
            [self.tableView reloadData];
        }

    }
    
    
}

- (NSMutableArray *)deleteProductIDS
{
    if (!_deleteProductIDS) {
        _deleteProductIDS = [[NSMutableArray alloc] init];
    }
    return _deleteProductIDS;
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
