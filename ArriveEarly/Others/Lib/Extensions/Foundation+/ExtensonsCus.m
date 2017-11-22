//
//  ExtensonsCus.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ExtensonsCus.h"

@implementation ExtensonsCus

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL flag = [super isKindOfClass:aClass];
    if (!flag) {
        return flag;
    }else
    {
        if (self && self != (id)kCFNull) {
            return YES;
        }
    }
    return NO;
}



@end
