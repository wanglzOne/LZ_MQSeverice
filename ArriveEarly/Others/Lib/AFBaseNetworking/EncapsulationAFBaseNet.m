//
//  EncapsulationAFBaseNet.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/11.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "EncapsulationAFBaseNet.h"

#import <objc/runtime.h>

@implementation EncapsulationAFBaseNet
+ (void)getCodeWithPhoneNumber:(NSString *)phone type:(int)type onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    [[[AFBaseNetWork alloc] init] post:[@"sendCode" url_ex] params:@{@"phone" : phone, @"type" : @(type)} progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                encapsulationBlock(dict, nil);
            }else
            {
                encapsulationBlock(nil, [NSError errorWithDomain:@"验证码发送失败，请检查您的网络..." code:[[dict objectForKey:@"responseCode"] intValue] localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(nil, [NSError errorWithDomain:@"验证码发送失败，请检查您的网络..." code:0 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, [NSError errorWithDomain:@"验证码发送失败，请检查您的网络..." code:0 localizedDescription:nil]);
    }];
}

+ (void)getCodeWithPhoneNumber:(NSString *)phone onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    
    
    
    [[[AFBaseNetWork alloc] init] post:[@"sendCode" url_ex] params:@{@"phone" : phone} progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                encapsulationBlock(dict, nil);
            }else
            {
                encapsulationBlock(nil, [NSError errorWithDomain:@"验证码发送失败，请检查您的网络..." code:[[dict objectForKey:@"responseCode"] intValue] localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(nil, [NSError errorWithDomain:@"验证码发送失败，请检查您的网络..." code:0 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, [NSError errorWithDomain:@"验证码发送失败，请检查您的网络..." code:0 localizedDescription:nil]);
    }];
}
- (void)changeUserInfo:(NSDictionary *)infoDict onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
        [dictinfo setObject:[ArriveEarlyManager shared].userLogData.userToken forKey:@"token"];
    }else
    {
        encapsulationBlock(nil, [NSError errorWithDomain:@"登录失效" code:-1 localizedDescription:nil]);
        return;
    }
    
    NSArray *keys = @[@"name" , @"userPhone" , @"password" ,@"newPassword",@"oldPassword", @"url",@"id",@"newPhone",@"oldPhone",];
    for (NSString *key in keys) {
        if (![infoDict.allKeys containsObject:key]) {
            [dictinfo setObject:@""  forKey:key];
        }
    }
    
    [[[AFBaseNetWork alloc] init] post:[@"updateUserInfo" url_ex] params:dictinfo progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                
                
                [ArriveEarlyManager updateUserInfofor:infoDict];
                
                
                encapsulationBlock(dict, nil);
                //修改用户信息成功之后 需要去修改本地的参数
                
                
            }else
            {
                int code = -1;
                if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                    code = [[dict objectForKey:@"responseCode"] intValue];
                }
                NSString *domain = @"数据错误";
                if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                    domain = [dict objectForKey:@"responseDescription"];
                }
                encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(responseObject, [NSError errorWithDomain:@"数据错误" code:-1 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, error);
    }];
}

+ (void)changeUserInfo:(NSDictionary *)infoDict onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
        [dictinfo setObject:[ArriveEarlyManager shared].userLogData.userToken forKey:@"token"];
    }else
    {
        encapsulationBlock(nil, [NSError errorWithDomain:@"登录失效" code:-1 localizedDescription:nil]);
        return;
    }
    
    NSArray *keys = @[@"name" , @"userPhone" , @"password" ,@"newPassword",@"oldPassword", @"url",@"id",@"newPhone",@"oldPhone",];
    for (NSString *key in keys) {
        if (![infoDict.allKeys containsObject:key]) {
            [dictinfo setObject:@""  forKey:key];
        }
    }
    
    [[[AFBaseNetWork alloc] init] post:[@"updateUserInfo" url_ex] params:dictinfo progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                
                
                [ArriveEarlyManager updateUserInfofor:infoDict];
                
                
                encapsulationBlock(dict, nil);
                //修改用户信息成功之后 需要去修改本地的参数
                
                
            }else
            {
                int code = -1;
                if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                    code = [[dict objectForKey:@"responseCode"] intValue];
                }
                NSString *domain = @"数据错误";
                if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                    domain = [dict objectForKey:@"responseDescription"];
                }
                encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(responseObject, [NSError errorWithDomain:@"数据错误" code:-1 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, error);
    }];
}

