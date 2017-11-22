//
//  NSString+Unicde.h
//  SalesCheck
//
//  Created by yuanwen on 15/3/16.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(UnicodeUtilities)


+ (NSString*) unescapeUnicodeString:(NSString*)string;

+ (NSString*) escapeUnicodeString:(NSString*)string;
+ (NSString*) escapeUnicodeString2:(NSString*)string;
/**
 *  所有传入服务器的字符串都要经过 Unicode  编码
 *
 *  @return Unicode  Str
 */
- (NSString *)escapeUnicodeString;

@end