//
//  RedPacketsInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/12.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

///红包
@interface RedPacketsInfo : NSObject

@property (nonatomic, copy) NSString *id_redPackets;
@property (nonatomic, copy) NSString *rbName;
@property (nonatomic, copy) NSString *rbContent;

@property (nonatomic, copy) NSString *rbType;
@property (nonatomic, assign) long long rbEffStart;
@property (nonatomic, assign) long long rbEffEnd;
@property (nonatomic, assign) CGFloat rbValue;
@property (nonatomic, copy) NSString *rbState;

@property (nonatomic, copy) NSString *rbGenerator;
@property (nonatomic, assign) CGFloat rbLimitValue;
@property (nonatomic, copy) NSString *rbGentime;

@property (nonatomic, copy) NSString *rbSurplus;

@end
