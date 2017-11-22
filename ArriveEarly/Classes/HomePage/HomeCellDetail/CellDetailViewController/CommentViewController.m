//
//  CommentViewController.m
//  ArriveEarly
//
//  Created by m on 2016/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentModel.h"
@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isRefresh;
    PackagMet *packagMet;
}
@property (nonatomic ,strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)NSMutableArray *contentAry;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) PageHelper *helper;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initInterFace];
    [self loadNormalStateData];
    
}
-(void)initData{
    self.dataSource = [[NSMutableArray alloc]init];
    self.contentAry = [[NSMutableArray alloc]init];
    self.helper = [[PageHelper alloc]init];
    isRefresh = NO;
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
    [self.tableView.mj_header beginRefreshing];
}
//下拉刷新
- (void)headerRefresh
{
    isRefresh = YES;
    self.helper = [[PageHelper alloc]init];
    [self.tableView.mj_footer setHidden:NO];
    [self initCommentInfoNetWorking:self.productId];
    
    
}
//上拉加载
- (void)footerRefresh
{
    [self.helper add];
    [self initCommentInfoNetWorking:self.productId];
    
}
- (void)endRefreshing
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)initCommentInfoNetWorking:(NSString *)productId
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:self.helper.params];
    [params setObject:@{@"evaProductId":productId} forKey:@"params"];
    
    AFBaseNetWork *new = [[AFBaseNetWork alloc]init];
    [new post:[@"queryByPId" url_ex] params:params progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
            
            [self endRefreshing];
            
            
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject[@"responseData"]) {
                CommentModel *model = [CommentModel yy_modelWithDictionary:dic];
                [self.contentAry addObject:dic[@"evaContent"]];
                [ary addObject:model];
            }
            
            if(isRefresh == YES){
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:ary];
            
            [self.tableView reloadData];
            
            if (self.dataSource.count < self.helper.total) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        else{
            self.dataSource = [[NSMutableArray alloc]init];
        }
        isRefresh = NO;
    } onError:^(NSError *error) {
     
        [self endRefreshing];
        [self.helper falseAdd];
    }];
}
-(void)initInterFace{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark ---------UITableViewDelegateDataSource--------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [CommentTableViewCell creatCell:tableView];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
    //数据数组
    //根据内容计算高度
    if ([_contentAry[indexPath.row] isKindOfClass:[NSNull class]]) {
        
        return 60;
        
    }else{
         CGRect rect = [_contentAry[indexPath.row] boundingRectWithSize:CGSizeMake(KScreenWidth-78, MAXFLOAT)
          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
                     //再加上其他控件的高度得到cell的高度
                     
                     return rect.size.height + 60;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
