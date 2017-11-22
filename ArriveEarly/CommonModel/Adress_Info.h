//
//  Adress_Info.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Adress_Info : NSObject

@property (nonatomic, copy) NSString *id_address;
@property (nonatomic, assign) int state;
@property (nonatomic, copy) NSString *orderIndex;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addressDetail;
//
@property (nonatomic, assign) double longtitude;
@property (nonatomic, assign) double latitude;

@property (nonatomic, copy) NSString *userId;
//备注
@property (nonatomic, copy) NSString *remark;
/// 0：男   1女
@property (nonatomic, assign) int sex;
// 
@property (nonatomic, assign) BOOL isMr;

@property (nonatomic, copy) NSString *contactPhone;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *proCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *disCode;



@end
