//
//  NSString+UrlExtenson.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/12.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "NSString+UrlExtenson.h"

@implementation NSString (UrlExtenson)

- (NSString *)url_ex
{
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)] ) {
        return [[NSString stringWithFormat:@"%@%@%@/",KBaseIP,KBaseU,self] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else
    {
        return [[NSString stringWithFormat:@"%@%@%@/",KBaseIP,KBaseU,self] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
}
/*
*/
- (NSString *)imageUrl
{
    if ([self hasPrefix:@"http"]) {
        return self;
    }
    if ([self hasPrefix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@%@/",KBaseIP,KBaseMQ,self];
    }
    return [NSString stringWithFormat:@"%@%@/%@/",KBaseIP,KBaseMQ,self];
}

@end
