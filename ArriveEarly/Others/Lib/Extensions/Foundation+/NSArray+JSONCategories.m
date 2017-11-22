//
//  NSArray+JSONCategories.m
//  SalesCheck
//
//  Created by 朱洪兵 on 15/3/28.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import "NSArray+JSONCategories.h"

@implementation NSArray (JSONCategories)

-(NSData*)JSONString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