+ (void)dictRequestAndTokenPost:(NSString *)url
                          params:(NSDictionary *)params
         onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] init];
    if (params) {
        [dictinfo addEntriesFromDictionary:params];
    }
    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
        [dictinfo setObject:[ArriveEarlyManager shared].userLogData.userToken forKey:@"token"];
    }else
    {
        [dictinfo setObject:@"" forKey:@"token"];
    }
    [[[AFBaseNetWork alloc] init] post:url params:dictinfo progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([dict objectForKey:@"responseCode"] != (id)kCFNull && [[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                encapsulationBlock(dict, nil);
            }else
            {
                int code = -1;
                if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                    code = [[dict objectForKey:@"responseCode"] intValue];
                }
                NSString *domain = @"数据错误";
                if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                    domain = [dict objectForKey:@"responseDescription"];
                }
                encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(responseObject, [NSError errorWithDomain:@"数据错误" code:-1 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, error);
    }];
}
+ (void)dictRequestAndPageTokenPost:(NSString *)url
                        pageParams:(NSDictionary *)pageParams
                             params:(NSDictionary *)params
        onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    
    
    NSString *token = @"";
    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
        token = [ArriveEarlyManager shared].userLogData.userToken;
        //[dictinfo setObject: forKey:@"token"];
    }else
    {
        //encapsulationBlock(nil, [NSError errorWithDomain:@"请登陆" code:-1 localizedDescription:nil]);
    }
    //token 在 params中
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] initWithDictionary:pageParams];
    NSMutableDictionary *mmdictinfo = [[NSMutableDictionary alloc] init];
    if (params) {
        [mmdictinfo addEntriesFromDictionary:params];
    }
    [mmdictinfo setObject:token forKey:@"token"];
    [dictinfo setObject:mmdictinfo forKey:@"params"];
    
    //token  不在 params中
    /*
    NSMutableDictionary *ddd = [pageParams mutableCopy];
    [ddd setObject:token forKey:@"token"];
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] initWithDictionary:ddd];
    if (params) {
        [dictinfo setObject:params forKey:@"params"];
    }
    */
    
    [[[AFBaseNetWork alloc] init] post:url params:dictinfo progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                encapsulationBlock(dict, nil);
            }else if ([[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_NoRecord) {
                int code = -1;
                if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                    code = [[dict objectForKey:@"responseCode"] intValue];
                }
                NSString *domain = @"数据错误";
                if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                    domain = [dict objectForKey:@"responseDescription"];
                }
                encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
            }
            else
            {
                int code = -1;
                if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                    code = [[dict objectForKey:@"responseCode"] intValue];
                }
                NSString *domain = @"数据错误";
                if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                    domain = [dict objectForKey:@"responseDescription"];
                }
                encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(responseObject, [NSError errorWithDomain:@"数据错误" code:-1 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, error);
    }];
}

+ (void)getBookDetailInfoWithBookID:(NSString *)bookId
            onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
//    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
//    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
//        [dictinfo setObject:[ArriveEarlyManager shared].userLogData.userToken forKey:@"token"];
//    }else
//    {
//        encapsulationBlock(nil, [NSError errorWithDomain:@"登录失效" code:-1 localizedDescription:nil]);
//        return;
//    }
}

