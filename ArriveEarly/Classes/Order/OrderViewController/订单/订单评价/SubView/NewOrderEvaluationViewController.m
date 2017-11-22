//
//  NewOrderEvaluationViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "NewOrderEvaluationViewController.h"
#import "EvaluateChooseTableViewCell.h"
#import "EvaluateStartChooseTableViewCell.h"
#import "EvaluateTextViewTableViewCell.h"
#import "EvaluateImageViewTableViewCell.h"
#import "NormalChooseTableViewCell.h"

#import "OrderEvaluationTableViewCell.h"

@interface NewOrderEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource, UITextViewDelegate,PicturesChooseViewDelegate,OrderEvaluationViewCellDelegate>
{
    NSArray *showSectionArray;
    CGFloat pickHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <OrderMessageProductInfo*>*dataArray;;
@property (strong, nonatomic) NSArray *sectionContentArray;





@property (strong, nonatomic) NSMutableArray <NSDictionary *>*commitProductStarts;
//配送速度  服务态度
@property (assign, nonatomic) int evaScore_deliverSpeed;
//服务态度
@property (assign, nonatomic) int evaScore_serviceAttitude;
@property (strong, nonatomic) NSString *eva_Content;
@property (strong, nonatomic) NSMutableArray <UIImage *>*commitPicImageArray;
@property (strong, nonatomic) NSMutableArray <NSString *>*commitPicImageUrls;
@property (assign, nonatomic) BOOL isAnonymous;




@end

@implementation NewOrderEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"评价晒单";
    self.cusNavView.titleLabel.textColor = UIColorFromRGBA(0x333333, 1);
    [self.cusNavView createRightButtonWithTitle:nil image:[UIImage imageNamed:@"phone"] target:self action:@selector(texPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    self.eva_Content = @"";
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluateTextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"EvaluateTextViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NormalChooseTableViewCell" bundle:nil] forCellReuseIdentifier:@"NormalChooseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderEvaluationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Evaluationell"];

    
    //,@"一句话评价"
    self.sectionContentArray = [[NSArray alloc] initWithObjects:@"菜品评价",@"配送服务质量评价",@"拍照",@"是否匿名评价", nil];
    showSectionArray = @[@"菜品评价",@"配送服务质量评价"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    self.commitProductStarts = [[NSMutableArray alloc] init];
    for (OrderMessageProductInfo *info in self.orderInfo.orderProducts) {
        if (info.productInfo && info.productInfo.productId) {
            [arr addObject:info];
            [self.commitProductStarts addObject:[@{@"evaContent" : @"", @"evaScore" : @(0),@"evaProductId" : info.productInfo.productId} mutableCopy]];
        }
    }
    self.dataArray = arr;
    pickHeight = 95.5;
    self.commitPicImageUrls = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.isAnonymous = YES;
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

- (IBAction)commitAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    
    if (!self.evaScore_deliverSpeed || !self.evaScore_serviceAttitude) {
        [self.view showPopupErrorMessage:@"请给一个评价吧"];
        return;
    }
    /*
    for (NSDictionary *dict in self.commitProductStarts) {
        if ([dict[@"evaScore"] intValue] <= 0) {
            [self.view showPopupErrorMessage:@"请给一个评价吧"];
            return;
        }
    }
     */
    NSMutableString *urls = [[NSMutableString alloc] init];
    for (NSString *imgUrl in self.commitPicImageUrls) {
        if (imgUrl.length) {
            [urls appendFormat:@"%@#",imgUrl];
        }
    }
    
    int evaS = 5;
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
    
    //  [self.commitProductStarts yy_modelToJSONString]  老的    [maps yy_modelToJSONString]
    [self.view showPopupLoading];
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"submitEva" url_ex] params:
     @{@"orderId" : self.orderInfo.orderId,
       @"employeeScore" : @(self.evaScore_serviceAttitude),
       @"orderScore" : @(self.evaScore_deliverSpeed),
       @"list" : [maps yy_modelToJSONString],
       @"isAnonymous" : [NSNumber numberWithBool:self.isAnonymous],
       @"orderEvaContent" : self.eva_Content,
       @"urls" : urls,
       @"token":[ArriveEarlyManager shared].userLogData.userToken} onCommonBlockCompletion:^(id responseObject, NSError *error) {
           [self.view hidePopupLoading];
           if (error) {
               [self.view showPopupErrorMessage:error.domain];
               return ;
           }
           [[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"恭喜评价成功，感谢您的使用"];
           [self.navigationController popViewControllerAnimated:YES];
       }];
    

}


