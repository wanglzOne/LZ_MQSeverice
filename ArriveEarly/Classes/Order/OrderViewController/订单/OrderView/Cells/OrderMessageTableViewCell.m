//
//  OrderMessageTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderMessageTableViewCell.h"

@interface OrderDishesView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation OrderDishesView

@end



@interface OrderMessageTableViewCell ()
{
    CGFloat  widthp;
}
@property (nonatomic, strong) UILabel *orderNumber;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *totalMoneyLabel;

@property (nonatomic, strong) OrderDishesView *totalOrderDishesView;

@property (nonatomic, strong) NSArray <OrderDishesView *> *orderDishesViews;


@end

@implementation OrderMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModelData:(OrderMessageModelInfo *)orderMessageInfo
{
    
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //self.accessoryType = UITableViewCellAccessoryDetailButton;
        
        
        self.orderInfo = orderMessageInfo;
        widthp = 0.0;
        // 100.0 + 30 ;
        // + (8+15)*info.ord  +2
        CGFloat space = 15.0;
        CGFloat height = KHEIGHT_6(50.0);
        UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 65, height)];
        number.textAlignment = NSTextAlignmentLeft;
        number.font = [UIFont systemFontOfSize:14.0];
        number.text = @"订单编号";
        number.textColor = UIColorFromRGBA(0x333333, 1);
        [self.contentView addSubview:number];
        
        
        
        //((float)((rgbValue & 0x00FF00) >> 8));
        
        // stateLabel.text = @"配送中";
        self.stateLabel =  [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - space - 80, 0, 80, height)];
        self.stateLabel.textAlignment = NSTextAlignmentRight;
        self.stateLabel.adjustsFontSizeToFitWidth = YES;
        //self.stateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.stateLabel.font = [UIFont systemFontOfSize:14.0];
        self.stateLabel.textColor = UIColorFromRGBA(0xfb3c30, 1);
        [self addSubview:self.stateLabel];
        //订单编号
        self.orderNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(number.frame) + 5, 0, CGRectGetMinX(self.stateLabel.frame) - 5 - (CGRectGetMaxX(number.frame) + 5), height)];
        self.orderNumber.textAlignment = NSTextAlignmentLeft;
        self.orderNumber.font = [UIFont systemFontOfSize:14.0];
        self.orderNumber.textColor = UIColorFromRGBA(0x333333, 1);
        [self.contentView addSubview:self.orderNumber];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(number.frame)+0.1, KScreenWidth - space*2, 1)];
        line1.backgroundColor = UIColorFromRGBA(0xe6e6e6, 1);
        [self addSubview:line1];
        
        
        
        
        UIView *laseView = nil;
        NSMutableArray <OrderDishesView*>*ddd = [[NSMutableArray alloc] init];
        
        
        // orderMessageInfo.orderProducts.count + 1;  (i == orderMessageInfo.orderProducts.count)
        for (int i = 0; i < orderMessageInfo.orderProducts.count + 1; i ++) {
            OrderDishesView *view = [[OrderDishesView alloc] initWithFrame:CGRectMake(space, i*8 + (i+1)*space + CGRectGetMaxY(line1.frame), KScreenWidth - 2*space, space)];
            if (i == orderMessageInfo.orderProducts.count) {
                //self.totalOrderDishesView = view;
//                view.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, space)];
                view.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, space)];
                
                
                
                view.numberLabel.textAlignment = NSTextAlignmentRight;
                view.numberLabel.font = [UIFont systemFontOfSize:13.0];
                view.numberLabel.textColor = UIColorFromRGBA(0x666666, 1);
                //[view addSubview:view.numberLabel];
                
                [self addSubview:view.numberLabel];

                
                [self.contentView addSubview:view];
                [ddd addObject:view];
            }else
            {
                view.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width - 95, space)];
                view.titleLabel.textAlignment = NSTextAlignmentLeft;
                view.titleLabel.font = [UIFont systemFontOfSize:13.0];
                view.titleLabel.textColor = UIColorFromRGBA(0x666666, 1);
                [view addSubview:view.titleLabel];
                
