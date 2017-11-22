//
//  UserInfo.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (BOOL)isTheoldUser
{
    if (self.userState == 0) {
        return NO;
    }
    return YES;
}

@end


@implementation UserLoginData
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id" ,
             @"userToken" : @"token"};
}

@end

