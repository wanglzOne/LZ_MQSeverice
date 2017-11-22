//
//  OrderEvaluationViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderEvaluationViewController.h"

#import "OrderEvaluationTableViewCell.h"

#import "CustomStarView.h"



@interface OrderEvaluationViewController ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,OrderEvaluationViewCellDelegate>



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *haedView;

@property (strong, nonatomic) NSMutableArray *dataArray;;
@property (strong, nonatomic) NSMutableArray *sectionContentArray;


@property (weak, nonatomic) IBOutlet UIView *distributionStartView;
@property (weak, nonatomic) IBOutlet UIView *goodsStarViwe;

@property (strong, nonatomic) CustomStarView *distributionStar;
@property (strong, nonatomic) CustomStarView *goodsStar;

@end

@implementation OrderEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"用户评价";
    
    self.haedView.backgroundColor = HWColor(249, 259, 252);
    [self.cusNavView createRightButtonWithTitle:nil image:[UIImage imageNamed:@"phone"] target:self action:@selector(texPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    self.sectionContentArray = [[NSMutableArray alloc] initWithObjects:@"菜品评价",@"",@"", nil];
    self.dataArray = [[NSMutableArray alloc] init];
    for (OrderMessageProductInfo *info in self.orderInfo.orderProducts) {
        if (info.productInfo && info.productInfo.productId) {
            [self.dataArray addObject:info];
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderEvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:@"EvaluationCell"];
    //填写 数据 修改model 中的数据
    

    
}
- (void)texPhoneNumber
{
    [UIAlertController showInViewController:self withTitle:@"提示" message:KProductPhoneNumber preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"呼叫"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",KProductPhoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.distributionStar = [CustomStarView customStarView];
    [self.distributionStartView addSubview:self.distributionStar];
    
    self.goodsStar = [CustomStarView customStarView];
    [self.goodsStarViwe addSubview:self.goodsStar];
    self.distributionStar.frame = CGRectMake(0, 0, 194.0, 38);
    self.goodsStar.frame = CGRectMake(0, 0, 194.0, 38);
}

- (IBAction)commitAction:(id)sender {
    
    if (!self.distributionStar.starIndex || !self.goodsStar.starIndex) {
        [self.view showPopupErrorMessage:@"请给一个评价吧"];
        return;
    }
    [self.view endEditing:YES];
    
    int evaS = self.goodsStar.starIndex;
    
    NSMutableArray *maps = [[NSMutableArray alloc] init];
    for (OrderMessageProductInfo *proInfo in self.orderInfo.orderProducts) {
        if (proInfo.productInfo.evaScore>0) {
            evaS = proInfo.productInfo.evaScore;
        }
        NSString *content = proInfo.productInfo.evaContent.length ? proInfo.productInfo.evaContent : @"";
        if (proInfo.productInfo.evaContent.length || proInfo.productInfo.evaScore>0) {
            [maps addObject:@{@"evaContent" : content, @"evaScore" : @(evaS),@"evaProductId" : proInfo.productId}];
        }
    }
    
    //,
    //productEvaluations
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"submitEva" url_ex] params:
     @{@"orderId" : self.orderInfo.orderId,
       @"employeeScore" : @(self.distributionStar.starIndex),
       @"orderScore" : @(self.goodsStar.starIndex),
       @"list" : [maps yy_modelToJSONString]} onCommonBlockCompletion:^(id responseObject, NSError *error) {
           if (error) {
               [self.view showPopupErrorMessage:error.domain];
               return ;
           }
           [[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"恭喜评价成功，感谢您的使用"];
           [self.navigationController popViewControllerAnimated:YES];
     }];
    
}






#pragma mark ---------UITableViewDelegateDataSource-----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionContentArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *name = self.sectionContentArray[section];
    if (name.length) {
        return KHEIGHT_6(40.0);
    }
    return KHEIGHT_6(12.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHEIGHT_6(230.0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //model
    OrderMessageProductInfo *info = self.dataArray[indexPath.section];
    ////evaContent   evaScore"
    
    OrderEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluationCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.label_name.text = info.productInfo.productName;
    cell.starIndex  = info.productInfo.evaScore;
    cell.textView.text = info.productInfo.evaContent;
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.section+1;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




- (void)tableViewCell:(UITableViewCell *)cell clickButttonWithStarIndex:(int)starIndex
{
    //OrderEvaluationTableViewCell *ecell = (OrderEvaluationTableViewCell *)cell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderMessageProductInfo *info = self.dataArray[indexPath.section];
    info.productInfo.evaScore = starIndex;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSInteger section = textView.tag-1;
    OrderMessageProductInfo *info = self.dataArray[section];
    if (!info.productInfo.evaScore && textView.text.length) {
        [[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"请给一个评分吧"];
        return YES;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSInteger section = textView.tag-1;
    OrderMessageProductInfo *info = self.dataArray[section];
    info.productInfo.evaContent = textView.text;
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
