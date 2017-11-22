//
//  NSException+Foundation+.m
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/14.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#import "NSException+Foundation+.h"

NSError* AssertErrorMake(NSString *message, NSUInteger code, NSDictionary *aUserInfo, SEL selector) {
    NSMutableDictionary *userInfo = [aUserInfo mutableCopy];
    userInfo[NSLocalizedDescriptionKey] = message;
    NSError *error = [NSError errorWithDomain:@"com.codingobjc.Foundation+" code:code userInfo:userInfo];
#if DEBUG
    NSLog(@"com.codingobjc.Foundation+ Error: %@", error);
#endif
    return error;
}