//                view.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 95, 0, 95, space)];
                
                view.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 95 + view.frame.origin.x, view.frame.origin.y, 95, space)];
                
                view.numberLabel.textAlignment = NSTextAlignmentRight;
                view.numberLabel.font = [UIFont systemFontOfSize:13.0];
                view.numberLabel.textColor =UIColorFromRGBA(0x666666, 1);
                //[view addSubview:view.numberLabel];
                
                [self addSubview:view.numberLabel];
                
                
                [ddd addObject:view];
            }
            
            [self.contentView addSubview:view];
            laseView = view;
        }
        self.orderDishesViews = ddd;
        
        //总计多少
//        self.totalOrderDishesView = [[OrderDishesView alloc] initWithFrame:CGRectMake(space, orderMessageInfo.orderProducts.count*8 + (orderMessageInfo.orderProducts.count+1)*space + CGRectGetMaxY(line1.frame), KScreenWidth - 2*space, space)];
//        self.totalOrderDishesView.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.totalOrderDishesView.frame.size.width, self.totalOrderDishesView.frame.size.width, space)];
//        self.totalOrderDishesView.numberLabel.textAlignment = NSTextAlignmentRight;
//        self.totalOrderDishesView.numberLabel.font = [UIFont systemFontOfSize:15.0];
//        self.totalOrderDishesView.numberLabel.textColor = HWColor(150, 150, 150);
//        [self.totalOrderDishesView addSubview:self.totalOrderDishesView.numberLabel];
//        [self.contentView addSubview:self.totalOrderDishesView];
//        laseView = self.totalOrderDishesView;
        
        //食物
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(laseView.frame) + space, KScreenWidth, 1)];
        line2.backgroundColor = UIColorFromRGBA(0xe6e6e6, 1);
        [self addSubview:line2];
        //[self.contentView addSubview:line2];
//        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(CGRectGetMaxY(laseView.frame)));
//            make.left.equalTo(@(0));
//            make.height.equalTo(@(1));
//            make.right.equalTo(self.contentView);
////            make.width.equalTo(@(KScreenWidth));
//        }];
        
        
        self.totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, CGRectGetMaxY(line2.frame), 200, height)];
        self.totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
        self.totalMoneyLabel.font = [UIFont systemFontOfSize:14.0];
        self.totalMoneyLabel.textColor = UIColorFromRGBA(0x333333, 1);
        [self addSubview:self.totalMoneyLabel];
        
        CGFloat btnHeight = KHEIGHT_6(23.0);
        
        self.typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.typeButton.frame = CGRectMake(KScreenWidth - 15 - 95, CGRectGetMaxY(line2.frame) + btnHeight/2 , 95, height - btnHeight);
        [self.typeButton setTitleColor:UIColorFromRGBA(0x333333, 1) forState:UIControlStateNormal];
        [self.typeButton setBackgroundColor:UIColorFromRGBA(0xf0f0f0, 1) forState:UIControlStateNormal];
        self.typeButton.layer.cornerRadius = CGRectGetHeight(self.typeButton.frame) / 2;
        self.typeButton.layer.borderColor = UIColorFromRGBA(0xd8dadd, 1).CGColor;
        self.typeButton.layer.borderWidth = 1.0;
        self.typeButton.clipsToBounds = YES;
        self.typeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        
        
        [self addSubview:self.typeButton];
        
        self.evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.evaluationBtn.frame = CGRectMake(KScreenWidth - 15 - 95 - 70 - 10, CGRectGetMaxY(line2.frame) + btnHeight/2 , 70, height - btnHeight);
        [self.evaluationBtn setTitleColor:UIColorFromRGBA(0x333333, 1) forState:UIControlStateNormal];
        [self.evaluationBtn setBackgroundColor:HWColor(250, 250, 250) forState:UIControlStateNormal];
        self.evaluationBtn.layer.cornerRadius = CGRectGetHeight(self.evaluationBtn.frame) / 2;
        self.evaluationBtn.layer.borderColor = HWColor(150, 150, 150).CGColor;
        self.evaluationBtn.layer.borderWidth = 1.0;
        self.evaluationBtn.clipsToBounds = YES;
        self.evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.evaluationBtn];
    }
    return self;
}

