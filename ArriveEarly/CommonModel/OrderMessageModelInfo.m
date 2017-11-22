//
//  OrderMessageModelInfo.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderMessageModelInfo.h"

@implementation OrderMessageProductInfo

@end

@implementation OrderMessageBooksfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderID" : @"id",@"postagePrice" : @"posttagePrice"};
}

- (BOOL)isAllowDelete
{
    if (self.orderStatus == OrderStatus_canceled || self.orderStatus == OrderStatus_abnormal || self.orderStatus == OrderStatus_payTimeOut || self.orderStatus == OrderStatus_evaluated ||  self.orderStatus == OrderStatus_finish ||  self.orderStatus == OrderStatus_areadlyFinish ) {
        return YES;
    }
    return NO;
}

- (NSString *)orderStatus_str
{
    NSString *name = @"等待支付";
    //{1:{name:'等待制作'},2:{name:'正在制作'},3:{name:'正在配送'},4:{name:'已送达'},5:{name:'正在取消'},6:{name:'已取消'}};
    switch (self.orderStatus) {
        case OrderStatus_waitePay:
            name = @"等待付款";
            break;
        case OrderStatus_waiteMake:
            name = @"正在制作";
            break;
        case OrderStatus_makeing:
            name = @"正在制作";
            break;
        case OrderStatus_distributing:
            name = @"配送中";
            break;
        case OrderStatus_finish:
            name = @"已送达";
            break;
        case OrderStatus_canceling:
            name = @"正在取消";
            break;
        case OrderStatus_canceled:
            name = @"已取消";
            break;
        case OrderStatus_abnormal:
            name = @"订单异常";
            break;
        case OrderStatus_payTimeOut:
            name = @"支付超时";
            break;
        case OrderStatus_areadlyFinish:
            name = @"已完成";
            break;
        case OrderStatus_evaluated:
            name = @"已完成";
            break;
        
            
        default:
            break;
    }
    
    return name;
}
- (int)orderStatus
{
    if (self.isEva) {
        return OrderStatus_evaluated;
    }
    return _orderStatus;
}
@end

@implementation RedBagRestEntity
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"rbId" : @"id"};
}

@end

@implementation OrderMessageModelInfo

+ (instancetype)special_yy_modelWithDictionary:(NSDictionary *)dict
{
    OrderMessageModelInfo *info = [OrderMessageModelInfo yy_modelWithDictionary:dict];
    if ([dict[@"orderWhen"] isKindOfClass:[NSDictionary class]]) {//
        NSDictionary *orderWhenDict = dict[@"orderWhen"];
        if ([orderWhenDict[@"whenConfigEntity"] isKindOfClass:[NSDictionary class]]) {
            info.whenConfigEntity = [ReducePreferentialInfo yy_modelWithDictionary:orderWhenDict[@"whenConfigEntity"]];;
        }
    }
    if ([dict[@"orderWhenGive"] isKindOfClass:[NSDictionary class]]) {//
        NSDictionary *orderWhenDict = dict[@"orderWhenGive"];
        if ([orderWhenDict[@"whenGiveConfig"] isKindOfClass:[NSDictionary class]]) {
            info.whenGiveConfig = [GevePreferentialInfo yy_modelWithDictionary:orderWhenDict[@"whenGiveConfig"]];
        }
    }
    
    if ([dict[@"orderRedBag"] isKindOfClass:[NSArray class]]) {//
        NSArray *orderWhenArray = dict[@"orderRedBag"];
        NSMutableArray *m_orderWhen = [[NSMutableArray alloc] init];
        for (NSDictionary *orderWhendict in orderWhenArray) {
            if ([orderWhendict isKindOfClass:[NSDictionary class]] && [orderWhendict[@"redBagRestEntity"] isKindOfClass:[NSDictionary class]]) {
                RedBagRestEntity *redBagRest = [RedBagRestEntity yy_modelWithDictionary:orderWhendict[@"redBagRestEntity"]];
                if ([redBagRest.rbConfig.rbName isKindOfClass:[NSString class]]) {
                    [m_orderWhen addObject:redBagRest];
                }
            }
        }
        info.redBagRestEntitys = m_orderWhen;
    }
    
    for (OrderMessageProductInfo *opinfo in info.orderProducts) {
        for (NSDictionary *oDict in dict[@"orderProducts"]) {
            if ([opinfo.productInfo.productId longLongValue] == [oDict[@"productId"] longLongValue] && [opinfo.productInfo.productName containsString:oDict[@"activityName"]]) {
                if (oDict[@"apid"] != (id)kCFNull) {
                    opinfo.productInfo.isActivity = [oDict[@"apId"] intValue];
                }
                if (oDict[@"productPrice"] != (id)kCFNull) {
                    opinfo.productInfo.activityPrice = [oDict[@"productPrice"] doubleValue];
                }
                opinfo.productInfo.activityName = oDict[@"activityName"];
            }
        }
        if (opinfo.orderProductType == ProductTypeAddPriceBuy) {
            opinfo.productInfo.activityPrice = opinfo.moreConfigEntity.morePrice;
        }
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (OrderMessageProductInfo *pinfo in info.orderProducts) {
        BOOL isExist = NO;
        for (OrderMessageProductInfo *samepinfo in array) {
            if ([pinfo.productId isEqualToString:samepinfo.productId] && pinfo.orderProductType == samepinfo.orderProductType) {
                isExist = YES;
                samepinfo.productCnt = samepinfo.productCnt + pinfo.productCnt;
            }
        }
        if (!isExist) {
            [array addObject:pinfo];
        }
    }
    info.orderProducts = (NSArray <OrderMessageProductInfo> *)array;
    info.booksInfo.whenId = info.whenConfigEntity.whenId;
    info.booksInfo.whenGiveId = info.whenGiveConfig.whenGiveId;
    info.userId = info.booksInfo.userId;
    return info;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"postagePrice" : @"posttagePrice",
             @"booksInfo" : @"books"};
}

- (NSString *)orderStatus_str
{
//    NSString *content = @"";
//    switch (self.orderStatus) {
//        case OrderStatus_waitePay:
//            content = @"未支付";
//            break;
//
//        default:
//            break;
//    }
    return @"等待支付";
}


- (CGFloat)orderNormalPrice
{
    CGFloat price = 0.00;
    for (OrderMessageProductInfo *info in self.orderProducts) {
        if (info.orderProductType == ProductTypeNormal) {
            price = price + (info.productCnt * info.productInfo.price);
        }
    }
    return price;
}

@end
