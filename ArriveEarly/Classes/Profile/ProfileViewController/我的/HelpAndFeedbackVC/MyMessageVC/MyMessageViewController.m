//
//  MyMessageViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"
#import <MJRefresh.h>

#import "AEMessageInfo.h"
#import "PushMessageManager.h"

@interface MyMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    PageHelper *page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;;
@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text  = @"我的消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"MyMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgCell"];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self loadNormalStateData];
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
    self.dataArray = [[NSMutableArray alloc] init];
    WEAK(weakSelf);
    kShowProgress(self)
    page = [[PageHelper alloc] init];
    
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"queryNotifi" url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(self)
        [weakSelf.tableView.mj_header endRefreshing];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self dealWithDict:responseObject[@"responseData"]];
    }];
}
- (void)footerRefresh
{
    WEAK(weakSelf);
    [page add];
    [EncapsulationAFBaseNet dictRequestAndPageTokenPost:[@"queryNotifi" url_ex] pageParams:page.params params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        STRONG(strong_weakSelf, weakSelf);
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [strong_weakSelf->page falseAdd];
            return ;
        }
        [self dealWithDict:responseObject[@"responseData"]];
    }];
}
- (void)dealWithDict:(NSDictionary *)responseObj
{
    if (![responseObj isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    
    NSArray *msgs = [responseObj objectForKey:@"rows"];
    if ([msgs isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in msgs) {
            if (dict && dict != (id)kCFNull) {
                AEMessageInfo *info = [AEMessageInfo yy_modelWithDictionary:dict];
                [self.dataArray addObject:info];
            }
        }
    }
   
    [self.tableView reloadData];
    if (self.dataArray.count < page.total) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else
    {
        [self.tableView.mj_footer resetNoMoreData];
    }
}

#pragma mark ---------UITableViewDelegateDataSource-----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHEIGHT_6(75.0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //model
    AEMessageInfo *info = self.dataArray[indexPath.row];
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgCell" forIndexPath:indexPath];
    cell.label_content.text = info.msgTitle;
    cell.label_time.text = [NSDate getTimeToLocaDatewith:@"yyyy-MM-dd HH:mm" with:info.createTime/1000];
    cell.imageButton.selected = indexPath.row;
    
    
    if (info.msgType == PushCustomTypeUrl) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataArray.count) {
        AEMessageInfo *info = self.dataArray[indexPath.row];
        DLog(@"--------------------------%d________________%@",info.msgType,info.msgUrl);
        if (info.msgType == PushCustomTypeUrl && [info.msgUrl isKindOfClass:[NSString class]]) {
            [NormalWebPageViewController changefromeVC:self andTitle:info.msgContent andLoadUrl:info.msgUrl];
        }
    }
//    AEMessageInfo *info = self.dataArray[indexPath.row];
//    if ([info.msgUrl isKindOfClass:[NSString class]]) {
//        [NormalWebPageViewController changefromeVC:self andTitle:info.msgContent andLoadUrl:info.msgUrl];
//    }
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
