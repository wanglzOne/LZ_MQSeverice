//
//  AreaStoreInfo.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/17.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AreaStoreInfo.h"

@implementation AreaStoreInfo

- (CLLocationCoordinate2D)coord
{
    return [AreaStoreInfo getCLLocationCoordinate2DforAreaScopeObjet:self.areaLocations];
}
+ (CLLocationCoordinate2D)getCLLocationCoordinate2DforAreaScopeObjet:(NSString *)lng_latString
{
    NSArray *arr = [lng_latString componentsSeparatedByString:@"#"];
    if (arr.count == 2) {
        return CLLocationCoordinate2DMake([arr[1] doubleValue], [arr[0] doubleValue]);
    }
    return CLLocationCoordinate2DMake(-1, -1);
}
- (NSString *)areaId
{
    if (_areaId && [_areaId isKindOfClass:[NSString class]]) {
        return _areaId;
    }
    return @"";
}

@end