- (void)setOrderInfo:(OrderMessageModelInfo *)orderInfo
{
    _orderInfo = orderInfo;
    _evaluationBtn.hidden = YES;
    _orderNumber.text = orderInfo.booksInfo.orderId;
    _stateLabel.text = orderInfo.booksInfo.orderStatus_str;//orderInfo.orderStatus_str
    _totalMoneyLabel.text = @"";//[NSString stringWithFormat:@"￥%.2f",orderInfo.booksInfo.orderPrice];
    //去支付   去评价   差看详情
    if (orderInfo.booksInfo.orderStatus == OrderStatus_waitePay) {
        [_typeButton setTitle:@"去支付" forState:UIControlStateNormal];
    }
    else if (orderInfo.booksInfo.orderStatus == OrderStatus_finish && orderInfo.booksInfo.isEva<=0)
    {
        //显示两个按钮 @"再来一单"
        _evaluationBtn.hidden = NO;
        [_evaluationBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [_typeButton setTitle:@"再来一单" forState:UIControlStateNormal];
        [_evaluationBtn addTarget:self action:@selector(_evaluationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (orderInfo.booksInfo.orderStatus == OrderStatus_finish && orderInfo.booksInfo.isEva > 0)
    {
        [_typeButton setTitle:@"再来一单" forState:UIControlStateNormal];
    }
    else if (orderInfo.booksInfo.orderStatus == OrderStatus_areadlyFinish)
    {
        [_typeButton setTitle:@"再来一单" forState:UIControlStateNormal];
    }else if(orderInfo.booksInfo.orderStatus == OrderStatus_distributing)
    {
        self.evaluationBtn.hidden =NO;
        [_evaluationBtn setTitle:@"催单" forState:UIControlStateNormal];
        self.evaluationBtn.tag = 2;
        [_evaluationBtn addTarget:self action:@selector(_evaluationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_typeButton setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    else if(orderInfo.booksInfo.orderStatus == OrderStatus_waiteMake)
    {
        self.evaluationBtn.hidden =NO;
         [_evaluationBtn setTitle:@"退款" forState:UIControlStateNormal];
        self.evaluationBtn.tag = 1;
        [_evaluationBtn addTarget:self action:@selector(_evaluationBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_typeButton setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    else
    {
        [_typeButton setTitle:@"查看详情" forState:UIControlStateNormal];
    }
    
    
    [_typeButton addTarget:self action:@selector(_typeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    for (int i= 0; i <orderInfo.orderProducts.count ; i ++ ) {
        OrderMessageProductInfo *model = orderInfo.orderProducts[i];
        OrderDishesView *view = self.orderDishesViews[i];
        view.titleLabel.text = model.productInfo.productName;
        view.numberLabel.text = [NSString stringWithFormat:@"X%d",model.productCnt];
    }
    
    if (self.orderDishesViews.count - orderInfo.orderProducts.count == 1) {
        NSString *price = Money(orderInfo.booksInfo.orderPrice);
        NSString *content = [NSString stringWithFormat:@"共%lu件商品，实付%@",(unsigned long)orderInfo.orderProducts.count,price];
        NSMutableAttributedString* noteStr = [[NSMutableAttributedString alloc] initWithString:content];
        NSInteger location = [[noteStr string] rangeOfString:price].location;
        NSRange redRange = NSMakeRange(location, price.length);
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:redRange];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
        OrderDishesView *totalOrderDishesView = [self.orderDishesViews lastObject];
        totalOrderDishesView.numberLabel.attributedText = noteStr;
    }
}

- (void)_evaluationBtnClick
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:clickTypeButton:)]) {
        [_delegate tableViewCell:self clickTypeButton:self.evaluationBtn];
    }
}
- (void)_typeButtonClick
{
    if ([_delegate respondsToSelector:@selector(tableViewCell:clickTypeButton:)]) {
        [_delegate tableViewCell:self clickTypeButton:self.typeButton];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    
}

@end
