//
//  MyRedPacketViewController.m
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "MyRedPacketViewController.h"

#import "CouponsInfo.h"

#import "CouponsTableViewCell.h"

#import "CouponsNormalTableViewCell.h"

#import <MJRefresh.h>

#import "RedPacketsInfo.h"
#import <YYModel.h>

@interface MyRedPacketViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    PageHelper *page;
    UIView *notRedPacketView;
    UIImageView *imageV;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray <RedPacketsInfo *>*dataArray;

@property (copy, nonatomic) RedPacketChooseBlock chooseBlock;

@end

@implementation MyRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    if (self.chooseBlock) {
        self.cusNavView.titleLabel.text = @"选择红包";
    }else
    {
        self.cusNavView.titleLabel.text = @"我的红包";
    }
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.dataArray = [[NSMutableArray alloc] init];
    

    
    [_tableView registerNib:[UINib nibWithNibName:@"CouponsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponsCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"CouponsNormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"CouponsNormalCell"];
    
    [self loadNormalStateData];
}

-(void)notRedPacket{
    notRedPacketView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth-155)/2, (KScreenHeight-95)/2, 155, 95)];
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, notRedPacketView.frame.size.width, notRedPacketView.frame.size.height)];
     imageV.image = [UIImage imageNamed:@"wuhongbao"];
    
   
    [notRedPacketView addSubview:imageV];
    [self.view addSubview:notRedPacketView];
    notRedPacketView.hidden = NO;
    self.tableView.hidden = YES;
}
-(void)redPacket{
    self.tableView.hidden = NO;
    notRedPacketView.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WEAK(weakSelf);
    [ArriveEarlyManager loginSuccess:^{
        //刷新页面信息
        [weakSelf.tableView.mj_header beginRefreshing];
    } fail:^{
        [weakSelf.view showPopupErrorMessage:@"请登录"];
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
    
    //orderInfo  根据ID 进行 请求 详情
    [self.dataArray removeAllObjects];
    self.dataArray = [[NSMutableArray alloc] initWithObjects:[RedPacketsInfo new], nil];
    WEAK(weakSelf);
    page = [[PageHelper alloc] init];
    
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"findRegBag" url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self notRedPacket];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self redPacket];
        [self dealWithDict:responseObject];
    }];
    
}
- (void)footerRefresh
{
    WEAK(weakSelf);
    [page add];
    kShowProgress(self);
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"findRegBag" url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);
        
        [weakSelf.tableView.mj_footer endRefreshing];
        if (error) {
            [page falseAdd];
            [weakSelf.view showPopupErrorMessage:error.domain];
            [self notRedPacket];
            return ;
        }
        [self redPacket];
        [weakSelf dealWithDict:responseObject];
    }];
}
- (void)dealWithDict:(NSDictionary *)responseObject
{
    NSArray *dataA = responseObject[@"responseData"];
    if ([dataA isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dataD in dataA) {
            if ([dataD isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = dataD[@"rbConfig"];
                if ([dataDic isKindOfClass:[NSDictionary class]]) {
                    RedPacketsInfo *info = [RedPacketsInfo yy_modelWithDictionary:dataDic];
                    [self.dataArray addObject:info];
                }
            }
        }
    }
    if (self.dataArray.count < page.total + 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [self.tableView reloadData];
  
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 12.0;
    }
    return KHEIGHT_6(20.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 0.01;
    }
    return KHEIGHT_6(115.0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        CouponsNormalTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:@"CouponsNormalCell" forIndexPath:indexPath];
        normalCell.backgroundColor = [UIColor clearColor];
        normalCell.contentView.backgroundColor = [UIColor clearColor];
        cell = normalCell;
    }
    else
    {
        CouponsTableViewCell *couponsCell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell" forIndexPath:indexPath];
        couponsCell.info = _dataArray[indexPath.section];
        cell = couponsCell;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        [NormalWebPageViewController changefromeVC:self andTitle:@"使用说明" andLoadUrl:nil];
//        return;
//    }
    
    
    if (self.chooseBlock) {
        RedPacketsInfo *info = _dataArray[indexPath.section];
        if ([info.rbType intValue] == RedPacketType_NewUser) {
            [self.view showPopupErrorMessage:@"新用户红包已经自动匹配了"];
            return;
        }
        if (self.limitPrice < info.rbLimitValue) {
            [self.view showPopupErrorMessage:[NSString stringWithFormat:@"还差%@,就可以使用这个红包了。",Money((info.rbLimitValue - self.limitPrice))]];
            return;
        }
        
        BLOCK_EXIST(self.chooseBlock,info);
        [self.navigationController popViewControllerAnimated:YES];
    }

}







- (void)setChooiceRedPacketInfoOnCompleteBlock:(RedPacketChooseBlock)block
{
    self.chooseBlock = block;
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

- (void)dealloc
{
    DLogMethod();
}

@end
