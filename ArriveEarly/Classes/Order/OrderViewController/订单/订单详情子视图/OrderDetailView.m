//
//  OrderDetailView.m
//  早点到APP
//
//  Created by m on 16/9/26.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "OrderDetailView.h"
#import "GoodsTableViewCell.h"
#import <MJRefresh.h>

#import "OrderMsgTableViewCell.h"
#import "OrderAddressMessageTableViewCell.h"

@interface OrderDetailView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@property (nonatomic, strong) Adress_Info *addressInfo;

@property (weak, nonatomic) UIViewController *superViewController;

@property (strong, nonatomic) NSMutableDictionary *dataDict;;
@property (strong, nonatomic) NSMutableArray *sectionContentArray;


@end

@implementation OrderDetailView

+(instancetype)initCustomView
{
     return [[NSBundle mainBundle]loadNibNamed:@"OrderDetailView" owner:self options:nil].lastObject;
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)configWithOrderMessageModelInfo:(OrderMessageModelInfo *)info superVC:(UIViewController*)superVC
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    self.tableView.backgroundColor = Color_Nolmal_BGColor;
    
    self.superViewController = superVC;
    self.orderInfo = info;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderMsgTableViewCell" bundle:nil] forCellReuseIdentifier:@"MsgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderAddressMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressMsgCell"];
    
    //根据地址
    //addressInfo
    [self getAddressInfo];
    
    
    [self loadNormalStateData];
    [self refreshUI];
    [self headerRefresh];
}
- (void)loadNormalStateData
{
    WEAK(weakSelf);
    if (!self.tableView.mj_header) {
        
        self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }
}

- (void)getAddressInfo
{
    if (self.orderInfo.booksInfo.userName && self.orderInfo.booksInfo.userPhone && self.orderInfo.booksInfo.address) {
        self.addressInfo = [[Adress_Info alloc] init];
        self.addressInfo.id_address = self.orderInfo.booksInfo.addressId;
        self.addressInfo.contactName = self.orderInfo.booksInfo.userName;
        self.addressInfo.contactPhone = self.orderInfo.booksInfo.userPhone;
        self.addressInfo.address = self.orderInfo.booksInfo.address;
        return;
    }
    if (!self.orderInfo.booksInfo.addressId) {
        return;
    }

    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findAddress" url_ex] params:@{@"id" : self.orderInfo.booksInfo.addressId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        
        NSDictionary *dict = responseObject;
        NSDictionary *data = dict[@"responseData"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            self.addressInfo = [Adress_Info yy_modelWithDictionary:data];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
}

- (void)refreshUI
{
    //[self.tableView.mj_header beginRefreshing];
    if (self.orderInfo.booksInfo.orderStatus == OrderStatus_waitePay) {
        //@"支付";
        [self.chooseButton setTitle:@"立即支付" forState:UIControlStateNormal];
    }
    else if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish)
    {
        if (self.orderInfo.booksInfo.isEva) {
            [self.chooseButton setTitle:@"再来一单" forState:UIControlStateNormal];
        }else
        {
            [self.chooseButton setTitle:@"去评价" forState:UIControlStateNormal];
        }
    }else
    {
        [self.chooseButton setTitle:@"再来一单" forState:UIControlStateNormal];
    }
}

- (void)headerRefresh
{
    self.dataDict = [[NSMutableDictionary alloc] init];
    self.sectionContentArray = [[NSMutableArray alloc] initWithArray:@[@"菜单",@"订单信息"]];
    //在OrderMessageModelInfo 中 肯定会有一个  数组属性  描述菜品的
    // 菜品model  一个 小的model 对象   有名称   价格 份数  库存多少份
    NSMutableArray *sec0TitleArray = [[NSMutableArray alloc] init];
    for (OrderMessageProductInfo *info in self.orderInfo.orderProducts) {
        [sec0TitleArray addObject:info.productInfo.productName.length ? info.productInfo.productName : @""];
    }
    [sec0TitleArray addObject:@""];
    
    [sec0TitleArray addObject:@"配送费"];
    [sec0TitleArray addObject:@"餐盒费"];
    
    for (RedBagRestEntity *reb in self.orderInfo.redBagRestEntitys) {
        if ([reb.rbConfig.rbName isKindOfClass:[NSString class]]) {
            [sec0TitleArray addObject:reb.rbConfig.rbName];
        }
    }
    
    if (self.orderInfo.whenConfigEntity) {
        [sec0TitleArray addObject:@"满减优惠"];
    }
    if (self.orderInfo.whenGiveConfig) {
        [sec0TitleArray addObject:@"满赠活动"];
    }
    
    NSString *str = [NSString stringWithFormat:@"总计%@ 优惠%@",MoneySymbol(self.orderInfo.booksInfo.orderPrice + self.orderInfo.booksInfo.preferentialPrice), MoneySymbol(self.orderInfo.booksInfo.preferentialPrice)];
    [sec0TitleArray addObject:str];
    
    [self.dataDict setObject:sec0TitleArray forKey:self.sectionContentArray[0]];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:@[@"配送地址",@"订单号",@"下单时间",@"支付方式"]];
    if (self.orderInfo.booksInfo.meals) {
        [arr addObject:@"用餐人数"];
    }
    if ([self.orderInfo.booksInfo.remark isKindOfClass:[NSString class]]) {
        [arr addObject:@"订单备注"];
    }
    if (self.orderInfo.booksInfo.orderStatus == OrderStatus_distributing ) {
        [arr addObject:@"配送电话"];
    }
