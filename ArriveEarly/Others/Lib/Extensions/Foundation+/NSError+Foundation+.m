//
//  NSError+Foundation+.m
//  Foundation+
//
//  Created by ZhangTinghui on 14-6-17.
//  Copyright (c) 2014年 www.codingobjc.com. All rights reserved.
//

#import "NSError+Foundation+.h"

@implementation NSError (Foundation_)

+ (id)errorWithCode:(NSInteger)code localizedDescription:(NSString *)description {
    return [self errorWithDomain:@"Undefined error domain" code:code localizedDescription:description];
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code localizedDescription:(NSString *)description {
    NSDictionary *userInfo = nil;
    if (description) {
        userInfo = @{NSLocalizedDescriptionKey: description,
                     NSLocalizedFailureReasonErrorKey: description};
    }
    
    return [NSError errorWithDomain:domain code:code userInfo:userInfo];
}

@end
