//
//  MyAddressViewController.m
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressTableViewCell.h"
#import "AddNewAddressViewController.h"
#import <MJRefresh.h>
#import <YYModel.h>



@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    PageHelper *page;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <Adress_Info *>*dataAry;//存地址数组

@property(nonatomic,copy) ChooseAddressBlock adressBlock;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtuton;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets  = YES;

    [self initInterFace];
    if (_showType == AddressShowTypeChoose) {
        self.cusNavView.titleLabel.text = @"选择收货地址";
    }else
    {
        self.cusNavView.titleLabel.text = @"收货地址";
    }
    self.addAddressBtuton.layer.borderWidth = 1.0;
    self.addAddressBtuton.layer.borderColor = UIColorFromRGBA(0xe5e5e5, 1).CGColor;
    [self.cusNavView createRightButtonWithTitle:@"管理" image:nil target:self action:@selector(managerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cusNavView.rightButton setTitle:@"完成" forState:UIControlStateSelected];
    
    [self loadNormalStateData];
}

-(void)initInterFace
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 67, KScreenWidth, KScreenHeight- 64 - KHEIGHT_6(50.0) - 5.0) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAddressTableViewCell"];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ArriveEarlyManager loginSuccess:^{
        //刷新页面信息
        [self.tableView.mj_header beginRefreshing];
    } fail:^{
        [self.view showPopupErrorMessage:@"请登录"];
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
        
        self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
}
- (void)headerRefresh
{
    self.dataAry = [[NSMutableArray alloc] init];
    //orderInfo  根据ID 进行 请求 详情
    self.dataAry = [[NSMutableArray alloc] init];
    page = [[PageHelper alloc] init];
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"userAddress" url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {

        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self dealWithDict:responseObject];
    }];
}
- (void)footerRefresh
{
    [page add];
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"userAddress" url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        [self.tableView.mj_footer endRefreshing];
        STRONG(strong_self, self);
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [strong_self->page falseAdd];
            return ;
        }
        [self dealWithDict:responseObject];
    }];
}
- (void)dealWithDict:(NSDictionary *)responseObject
{
    NSArray *arr = responseObject[@"responseData"];
    if ([arr isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in arr) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                Adress_Info *info = [Adress_Info yy_modelWithDictionary:dict];
                [self.dataAry addObject:info];
            }
        }
        
    }
    
    [self.tableView reloadData];
    
    if (self.dataAry.count < page.total) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer resetNoMoreData];
    }
}

//管理操作
- (IBAction)managerAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.tableView reloadData];
}
//新增收货地址
- (IBAction)addNewAddress:(UIButton *)sender {
    AddNewAddressViewController *vc = [[AddNewAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------UITableViewDelegateDataSource-------------
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHEIGHT_6(11.0);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Adress_Info *info = self.dataAry[indexPath.row];
    static NSString *identifer = @"MyAddressTableViewCell";
    MyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MyAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.edite = self.cusNavView.rightButton.selected;
    //cell.addressInfo;
    cell.addressInfo = info;
    cell.edit_change.tag = indexPath.row;
    [cell.edit_change addTarget:self action:@selector(editeAddress:) forControlEvents:UIControlEventTouchUpInside];
    cell.edit_delete.tag = indexPath.row;
    [cell.edit_delete addTarget:self action:@selector(deleteAddress:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHEIGHT_6(66.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Adress_Info* add = self.dataAry[indexPath.row];
    if (_showType == AddressShowTypeManagement) {
        //push 详情
        
    }
    else{
        BLOCK_EXIST(self.adressBlock, @[add]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)editeAddress:(UIButton *)btn
{
    Adress_Info* add = self.dataAry[btn.tag];
    AddNewAddressViewController *vc = [[AddNewAddressViewController alloc]init];
    vc.addressInfo = add;
    vc.showType = AddNewAddressShowType_Edite;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)deleteAddress:(UIButton *)btn
{
    Adress_Info* add = self.dataAry[btn.tag];
    //请求
    [UIAlertController showInViewController:self withTitle:nil message:@"确定删除所选地址" preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        [self deleteAddressInfo:add];
    }];
}
- (void)deleteAddressInfo:(Adress_Info *)info
{
    kShowProgress(self);
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"deleteUserAddress" url_ex] params:@{@"id" : @([info.id_address intValue])} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(self);
        
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        [self.tableView.mj_header beginRefreshing];
    }];
}

- (void)setChooiceAddressOnCompleteBlock:(ChooseAddressBlock)block
{
    self.adressBlock = block;
}

- (void)viewDidDisappear:(BOOL)animated
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager invalidateSessionCancelingTasks:YES];
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