//    if (self.orderInfo.booksInfo.orderStatus == OrderStatus_finish || self.orderInfo.booksInfo.orderStatus == OrderStatus_distributing || self.orderInfo.booksInfo.orderStatus == OrderStatus_evaluated) {
//        [arr addObject:@"配送员电话"];
//    }

    
    [self.dataDict setObject:arr forKey:self.sectionContentArray[1]];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

- (IBAction)AgainAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(settlementOrderforTargetView:)]) {
        [self.delegate settlementOrderforTargetView:self];
    }
    
}


#pragma mark ---------UITableViewDelegateDataSource-----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataDict.allKeys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataDict[self.sectionContentArray[section]];
    
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.heightForHeaderInSectionOne) {
        return self.heightForHeaderInSectionOne;
    }else
    {
        return KHEIGHT_6(30.0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.dataDict[self.sectionContentArray[indexPath.section]];
    if (indexPath.section == 0) {
        if (indexPath.row == arr.count - 1) {
            return KHEIGHT_6(45.0);//总计
        }
        if ([arr[indexPath.row] isEqualToString:@""]) {
            return KHEIGHT_6(10.0);
        }
        return KHEIGHT_6(30.0);//菜品
    }else
    {
        if (indexPath.row  == 0) {
            return KHEIGHT_6(80.0);//配送地址
        }
        return KHEIGHT_6(45.0);
    }
    //  菜品 30.0  总费用是45.0
    //  两行显示的  是 80.o
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionContentArray[section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = self.dataDict[self.sectionContentArray[indexPath.section]];
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        //菜单 模块
        GoodsTableViewCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
        
        goodsCell.goodsNameLb.text = arr[indexPath.row];
        goodsCell.goodsNameLb.textColor = [UIColor blackColor];
        goodsCell.numberAndPriceLabel.textColor = [UIColor lightGrayColor];
        goodsCell.numberAndPriceLabel.font = [UIFont systemFontOfSize:15.0];
        goodsCell.numberAndPriceLabel.text = @"";
        //(indexPath.row <= arr.count-4)
        goodsCell.logoLabel.hidden = YES;
        [goodsCell.logoLabelLeading setConstant:-1.0];
        //                                                   空白页
        if (indexPath.row <= self.orderInfo.orderProducts.count-1) {
            OrderMessageProductInfo *productInfo = self.orderInfo.orderProducts[indexPath.row];
//            CGFloat price = 0.00;
//            if (productInfo.orderProductType == ProductTypeNormal) {
//                price = productInfo.productInfo.price;
//            }else if (productInfo.orderProductType == ProductTypeActivity || productInfo.orderProductType == ProductTypeAddPriceBuy)
//            {
//                price = productInfo.productInfo.activityPrice;
//            }
            
            
            CGFloat price = productInfo.productInfo.newPrice;
            if (productInfo.orderProductType == ProductTypeAddPriceBuy) {
                price = productInfo.productPrice;
            }
            goodsCell.numberAndPriceLabel.text = [NSString stringWithFormat:@"X%d    %@",productInfo.productCnt,MoneySymbol(price)];
            
        }
        else if ([goodsCell.goodsNameLb.text isEqualToString:@"配送费"])
        {
            goodsCell.numberAndPriceLabel.text = MoneySymbol(self.orderInfo.booksInfo.postagePrice);
        }else if ([goodsCell.goodsNameLb.text isEqualToString:@"餐盒费"])
        {
            goodsCell.numberAndPriceLabel.text =MoneySymbol(self.orderInfo.booksInfo.meelFee);
        }
        
        else if ([goodsCell.goodsNameLb.text isEqualToString:@"满赠活动"])
        {
            goodsCell.logoLabel.hidden = NO;
            goodsCell.logoLabel.text = @"赠";
            [goodsCell.logoLabelLeading setConstant:16.0];
            goodsCell.numberAndPriceLabel.text = self.orderInfo.whenGiveConfig.whenGiveName;
        }
        else if ([goodsCell.goodsNameLb.text isEqualToString:@"满减优惠"])
        {
            goodsCell.logoLabel.text = @"减";
            goodsCell.logoLabel.hidden = NO;
            [goodsCell.logoLabelLeading setConstant:16.0];
            goodsCell.numberAndPriceLabel.text = [NSString stringWithFormat:@"-%@",MoneySymbol(self.orderInfo.whenConfigEntity.whenValue)];
        }
        else if (indexPath.row == arr.count - 1) {
            //总计
            goodsCell.numberAndPriceLabel.textColor = [UIColor redColor];
            NSString *colorStr = MoneySymbol(self.orderInfo.booksInfo.orderPrice);
            NSString *dd = [NSString stringWithFormat:@"实付%@",colorStr];
            goodsCell.numberAndPriceLabel.attributedText = [dd setStrColor:[UIColor redColor] colorStr:colorStr];
            //goodsCell.numberAndPriceLabel.font = [UIFont systemFontOfSize:23.0];
            goodsCell.goodsNameLb.textColor = [UIColor lightGrayColor];
        }
        else if (self.orderInfo.redBagRestEntitys.count && goodsCell.goodsNameLb.text.length)
        {//红包
            //                               配送打包  产品                     空白页
            NSInteger index = indexPath.row - 2 - self.orderInfo.orderProducts.count - 1;
            if (index < self.orderInfo.redBagRestEntitys.count && index >= 0) {
                goodsCell.logoLabel.hidden = NO;
                goodsCell.logoLabel.text = @"红";
                [goodsCell.logoLabelLeading setConstant:16.0];
                RedBagRestEntity *reb = self.orderInfo.redBagRestEntitys[index];
                goodsCell.numberAndPriceLabel.text = [NSString stringWithFormat:@"-%@",MoneySymbol(reb.rbConfig.rbValue)];
            }
        }
        
        
        goodsCell.lineView.hidden = YES;
        //indexPath.row == self.orderInfo.orderProducts.count - 1 ||
        if ([goodsCell.goodsNameLb.text isEqualToString:@"餐盒费"] || indexPath.row == arr.count - 2)
        {
            goodsCell.lineView.hidden = NO;
        }
        cell = goodsCell;
    }
    else
    {
        if (indexPath.row == 0) {
            OrderAddressMessageTableViewCell *addressMsgCell = [tableView dequeueReusableCellWithIdentifier:@"AddressMsgCell" forIndexPath:indexPath];
            addressMsgCell.label_name.text = arr[indexPath.row];
            if (self.addressInfo) {
                if ([self.addressInfo.addressDetail isKindOfClass:[NSString class]]) {
                    addressMsgCell.label_address.text = [NSString stringWithFormat:@"%@ - %@",self.addressInfo.addressDetail,self.addressInfo.address];
                }else
                {
                    addressMsgCell.label_address.text = [NSString stringWithFormat:@"%@",self.addressInfo.address];
                }
                
                addressMsgCell.userInfo.text = [NSString stringWithFormat:@"%@ %@",self.addressInfo.contactName,self.addressInfo.contactPhone];
            }else
            {
                addressMsgCell.userInfo.text = @"加载中...";
                addressMsgCell.label_address.text = @"";
            }
            
            cell = addressMsgCell;
        }else{
            //订单信息模块
            OrderMsgTableViewCell *msgCell = [tableView dequeueReusableCellWithIdentifier:@"MsgCell" forIndexPath:indexPath];
        
            msgCell.label_name.text = arr[indexPath.row];

            if (indexPath.row == 1) {
                msgCell.label_content.text = self.orderInfo.booksInfo.orderId;
            }else if (indexPath.row == 2) {
                msgCell.label_content.text = [NSDate getTimeToLocaDatewith:@"yyyy-MM-dd HH:mm" with:self.orderInfo.booksInfo.orderTime/1000];
            }
            else if (indexPath.row == 3) {
                NSString *paystr = @"支付宝支付";
                if (self.orderInfo.booksInfo.paymentMethod == PayModeIdMenu_WCHAT) {
                    paystr = @"微信支付";
                }else if (self.orderInfo.booksInfo.paymentMethod == PayModeIdMenu_waiteGoods) {
                    paystr = @"货到付款";
                }
                msgCell.label_content.text = paystr;
            }
            
            else if ([msgCell.label_name.text isEqualToString:@"用餐人数"]) {
                msgCell.label_content.text = (self.orderInfo.booksInfo.meals >=10 )? @"10人以上" : [NSString stringWithFormat:@"%d人",self.orderInfo.booksInfo.meals];
            }
            else if ([msgCell.label_name.text isEqualToString:@"订单备注"]) {
                msgCell.label_content.text = self.orderInfo.booksInfo.remark;
            }
            else if ([msgCell.label_name.text isEqualToString:@"配送员电话"]) {
                msgCell.label_content.text = self.orderInfo.booksInfo.expressId;
            }
           

            cell = msgCell;
        }
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
