//
//  AEMessageInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/14.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEMessageInfo : NSObject
///别名
@property (nonatomic, copy) NSString *alias;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, assign) NSInteger id_message;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, assign) int msgType;
@property (nonatomic, copy) NSString *msgUrl;
@property (nonatomic, assign) int pushState;
@property (nonatomic, copy) NSString *regId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) long long sendTime;
@property (nonatomic, copy) NSString *tags;


@end
