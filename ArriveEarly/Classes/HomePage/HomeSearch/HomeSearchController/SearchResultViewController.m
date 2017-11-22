//
//  SearchResultViewController.m
//  ArriveEarly
//
//  Created by m on 2016/11/24.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultTableViewCell.h"
#import "AECellDetailViewController.h"
#import "CellDetailsViewController.h"

@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc]init];
    
    [self reloadView];
    [self initNetWorking:self.searchTF.text];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChangeOneCI:)
     name:UITextFieldTextDidChangeNotification
     object:self.searchTF];
}
-(void)textFieldTextDidChangeOneCI:(NSNotification*)obj
{
    NSLog(@"-------------->%@",self.searchTF.text);
    if([self.searchTF.text isEqualToString:@""]){
        self.searchBtn.enabled = NO;
        self.searchBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else{

        self.searchBtn.enabled = YES;
        self.searchBtn.backgroundColor = HWColor(253, 213, 3);
    
    }
}

-(void)initNetWorking:(NSString *)productName
{
    PageHelper *helper = [[PageHelper alloc]init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:helper.params];
    
    
    
    [params setObject:@{@"productName":productName,@"areaId" : ([ArriveEarlyManager shared].areaStoreInfo.areaId?[ArriveEarlyManager shared].areaStoreInfo.areaId:@"")} forKey:@"params"];
    [[[AFBaseNetWork alloc]init] post:[@"findName" url_ex] params:params  progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            
            [self.dataSource removeAllObjects];
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary*dic in responseObject[@"responseData"][@"rows"]) {
                ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
                [ary addObject:model];
            }
            self.dataSource = [NSMutableArray arrayWithArray:ary];
            [self.tableView reloadData];
        }
        else{
            self.dataSource = [[NSMutableArray alloc]init];
            [self.tableView reloadData];
        }
        
    } onError:^(NSError *error) {
        
    }];
}

-(void)reloadView
{
    self.searchTF.text = self.searchName;
    self.tableView.separatorStyle = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchResultTableViewCell"];
    
    if([self.searchTF.text isEqualToString:@""]){
        self.searchBtn.enabled = NO;
        self.searchBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else{        
        self.searchBtn.enabled = YES;
        self.searchBtn.backgroundColor = HWColor(253, 213, 3);
    }
}

#pragma mark ------------UITableViewDelegate-------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"SearchResultTableViewCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[SearchResultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    AECellDetailViewController * cellDetail = [[AECellDetailViewController alloc] init];
//    
//    cellDetail.model = self.dataSource[indexPath.row];
//    cellDetail.isStart = YES;
//    [self.navigationController pushViewController:cellDetail animated:YES];
    
    ProductModel *product = self.dataSource[indexPath.row];
    CellDetailsViewController *vc = [[CellDetailsViewController alloc]init];
    vc.dataSource = [NSMutableArray arrayWithArray:@[product]];
    vc.index = 0;
    vc.isActivity = NO;
    vc.isStart = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark ---------UITextFiledDelegate---------
//点击Return键的时候
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//当用户全部清空的时候的时候 会调用
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchBtn.enabled = NO;
    self.searchBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return YES;
}

- (IBAction)searchBtnAction:(UIButton *)sender {
    
    [self initNetWorking:self.searchTF.text];
    
}

- (IBAction)backAction:(id)sender {
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
