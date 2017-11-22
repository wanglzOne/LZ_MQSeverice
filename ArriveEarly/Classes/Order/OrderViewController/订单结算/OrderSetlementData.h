//
//  OrderSetlementData.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/2.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderSetlementData : NSObject

/**********  提交数据    **********/
//支付方式
@property (nonatomic, assign) PaymentMenu payment;
//选择的地址
@property (nonatomic, strong) Adress_Info *chooseAddressInfo;
// self.staticTitleDict  中的  key（sectionarray）  对于标题 index。row 取值
//key @"代金券" : RedPacketsInfo
@property (strong, nonatomic) NSMutableDictionary *dataContentDict;
///选择的超值加价购商品 数组  只存超值加价购的商品
@property (strong, nonatomic) NSMutableArray<AddPricetoBuyInfo *> *addCommitPricetoBuyDataArray;
///匹配的满减优惠
@property (strong, nonatomic) ReducePreferentialInfo *reducePreferentialInfo;
//匹配的满赠优惠
@property (strong, nonatomic) GevePreferentialInfo *gevePreferentialInfo;
///匹配的 最优红包
@property (strong, nonatomic) RedPacketsInfo *redPacketsInfo;
///购物车商品记录数组
@property (strong, nonatomic) NSMutableArray<ProductModel *> *addCommitProductModelDataArray;
///添加 平台默认商品  存储数组  查询这个数组中有的产品 shopCount有值得 defaultDataArray
///平台默认商品  类型 都是 普通商品，无活动商品    他可以参加满赠满减的活动
@property (strong, nonatomic) NSMutableArray<ProductModel *> *addDefaultCommitProductModelDataArray;
//
//服务器返回的 预计送达时间
@property (strong, nonatomic) NSDictionary *estimatedFinishTime;
///费用字典   posttagePrice:配送费  meelFee：餐盒费 preferentialPrice:优惠金额   orderPrice：订单价格（最终价格）
@property (strong, nonatomic) NSMutableDictionary *constDataDict;



//key
///门店信息
@property (strong, nonatomic) AreaStoreInfo *storeInfo;
/*********        data      *******/
@property (nonatomic, strong) OrderMessageModelInfo *orderInfo;
@property (strong, nonatomic) NSArray *showSectionArray;
@property (strong, nonatomic) NSArray *sectionArray;
@property (strong, nonatomic) NSMutableDictionary *staticTitleDict;
///存储拉取到的超值加价购商品列表
@property (strong, nonatomic) NSMutableArray<AddPricetoBuyInfo *> *addPricetoBuyDataArray;

///默认商品  可以   是能够参加满赠满减活动的      点击了  默认商品之后  要去重新匹配红包 和 满减满赠优惠
@property (strong, nonatomic) NSMutableArray<ProductModel *> *defaultDataArray;
///满减
@property (strong, nonatomic) NSMutableArray<ReducePreferentialInfo *> *reduceDataArray;
///满赠
@property (strong, nonatomic) NSMutableArray<GevePreferentialInfo *> *geveDataArray;
@property (strong, nonatomic) NSMutableArray<RedPacketsInfo *> *redPacketsDataArray;



@end
