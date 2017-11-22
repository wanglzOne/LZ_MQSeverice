//
//  CellDetailsCollectionViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "CellDetailsCollectionViewCell.h"
#import "EvalutionModel.h"

#import "CommentTableViewCell.h"
#import "CommentModel.h"

@interface CellDetailsCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isRefresh;
    PackagMet *packagMet;
}
@property (nonatomic ,strong)NSMutableArray *dataSource;
@property (nonatomic ,strong)NSMutableArray *contentAry;
@property (nonatomic ,strong) PageHelper *helper;

@property (nonatomic ,strong)NSString *productId;

@end

@implementation CellDetailsCollectionViewCell



-(void)setModel:(ProductModel *)model
{
    _model = model;
    
    //商品图片
//    for (ProductImageInfo *imgInfo in model.productImage) {
//        if (imgInfo.is_cover == 0) {
//            
//             [self.productImage sd_setImageWithURL:[NSURL URLWithString:[(imgInfo.image_url?imgInfo.image_url:@"") imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
//            break;
//        }
//    }
    
    
    self.addCount.text = [NSString stringWithFormat:@"%d",model.shopCount];
    //商品名称
    self.productName.text = model.productName;
    //商品价格
    if (model.isActivity) {
        self.price.text = MoneySymbol(model.activityPrice);
    }
    else{
        self.price.text = MoneySymbol(model.price);
    }
    //商品详情
    NSString *desc = model.productDesc;
    if (desc == nil) {
        self.productInfo.text = @"暂无相关信息";
    }
    else{
        self.productInfo.text = [NSString stringWithFormat:@"%@",model.productDesc];
    }
    
//    self.tagLabel.text = model.showSaleand;//口味   酸辣   月售 518
    NSString*str  = [[NSString alloc]init];
    for (lableKvModel *m in model.lableKvs) {
        NSDictionary *dic = [m yy_modelToJSONObject];
        str = [str stringByAppendingString:dic[@"value"]];
    }
    NSString *text = @"";
    if([str isEqualToString:@""]){
        text = @"";
    }else{
        text = [NSString stringWithFormat:@"口感 %@  ",str];
    }
    text = [NSString stringWithFormat:@"%@销量 %ld",text,model.saleCount];
    self.tagLabel.text = text;
    
    int count;
    count = [self.addCount.text intValue];
    if (count == 0) {
        self.addShoppingBtn.hidden = NO;
        self.footView.hidden = YES;
    }
    else{
        self.addShoppingBtn.hidden = YES;
        self.footView.hidden = NO;
    }
    if (self.isStart == NO) {
        
        self.footView.hidden = YES;
        self.addShoppingBtn.enabled = NO;
        [self.addShoppingBtn setTitle:@"即将开始" forState:UIControlStateNormal];
        self.addShoppingBtn.backgroundColor = [UIColor whiteColor];
        self.addShoppingBtn.layer.cornerRadius = 11;
        self.addShoppingBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.addShoppingBtn.layer.borderWidth=0.4;
    }
    self.productId = model.productId;
    [self initData];
    [self initInterFace];
    [self loadNormalStateData];
    
}
-(void)setEvaModel:(EvalutionModel *)evaModel
{
    int num = [evaModel.evaCount intValue];
    
    if (num == 0) {
        NSString *numStr = [NSString stringWithFormat:@"暂无任何评论>"];
        [self.numberValuation setTitle:numStr forState:UIControlStateNormal];
    }else{
        NSString *numStr = [NSString stringWithFormat:@"%d条评论>",num];
        [self.numberValuation setTitle:numStr forState:UIControlStateNormal];
    }
    double valu = [evaModel.goodEva doubleValue];
    NSString * valuStr = [NSString stringWithFormat:@"%.3f",valu];
    int d = [valuStr doubleValue]  *1000 ;
    if (d % 100 < 5) {
        int va = d / 10;
        self.valuation.text = [NSString stringWithFormat:@"%d%%",va];
    }else{
        int va = d / 10 + 1;
        self.valuation.text = [NSString stringWithFormat:@"%d%%",va];
    }
    self.valutionProgress.progress = valu;
}
- (IBAction)InfoAction:(UIButton *)sender {
    self.InfoView.hidden = NO;
    self.EvaView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        _movieView.frame = CGRectMake(0, 48, KScreenWidth/2, 2);
        
    }];
}

- (IBAction)EvaButtonAction:(UIButton *)sender {
    [self loadNormalStateData];
    self.InfoView.hidden = YES;
    self.EvaView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _movieView.frame = CGRectMake(KScreenWidth/2, 48, KScreenWidth/2, 2);
        
    }];
    
}

-(void)initData{
    if (!self.dataSource) {
        self.dataSource = [[NSMutableArray alloc]init];
    }
    if (!self.contentAry) {
        self.contentAry = [[NSMutableArray alloc]init];
    }
    if (!self.helper) {
        self.helper = [[PageHelper alloc]init];
        isRefresh = NO;
    }
}
- (void)loadNormalStateData
{
    WEAK(weakSelf);
    if (!self.EvaTableView.mj_footer) {
        self.EvaTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefresh];
        }];
    }
    if (!self.EvaTableView.mj_header) {
        self.EvaTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
    
    [self.EvaTableView.mj_header beginRefreshing];
}
//下拉刷新
- (void)headerRefresh
{
    
    isRefresh = YES;
    self.helper = [[PageHelper alloc]init];
    [self.EvaTableView.mj_footer setHidden:NO];
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
    [self.EvaTableView.mj_header endRefreshing];
    [self.EvaTableView.mj_footer endRefreshing];
}

-(void)initCommentInfoNetWorking:(NSString *)productId
{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:self.helper.params];
    [params setObject:@{@"evaProductId":productId} forKey:@"params"];
    
    AFBaseNetWork *new = [[AFBaseNetWork alloc]init];
    [new post:[@"queryByPId" url_ex] params:params progress:nil responseObject:^(id responseObject) {
        [self endRefreshing];
        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
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
            
            [self.EvaTableView reloadData];
            
            if (self.dataSource.count < self.helper.total) {
                [self.EvaTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        else{
            
//            self.dataSource = [[NSMutableArray alloc]init];
        }
        isRefresh = NO;
    } onError:^(NSError *error) {
        
        [self endRefreshing];
        [self.helper falseAdd];
    }];
}
-(void)initInterFace{
    
//    self.EvaTableView.delegate = self;
//    self.EvaTableView.dataSource = self;

}

#pragma mark ---------UITableViewDelegateDataSource--------
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [CommentTableViewCell creatCell:tableView];
    if(self.dataSource.count){
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
    }else{
        return nil;
    }
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




- (void)awakeFromNib {
    [super awakeFromNib];
    

    
}


@end
