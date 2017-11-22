//
//  EncapsulationAFBaseNet.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/11.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageHelper.h"
#import "AFBaseNetWork.h"

#import "NSString+UrlExtenson.h"

typedef void(^CommonEncapsulationBlockCompletion)(id responseObject, NSError *error);

// ResponseCodeType
typedef NS_ENUM(NSInteger, ResponseCodeType) {
    ResponseCodeType_serviceFail = -2,          //服务器数据异常
    ResponseCodeType_tokenFailure = -1,         //token 过期
    ResponseCodeType_Fail = 0,                  //失败
    ResponseCodeType_Success = 1,               //成功
    ResponseCodeType_NoRecord = 2,              //没有记录
    ResponseCodeType_PasswordFail = 3,          //密码错误
    ResponseCodeType_PhoneNumberFail = 4,       //成功  用户手机号码错误

};



@interface EncapsulationAFBaseNet : NSObject
+ (void)getCodeWithPhoneNumber:(NSString *)phone type:(int)type onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;
+ (void)getCodeWithPhoneNumber:(NSString *)phone onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;
///修改用户信息  key ： name userPhone password url
+ (void)changeUserInfo:(NSDictionary *)infoDict onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;

+ (void)dictRequestAndTokenPost:(NSString *)url
                          params:(NSDictionary *)params
         onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;


+ (void)dictRequestAndPageTokenPost:(NSString *)url
                         pageParams:(NSDictionary *)pageParams
                             params:(NSDictionary *)params
            onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;

+ (void)uploadImages:(NSArray *)image
      onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;



- (void)changeUserInfo:(NSDictionary *)infoDict onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;

////获取指定商品的 最新信息
+ (void)updateProductInfoForProducts:(NSArray *)productArrar onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;



+ (void)updateExpNewPosition:(NSString *)expPhone onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock;
@end
