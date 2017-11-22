//
//  OrderMessageModelInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReducePreferentialInfo.h"
#import "GevePreferentialInfo.h"
#import "ProductModel.h"
#import "RedPacketsInfo.h"
#import "AddPricetoBuyInfo.h"

typedef NS_ENUM(NSInteger, PaymentMenu) {
    PaymentMenu_Online = 1, // 微信、支付宝支付
    PaymentMenu_waiteGoods = 2, // 货到付款
};

//orderStatus 1:{name:'等待制作'},2:{name:'正在制作'},3:{name:'正在配送'},4:{name:'已送达'},5:{name:'正在取消'},6:{name:'已取消'}
typedef NS_ENUM(NSInteger, OrderStatus) {
    OrderStatus_waitePay = 0, // 等待支付
    OrderStatus_waiteMake = 1, // 等待制作
    OrderStatus_makeing = 2,   //正在制作
    OrderStatus_distributing = 3,  //正在配送
    
    OrderStatus_finish = 4,   //已送达
    OrderStatus_canceling = 5,   //正在取消
    OrderStatus_canceled = 6,   //已取消
    OrderStatus_abnormal = 7,   //订单异常
    
    
    OrderStatus_payTimeOut = 8,   //订单 支付已超时
    
    OrderStatus_areadlyFinish = 9,   //订单 支付已超时
    
    OrderStatus_evaluated = 99,   //订单   已评价
};

//id   name   评价星际   desc 描述  点单的份数  库存  价格

@interface OrderMessageProductInfo : NSObject
@property (nonatomic, copy) NSString *orderID;

///0：正常价格   1：活动价  2：加价购 ProductType
@property (nonatomic, assign) NSInteger orderProductType;
///加价购配置   只有在 orderProductType==2 才有用
@property (nonatomic, strong) AddPricetoBuyInfo *moreConfigEntity;
///购买了 多少份
@property (nonatomic, assign) int productCnt;
@property (nonatomic, assign) double productPrice;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productId;

@property (nonatomic, strong) ProductModel *productInfo;

@end

@interface OrderMessageBooksfo : NSObject
//id 订单id  订单唯一标识
@property (nonatomic, copy) NSString *orderID;
//orderId 用来展示的订单编号
@property (nonatomic, copy) NSString *orderId;
///备注
@property (nonatomic, copy) NSString *remark;
///用餐人数
@property (nonatomic, assign) int meals;
///订单是否已经评价
@property (nonatomic, assign) int isEva;


@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, assign) long long finishTime;
///订单门店ID
@property (nonatomic, copy) NSString *orderAreaId;
@property (nonatomic, copy) NSString *expressId;//配送员电话

///订单价格 以元为单位 两位小数
@property (nonatomic, assign) CGFloat orderPrice;
@property (nonatomic, copy) NSString *addressId;
/// 订单状态  {0:待支付 1:{name:'等待制作'},2:{name:'正在制作'},3:{name:'正在配送'},4:{name:'已送达'},5:{name:'正在取消'},6:{name:'已取消'}};
@property (nonatomic, assign) int orderStatus;
@property (nonatomic, copy) NSString * orderStatus_str;
@property (nonatomic, assign) BOOL isAllowDelete;


@property (nonatomic, assign) long long orderTime;
@property (nonatomic, assign) NSInteger orderType;
@property (nonatomic, assign) NSInteger paymentMethod;
///配送费
@property (nonatomic, assign) CGFloat postagePrice;
///餐盒费
@property (nonatomic, assign) CGFloat meelFee;
///优惠价格
@property (nonatomic, assign) CGFloat preferentialPrice;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *whenGiveId;
@property (nonatomic, copy) NSString *whenId;


@end

@interface RedBagRestEntity : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *rbId;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *isused;
@property (nonatomic, copy) NSString *rbConfigId;
//@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) RedPacketsInfo *rbConfig;
@end


@protocol RedPacketsInfo;

@protocol OrderMessageProductInfo;



@interface OrderMessageModelInfo : NSObject

+ (instancetype)special_yy_modelWithDictionary:(NSDictionary *)dict;


/////自定义数据 以元为单位      计算出 正常商品价格  没有参加活动的价格。
@property (nonatomic, assign) CGFloat orderNormalPrice;
///请求数据的id  不是用来展示的订单编号
@property (nonatomic, copy) NSString *orderId;

//orderWhen
//whenConfigEntity
//orderWhenGive dict
//whenGiveConfig dict
///满减优惠
@property (nonatomic, strong) ReducePreferentialInfo *whenConfigEntity;
///满赠优惠
@property (nonatomic, strong) GevePreferentialInfo *whenGiveConfig;
//orderRedBag
//redBagRestEntity
//应该是红包数组

//红包
//@property (nonatomic, strong) RedBagRestEntity *redBagRestEntity;
///RedBagRestEntity
@property (nonatomic, strong) NSArray <RedBagRestEntity *>*redBagRestEntitys;

///商品数据列表
@property (nonatomic, strong) NSArray <OrderMessageProductInfo> *orderProducts;

///订单信息
@property (nonatomic, strong) OrderMessageBooksfo *booksInfo;



@property (nonatomic, copy) NSString *userId;

@end