#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionContentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *title = self.sectionContentArray[section];
    if ([title isEqualToString:@"菜品评价"]) {
        return self.dataArray.count;
    }else if ([title isEqualToString:@"配送服务质量评价"]) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = self.sectionContentArray[section];
    if ([showSectionArray containsObject:title]) {
        return title;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *title = self.sectionContentArray[section];
    if ([showSectionArray containsObject:title]) {
        return 30.0;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.sectionContentArray[indexPath.section];
    if ([title isEqualToString:@"菜品评价"]) {
        return KHEIGHT_6(200.0);
    }
    if ([title isEqualToString:@"配送服务质量评价"]) {
        return 50.0;
    }
    if ([title isEqualToString:@"一句话评价"]) {
        return 120.0;
    }
    if ([title isEqualToString:@"拍照"]) {
        return pickHeight;
    }
    if ([title isEqualToString:@"是否匿名评价"]) {
        return 44.0;
    }
    return 44.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //model
    NSString *title = self.sectionContentArray[indexPath.section];
    if ([title isEqualToString:@"菜品评价"]) {
        return [self tableView:tableView orderEvaluationTableViewCellForRowAtIndexPath:indexPath];
        
        return [self tableView:tableView evaluateStartChooseTableViewCellForRowAtIndexPath:indexPath];
    }else if ([title isEqualToString:@"配送服务质量评价"])
    {
        return [self tableView:tableView evaluateChooseTableViewCellForRowAtIndexPath:indexPath];
    }
    else if ([title isEqualToString:@"一句话评价"])
    {
        return [self tableView:tableView evaluateTextViewTableViewCellForRowAtIndexPath:indexPath];
    }
    else if ([title isEqualToString:@"拍照"])
    {
        return [self tableView:tableView evaluateImageTableViewCellForRowAtIndexPath:indexPath];
    }
    else if ([title isEqualToString:@"是否匿名评价"])
    {
        return [self tableView:tableView normalChooseTableViewCellForRowAtIndexPath:indexPath];
    }
    EvaluateChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateChoosex"];
    if (!cell) {
        cell = [[EvaluateChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EvaluateChooses"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}










#pragma mark -
-(EvaluateStartChooseTableViewCell *)tableView:(UITableView *)tableView evaluateStartChooseTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMessageProductInfo *info = self.dataArray[indexPath.row];
    NSDictionary *data = nil;
    for (NSMutableDictionary *dictData in self.commitProductStarts) {
        if (dictData[@"evaProductId"] == info.productInfo.productId) {
            data = dictData;
        }
    }
    EvaluateStartChooseTableViewCell *cell = [EvaluateStartChooseTableViewCell loadCellForTableView:tableView];
    cell.oProductInfo = info;
    cell.star = [data[@"evaScore"] intValue];
    cell.clickStarBlock = ^(id obj){
        if ([obj isKindOfClass:[NSNumber class]]) {
            for (NSMutableDictionary *dict in self.commitProductStarts) {
                if (dict[@"evaProductId"] == info.productInfo.productId) {
                    [dict setObject:obj forKey:@"evaScore"];
                }
            }
        }
    };
    return cell;
}
-(OrderEvaluationTableViewCell *)tableView:(UITableView *)tableView orderEvaluationTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMessageProductInfo *info = self.dataArray[indexPath.row];
    NSDictionary *data = nil;
    for (NSMutableDictionary *dictData in self.commitProductStarts) {
        if (dictData[@"evaProductId"] == info.productInfo.productId) {
            data = dictData;
        }
    }
    OrderEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Evaluationell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.label_name.text = info.productInfo.productName;
    cell.starIndex  = info.productInfo.evaScore;
    cell.textView.text = info.productInfo.evaContent;
    cell.textView.delegate = self;
    cell.textView.tag = indexPath.row+1;
    [cell.textView setPlaceholder:@"亲，菜品的口味如何，服务是否周到？"];

    return cell;
}

- (void)tableViewCell:(UITableViewCell *)cell clickButttonWithStarIndex:(int)starIndex
{
    //OrderEvaluationTableViewCell *ecell = (OrderEvaluationTableViewCell *)cell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OrderMessageProductInfo *info = self.dataArray[indexPath.row];
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

#pragma mark -
-(EvaluateChooseTableViewCell *)tableView:(UITableView *)tableView evaluateChooseTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateChooseTableViewCell *cell = [EvaluateChooseTableViewCell loadCellForTableView:tableView];
    if (indexPath.row == 0) {
        cell.titleCus = @"送餐速度";
        cell.star = _evaScore_deliverSpeed;
    }else
    {
        cell.titleCus = @"服务态度";
        cell.star = _evaScore_serviceAttitude;
    }
    cell.clickStarBlock = ^(id obj){
        if ([obj isKindOfClass:[NSNumber class]]) {
            if (indexPath.row == 0) {
                _evaScore_deliverSpeed = [obj intValue];
            }else
            {
                _evaScore_serviceAttitude = [obj intValue];
            }
        }
    };
    return cell;
}
#pragma mark -
-(EvaluateTextViewTableViewCell *)tableView:(UITableView *)tableView evaluateTextViewTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateTextViewCell" forIndexPath:indexPath];
    [cell.textView setPlaceholder:@"请输入评价"];
    cell.textView.text = self.eva_Content;
    cell.textView.delegate = self;
    return cell;
}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    self.eva_Content = textView.text;
//}

#pragma mark - 
-(EvaluateImageViewTableViewCell *)tableView:(UITableView *)tableView evaluateImageTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateImageViewTableViewCell *cell = [EvaluateImageViewTableViewCell loadCellForTableView:tableView];
    cell.picView.superVC  = self;
    cell.picView.delegate = self;
    [cell.picView setImageDatas:_commitPicImageArray];
    return cell;
}
- (void)picturesChooseView:(PicturesChooseView *)picturesChooseView uploadUIForPicturesChooseViewHeight:(CGFloat )contentHeight
{
    _commitPicImageArray = picturesChooseView.images;
    pickHeight = contentHeight;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)picturesChooseView:(PicturesChooseView *)picturesChooseView uploadImage:(UIImage *)image forIndex:(NSInteger)index
{
    [self uploadImage:image forIndex:index];
}
- (void)uploadImage:(UIImage *)image forIndex:(NSInteger)index
{
    [self.view showPopupLoading];
    [EncapsulationAFBaseNet uploadImages:@[image] onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self.view hidePopupLoading];
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        NSDictionary *response = responseObject;
        NSString * imgurl = response[@"data"];
        if (![imgurl isKindOfClass:[NSString class]]) {
            [self.view showPopupErrorMessage:@"上传图片发生错误"];
            return ;
        }
        [self.commitPicImageUrls replaceObjectAtIndex:index withObject:imgurl];
        
    }];
}
#pragma mark -
-(NormalChooseTableViewCell *)tableView:(UITableView *)tableView normalChooseTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NormalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalChooseCell" forIndexPath:indexPath];
    [cell.chooseEvaButtton addTarget:self action:@selector(chooseEvaButtton:) forControlEvents:UIControlEventTouchUpInside];
    cell.chooseEvaButtton.selected = self.isAnonymous;
    return cell;
}
- (void)chooseEvaButtton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.isAnonymous = btn.selected;
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
