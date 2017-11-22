//
//  AddPricetoBuyInfo.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AddPricetoBuyInfo.h"

@implementation AddPricetoBuyConfigInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"configId" : @"id" };
}

@end


@implementation AddPricetoBuyInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"configInfo" : @"tags" };
}


@end
