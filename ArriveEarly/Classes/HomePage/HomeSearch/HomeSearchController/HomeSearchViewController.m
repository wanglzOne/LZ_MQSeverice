//
//  HomeSearchViewController.m
//  ArriveEarly
//
//  Created by m on 2016/11/14.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "SearchOfFlowLayout.h"
#import "HistoryViewCell.h"
#import "HistorySearchTableViewCell.h"
#import "ProductModel.h"
#import "SearchProductView.h"
#import "SearchResultViewController.h"
@interface HomeSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBottomHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) SearchProductView *searchShowView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;


@property (nonatomic ,strong)NSMutableArray *data;
@property (nonatomic ,strong)HistoryViewCell *cell;

@property (nonatomic ,strong) NSMutableArray *historyData;

//清楚历史记录view


@end

@implementation HomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self.searchShowView isHidden:YES];
    [self initData];
    [self initTagNetWorking];
    [self reloadInterFace];
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
        [self.searchShowView isHidden:YES];
    }
    else{
        [self.searchShowView.dataSource removeAllObjects];
        [self.searchShowView.tableView reloadData];
        self.searchBtn.enabled = YES;
        self.searchBtn.backgroundColor = HWColor(253, 213, 3);
        [self.searchShowView isHidden:NO];
        [self initFindNameNetWorking:self.searchTF.text];
    }
}

-(void)initData{
    _data = [[NSMutableArray alloc]init];
    _historyData = [NSMutableArray arrayWithArray:HisAry];
}
-(void)initTagNetWorking
{
    [[[AFBaseNetWork alloc]init] post:[@"searchHot" url_ex] params:nil progress:nil responseObject:^(id responseObject) {
        
        NSString *str = [NSString stringWithFormat:@"%@",responseObject[@"responseData"]];
        NSArray *ary = [str componentsSeparatedByString:@","];
        _data = [NSMutableArray arrayWithArray:ary];
        [_collectionView reloadData];
        
    } onError:^(NSError *error) {
        
    }];
}

-(void)initFindNameNetWorking:(NSString *)productName
{
    PageHelper *helper = [[PageHelper alloc]init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:helper.params];
    [params setObject:@{@"productName":productName,@"areaId" : ([ArriveEarlyManager shared].areaStoreInfo.areaId?[ArriveEarlyManager shared].areaStoreInfo.areaId:@"")} forKey:@"params"];
    
    [[[AFBaseNetWork alloc]init] post:[@"findName" url_ex] params:params  progress:nil responseObject:^(id responseObject) {
        
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            
            NSMutableArray *ary = [[NSMutableArray alloc]init];
            for (NSDictionary*dic in responseObject[@"responseData"][@"rows"]) {
                ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
                [ary addObject:model];
            }
            self.searchShowView.dataSource = [NSMutableArray arrayWithArray:ary];
            [self.searchShowView.tableView reloadData];
        }
        
    } onError:^(NSError *error) {
        
    }];
}

-(void)reloadInterFace
{
    SearchOfFlowLayout *layout = [[SearchOfFlowLayout alloc]init];
    layout.maximumInteritemSpacing = 10;
    _collectionView.collectionViewLayout = layout;    
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.bounces = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HistorySearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistorySearchTableViewCell"];
    
    float size = self.historyData.count * 40;
    float heigh = size < KScreenHeight -285 ? size : KScreenHeight -285;
    self.toBottomHeight.constant = KScreenHeight -heigh -245;
}
#pragma mark -------collectionViewDelegate-------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5,15,0,15);//上左下右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HistoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
    cell.keyword = _data[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:nil options:nil][0];
    }
    _cell.keyword = _data[indexPath.row];
    return [_cell sizeForCell];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的是第%d个标签",(int)indexPath.row);
    
    SearchResultViewController *vc = [[SearchResultViewController alloc]init];
    vc.searchName = _data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    //
    NSMutableArray *ary = [[NSMutableArray alloc]initWithArray:HisAry];
    if ([ary containsObject:_data[indexPath.row]]) {
        for (int i = 0; i < ary.count; i++) {
            if ([_data[indexPath.row] isEqual:ary[i]]) {
                [ary removeObjectAtIndex:i];
            }
        }
    }
    [ary addObject:_data[indexPath.row]];
    //逆向遍历
    NSEnumerator *enumerator = [ary reverseObjectEnumerator];
    ary = (NSMutableArray*)[enumerator allObjects];    
    NSArray *array = [NSArray arrayWithArray:ary];
    [kUserDef setObject:array forKey:@"HisAry"];
    [_historyData removeAllObjects];
    _historyData = [NSMutableArray arrayWithArray:HisAry];
    float size = self.historyData.count * 40;
    float heigh = size < KScreenHeight -285 ? size : KScreenHeight -285;
    self.toBottomHeight.constant = KScreenHeight -heigh -245;
    [self.tableView reloadData];
    
}




#pragma mark ------UITableViewDelegate------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"HistorySearchTableViewCell";
    HistorySearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[HistorySearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.historyTitle.text = _historyData[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchResultViewController *vc = [[SearchResultViewController alloc]init];
    vc.searchName = _historyData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

}

//清除历史记录

- (IBAction)cleanHistoryData:(UIButton *)sender {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除历史记录" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSArray *ary =[[NSArray alloc]init];
        [kUserDef setObject:ary forKey:@"HisAry"];
        [_historyData removeAllObjects];
        _historyData = [NSMutableArray arrayWithArray:HisAry];
        float size = self.historyData.count * 40;
        float heigh = size < KScreenHeight -285 ? size : KScreenHeight -285;
        self.toBottomHeight.constant = KScreenHeight -heigh -245;
        [self.tableView reloadData];
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark --------UItextFiledDelegate--------
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
    [self.searchShowView isHidden:YES];
    return YES;
}


//点击搜索操作
- (IBAction)searchBtnAction:(UIButton *)sender {
    //
    if ([self.searchTF.text isEqualToString:@""]) {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入搜索内容" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
    else{
        
        SearchResultViewController *vc = [[SearchResultViewController alloc]init];
        vc.searchName = self.searchTF.text;
        [self.navigationController pushViewController:vc animated:YES];
        [self.searchShowView isHidden:YES];
        
        NSMutableArray *ary = [[NSMutableArray alloc]initWithArray:HisAry];
        if ([ary containsObject:self.searchTF.text]) {
            for (int i = 0; i < ary.count; i++) {
                if ([self.searchTF.text isEqual:ary[i]]) {
                    [ary removeObjectAtIndex:i];
                }
            }
        }
        if (![ary containsObject:self.searchTF.text]) {
            [ary addObject:self.searchTF.text];
        }
        //逆向遍历
        NSEnumerator *enumerator = [ary reverseObjectEnumerator];
        ary = (NSMutableArray*)[enumerator allObjects];
        NSArray *array = [NSArray arrayWithArray:ary];
        [kUserDef setObject:array forKey:@"HisAry"];
        [_historyData removeAllObjects];
        _historyData = [NSMutableArray arrayWithArray:HisAry];
        float size = self.historyData.count * 40;
        float heigh = size < KScreenHeight -285 ? size : KScreenHeight -285;
        self.toBottomHeight.constant = KScreenHeight -heigh -245;
        [self.tableView reloadData];
    }
}

//返回上一级
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.searchShowView = [SearchProductView initCustomView];
    self.searchShowView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64);
    self.searchShowView.vc = self;
    [self.searchShowView reloadData];
    [self.searchShowView isHidden:YES];
    [self.view addSubview:self.searchShowView];
    
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
