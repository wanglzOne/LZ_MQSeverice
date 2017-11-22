//
//  PageHelper.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/11.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PageHelper.h"

@implementation PageHelper

- (id)init
{
    if (self = [super init]) {
        ps = 10;
        self.currentPage = 1;
        self.pageSize  = ps;
        self.total = self.currentPage * self.pageSize;
    }
    return self;
}

- (int)total
{
    return self.total = self.currentPage * self.pageSize;
}

- (void)add
{
    self.currentPage++;
    self.pageSize = ps;
}

- (void)falseAdd
{
    if (self.currentPage > 1) {
        self.currentPage--;
    }
    self.pageSize = ps;
}

- (NSDictionary *)params
{
    return @{@"currentPage" : @(self.currentPage),
             @"pageSize" : @(self.pageSize)};
}

@end
