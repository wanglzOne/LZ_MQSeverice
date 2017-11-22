//
//  NSDictionary+escapeUnicode.m
//  SalesCheck
//
//  Created by 朱洪兵 on 15/3/28.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "NSDictionary+escapeUnicode.h"
#import "NSString+Unicde.h"
@implementation NSDictionary (escapeUnicode)

- (NSDictionary *)escapeUnicodeDict {
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    for (NSString *key in self.allKeys) {
        if ([self[key] isKindOfClass:[NSString class]]) {
            [resultDict setValue:[NSString escapeUnicodeString:self[key]] forKey:key];
        } else {
            [resultDict setValue:self[key] forKey:key];
        }
    }
    return resultDict;
}

- (NSDictionary *)escapeUnicodeDict2 {
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    for (NSString *key in self.allKeys) {
        if ([self[key] isKindOfClass:[NSString class]]) {
            [resultDict setValue:[NSString escapeUnicodeString:self[key]] forKey:key];
        } else {
            [resultDict setValue:self[key] forKey:key];
        }
    }
    return resultDict;
}

@end

