
//
//  DiscoverInfo.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/11.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "DiscoverInfo.h"

@implementation DiscoverInfoImageInfo

@end

@implementation DiscoverInfo
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"id_discover" : @"id",
             @"desc" : @"description"};
}
@end
