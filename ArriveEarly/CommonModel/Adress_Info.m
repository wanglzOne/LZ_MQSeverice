//
//  Adress_Info.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "Adress_Info.h"

@implementation Adress_Info

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"id_address" : @"id"};
}


- (BOOL)isMr
{
    return self.sex ? NO : YES;
}


@end
