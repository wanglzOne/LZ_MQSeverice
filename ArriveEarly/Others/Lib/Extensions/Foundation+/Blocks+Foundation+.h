//
//  Blocks+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/13.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#ifndef Foundation__Blocks_Foundation__h

#define Foundation__Blocks_Foundation__h

#import <Foundation/Foundation.h>

typedef void(^RequstCompletion)(NSDictionary * result, NSString * err);

typedef void (^CommonErrStrBlock)(NSString* err);
typedef void (^CommonVoidBlock)(void);
typedef void (^CommonObjectBlock)(id obj);
typedef void (^CommonErrorBlock)(NSError* error);

typedef NS_ENUM(NSInteger, PlanType) {
    PlanTypeLeave = 0, //请假
    PlanTypeEvection //出差
};

#endif