+ (void)uploadImages:(NSArray *)image
      onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] init];
    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
        [dictinfo setObject:[ArriveEarlyManager shared].userLogData.userToken forKey:@"token"];
    }else
    {
        [dictinfo setObject:@"" forKey:@"token"];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (UIImage *img in image) {
            if ([img isKindOfClass:[UIImage class]]) {
                NSString *b64 = [UIImage base64StringforImageJPGData:[img compressedData]];
                if (b64) {
                    [dictinfo setObject:b64 forKey:@"base64String"];
                }
            }
        }
        NSString *url  = nil;
        if ([@"" respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)] ) {
            url = [[NSString stringWithFormat:@"%@%@%@/",KBaseIP,@"mq/upload/",@"base64"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        else
        {
            url = [[NSString stringWithFormat:@"%@%@%@/",KBaseIP,@"mq/upload/",@"base64"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [[[AFBaseNetWork alloc] init] post:url params:dictinfo progress:nil responseObject:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // something
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dict = responseObject;
                    if ([[dict objectForKey:@"responseCode"] intValue] == 0) {
                        encapsulationBlock(dict, nil);
                    }else
                    {
                        int code = -1;
                        if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                            code = [[dict objectForKey:@"responseCode"] intValue];
                        }
                        NSString *domain = @"数据错误";
                        if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                            domain = [dict objectForKey:@"responseDescription"];
                        }
                        encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
                    }
                }
                else
                {
                    encapsulationBlock(responseObject, [NSError errorWithDomain:@"数据错误" code:-1 localizedDescription:nil]);
                }
                
            });
            
        } onError:^(NSError *error) {
            __block NSError *error2 = error;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error2.code == -1001) {
                    error2 = [NSError errorWithDomain:@"链接超时" code:error2.code userInfo:nil];
                }
                if ([error2.domain isEqualToString:@"NSCocoaErrorDomain"]) {
                    error2 = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error2.code userInfo:nil];
                }
                if ([error2.domain isEqualToString:@"NSURLErrorDomain"]) {
                    error2 = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error2.code userInfo:nil];
                }
                encapsulationBlock(nil, error2);
                
            });
            
        }];
        
    });
    
    
}


+ (void)updateProductInfoForProducts:(NSArray *)productArrar onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    NSString *areaId = @"";
    if ([ArriveEarlyManager shared].areaStoreInfo.areaId ) {
        areaId = [ArriveEarlyManager shared].areaStoreInfo.areaId;
    }
    NSMutableDictionary *dictinfo = [[NSMutableDictionary alloc] init];
    NSMutableArray *params = [[NSMutableArray alloc] init];
    
    for (ProductModel *model in productArrar) {
        if ([model isKindOfClass:[ProductModel class]]) {
            if (model.productId) {
                [params addObject:@{@"id":model.productId,@"apId":@(model.isActivity),@"areaId":areaId}];
            }
        }
        if ([model isKindOfClass:[OrderMessageProductInfo class]]) {
            OrderMessageProductInfo *mod = (OrderMessageProductInfo *)model;
            if (mod.productInfo.productId) {
                [params addObject:@{@"id":mod.productInfo.productId,@"apId":@(mod.productInfo.isActivity),@"areaId":areaId}];
            }
        }
    }
    
    [dictinfo setObject:[params yy_modelToJSONString] forKey:@"ids"];
    
    if ([ArriveEarlyManager shared].userLogData.userToken.length) {
        [dictinfo setObject:[ArriveEarlyManager shared].userLogData.userToken forKey:@"token"];
    }else
    {
        [dictinfo setObject:@"" forKey:@"token"];
    }
    [[[AFBaseNetWork alloc] init] post:[@"findById" url_ex] params:dictinfo progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = responseObject;
            if ([dict objectForKey:@"responseCode"] != (id)kCFNull && [[dict objectForKey:@"responseCode"] intValue] == ResponseCodeType_Success) {
                encapsulationBlock(dict, nil);
            }else
            {
                int code = -1;
                if ([dict objectForKey:@"responseCode"] != (id)kCFNull) {
                    code = [[dict objectForKey:@"responseCode"] intValue];
                }
                NSString *domain = @"数据错误";
                if ([dict objectForKey:@"responseDescription"] != (id)kCFNull) {
                    domain = [dict objectForKey:@"responseDescription"];
                }
                encapsulationBlock(responseObject, [NSError errorWithDomain:domain code:code localizedDescription:nil]);
            }
        }
        else
        {
            encapsulationBlock(responseObject, [NSError errorWithDomain:@"数据错误" code:-1 localizedDescription:nil]);
        }
    } onError:^(NSError *error) {
        if (error.code == -1001) {
            error = [NSError errorWithDomain:@"链接超时" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"链接服务器失败，请检查您的网络" code:error.code userInfo:nil];
        }
        encapsulationBlock(nil, error);
    }];

}

+ (void)updateExpNewPosition:(NSString *)expPhone onCommonBlockCompletion:(CommonEncapsulationBlockCompletion)encapsulationBlock
{
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findExpNow" url_ex] params:@{@"expPhone":expPhone} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            encapsulationBlock(responseObject,nil);
        }else
        {
            encapsulationBlock(nil,[NSError errorWithDomain:@"获取失败" code:-1 userInfo:nil]);
        }
    }];
}



@end
