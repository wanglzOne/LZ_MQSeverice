//
//  NSException+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/14.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

/**
 *	Assert macros
 *
 *  Almost copy from：https://github.com/krzysztofzablocki/KZPropertyMapper/blob/master/KZPropertyMapper/KZPropertyMapper.m
 *
 */
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, kErrorCode) {
    kErrorCodeInternal = 44324344,
};

#define AssertIsMainThread() NSCAssert([NSThread isMainThread], @"This should run on mani thread")
#define AssertNotMainThread() NSCAssert(![NSThread isMainThread], @"This should NOT run on mani thread")

/**
 *  AssertOrReturn
 *  If assert filed, return void directly
 *
 *  @param condition assert condition
 *
 */
#define AssertOrReturn(condition)     do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) {\
        AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd);\
        return;\
    }\
} while(0)


/**
 *  AssertOrReturnNil
 *  If assert filed, return nil directly
 *
 *  @param condition assert condition
 *
 */
#define AssertOrReturnNil(condition) do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) {\
        AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd);\
        return nil;\
    }\
} while(0)


/*
 *  AssertOrReturnExpr
 *  If assert condition failed, expr will be executed and return.
 *
 *  @param condition assert condition
 *  @param block     block.
 *
 */
#define AssertOrReturnExpr(condition, expr) do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) {\
        AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd);\
        return (expr);\
    }\
}while(0)


/*
 *  AssertOrRunExpr
 *  If assert condition failed, expr will be executed.
 *
 *  @param condition assert condition
 *  @param block     block.
 *
 */
#define AssertOrRunExpr(condition, expr) do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) {\
        AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd);\
        (expr);\
    }\
}while(0)


/**
 *  AssertOrReturnBlock
 *  If assert condition failed, block will be executed and the return void.
 *
 *  @param condition assert condition
 *  @param block     block.
 *
 */
#define AssertOrReturnBlock(condition, block) do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) {\
        AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd);\
        block();\
        return;\
    }\
}while(0)


/**
 *  AssertOrReturnNilBlock
 *  If assert condition failed, block will be executed and the return nil.
 *
 *  @param condition assert condition
 *  @param block     block.
 *
 */
#define AssertOrReturnNilBlock(condition, block) do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) { \
        block(AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd));\
        return nil;\
    }\
} while(0)


/**
 *  AssertOrReturnError
 *  If assert failed, return a NSError directly
 *
 *  @param condition assert condition
 *
 */
#define AssertOrReturnError(condition) do {\
    NSCAssert((condition), @"Invalid condition not satisfying: %s", #condition);\
    if(!(condition)) {\
        return AssertErrorMake([NSString stringWithFormat:@"Invalid condition not satisfying: %s", #condition], kErrorCodeInternal, nil, _cmd);\
    }\
}while(0)


#ifdef __cplusplus
extern "C" {
#endif
    
    extern NSError* AssertErrorMake(NSString *message, NSUInteger code, NSDictionary *aUserInfo, SEL selector);
    
#ifdef __cplusplus
}
#endif

