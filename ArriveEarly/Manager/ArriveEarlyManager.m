//
//  ArriveEarlyManager.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "UMessage.h"
#import <AdSupport/ASIdentifierManager.h>

typedef void (*DummyAction)(char * result);
typedef void (^DummyBlock)(char * result);

DummyBlock functionToBlock(DummyAction func) {
    return [^(char * result) {
        func(result);
        
        
        
    } copy];
}

#import "ArriveEarlyManager.h"
#import <YYModel.h>
#import "LocationManager.h"
#import "AppDelegate.h"

static NSString *kUserInfo = @"SAVE_UserInfo";// dict jsonStr
static NSString *kUserLoginData = @"SAVE_UserLoginData";// str
static NSString *kDefaultAddress = @"SAVE_DefaultAddress";

@interface ArriveEarlyManager ()

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) UserLoginData *userLogData;
@property (nonatomic, strong) AreaStoreInfo *areaStoreInfo;
@property (nonatomic, strong) Adress_Info *defaultAddress;

@end

@implementation ArriveEarlyManager

+ (instancetype)shared {
    static id _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userInfo;
        self.userLogData;
    }
    return self;
}



+ (void)loginSuccess:(LoginSuccessBlock)successblock fail:(NOLoginBlock)failblock
{
    if ([ArriveEarlyManager shared].userInfo) {
        BLOCK_EXIST(successblock)
    }
    else
    {
        BLOCK_EXIST(failblock)
    }
}

+(void)regRequestWith:(NSDictionary *)params onComplete:(RegBlock)regblock{
    
        [[[AFBaseNetWork alloc] init] post:[@"appReg" url_ex] params:params progress:nil responseObject:^(id responseObject) {
            DLog(@"_______________%@_________",responseObject);
            regblock(responseObject,nil);
            
        } onError:^(NSError *error) {
            
             regblock(nil, error);
        }];
    
    
    
}

+ (void)loginRequestWith:(NSDictionary *)params onComplete:(LoginBlock)logblock
{
    //登陆成功之后 存用户信息 分开存token
    //登陆时候保存用户信息   如果token失效 再次发送登陆请求

    //
    [[[AFBaseNetWork alloc] init] post:[@"appLogin" url_ex] params:params progress:nil responseObject:^(id responseObject) {
        DLog(@"登录成功\n%@", responseObject);
        //处理数据  存储  (dict && dict != (id)kCFNull)
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = responseObject;
            if (!dataDict[@"responseCode"] || dataDict[@"responseCode"] == (id)kCFNull) {
                logblock(nil, [NSError errorWithDomain:@"链接失败..." code:-1 userInfo:nil]);
                return ;
            }
            if ([dataDict[@"responseCode"] intValue] == 1) {
                
                NSDictionary *infoD = dataDict[@"responseData"];
                if ([infoD isKindOfClass:[NSDictionary class]] && infoD[@"tokenStr"] && [infoD[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
                    ////成功处理  infoD
                    NSDictionary *userinfoDict = infoD[@"userInfo"];
                    UserInfo *info = [UserInfo yy_modelWithDictionary:userinfoDict];
                    [ArriveEarlyManager shared].userInfo = info;
                    NSString *jsonstr = [info yy_modelToJSONString];
                    [[NSUserDefaults standardUserDefaults] setObject:jsonstr forKey:kUserInfo];
                    
                    UserLoginData *loginData = [UserLoginData yy_modelWithDictionary:userinfoDict];
                    loginData.userToken = infoD[@"tokenStr"];
                    [ArriveEarlyManager shared].userLogData = loginData;
                    NSString *loginDatajsonstr = [loginData yy_modelToJSONString];
                    [[NSUserDefaults standardUserDefaults] setObject:loginDatajsonstr forKey:kUserLoginData];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [PushMessageManager customConfigPushMessage:ArriveEarlyManager.deviceToken];
                    
                    logblock(dataDict, nil);
                }
                else
                {
                    logblock(nil, [NSError errorWithDomain:@"数据格式错误" code:-1 userInfo:nil]);
                }
            }else
            {
                logblock(nil, [NSError errorWithDomain:dataDict[@"responseDescription"] code:-1 userInfo:nil]);
            }
        }
        else
        {
            logblock(nil, [NSError errorWithDomain:@"数据错误..." code:-1 userInfo:nil]);
        }
    } onError:^(NSError *error) {
        logblock(nil, error);
    }];
}


+ (void)registerRequestWith:(NSDictionary *)params onComplete:(LoginBlock)logblock
{
    //登陆成功之后 存用户信息 分开存token
    //登陆时候保存用户信息   如果token失效 再次发送登陆请求
    
    //
    [[[AFBaseNetWork alloc] init] post:[@"appReg" url_ex] params:params progress:nil responseObject:^(id responseObject) {
        DLog(@"注册成功\n%@", responseObject);
        //处理数据  存储  (dict && dict != (id)kCFNull)
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = responseObject;
            if (!dataDict[@"responseCode"] || dataDict[@"responseCode"] == (id)kCFNull) {
                logblock(nil, [NSError errorWithDomain:@"链接失败..." code:-1 userInfo:nil]);
                return ;
            }
            if ([dataDict[@"responseCode"] intValue] == 1) {
                
                NSDictionary *infoD = dataDict[@"responseData"];
                if ([infoD isKindOfClass:[NSDictionary class]] && infoD[@"tokenStr"] && [infoD[@"userInfo"] isKindOfClass:[NSDictionary class]]) {
                    ////成功处理  infoD
                    NSDictionary *userinfoDict = infoD[@"userInfo"];
                    UserInfo *info = [UserInfo yy_modelWithDictionary:userinfoDict];
                    [ArriveEarlyManager shared].userInfo = info;
                    NSString *jsonstr = [info yy_modelToJSONString];
                    [[NSUserDefaults standardUserDefaults] setObject:jsonstr forKey:kUserInfo];
                    
                    UserLoginData *loginData = [UserLoginData yy_modelWithDictionary:userinfoDict];
                    loginData.userToken = infoD[@"tokenStr"];
                    [ArriveEarlyManager shared].userLogData = loginData;
                    NSString *loginDatajsonstr = [loginData yy_modelToJSONString];
                    [[NSUserDefaults standardUserDefaults] setObject:loginDatajsonstr forKey:kUserLoginData];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [PushMessageManager customConfigPushMessage:ArriveEarlyManager.deviceToken];
                    
                    logblock(dataDict, nil);
                }
                else
                {
                    logblock(nil, [NSError errorWithDomain:@"数据格式错误" code:-1 userInfo:nil]);
                }
            }else
            {
                logblock(nil, [NSError errorWithDomain:dataDict[@"responseDescription"] code:-1 userInfo:nil]);
            }
        }
        else
        {
            logblock(nil, [NSError errorWithDomain:@"数据错误..." code:-1 userInfo:nil]);
        }
    } onError:^(NSError *error) {
        logblock(nil, error);
    }];
}




+ (void)updateUserInfoWithTokenComplete:(LoginBlock)logblock
{
    
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findUserInfo" url_ex] params:nil onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {

            logblock(responseObject, error);

            return ;
        }
        NSDictionary *dict = responseObject;
        if ([dict[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            UserInfo *info  = [ArriveEarlyManager shared].userInfo;
            [info yy_modelSetWithDictionary:dict[@"responseData"]];
            NSString *jsonstr = [info yy_modelToJSONString];
            [[NSUserDefaults standardUserDefaults] setObject:jsonstr forKey:kUserInfo];
            
            UserLoginData *loginData  = [ArriveEarlyManager shared].userLogData;
            NSString *token = loginData.userToken;
            [loginData yy_modelSetWithDictionary:dict[@"responseData"]];
            loginData.userToken = token;
            NSString *loginDataStr = [loginData yy_modelToJSONString];
            [[NSUserDefaults standardUserDefaults] setObject:loginDataStr forKey:kUserLoginData];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        logblock(responseObject, nil);
    }];
}
- (void)updateareaStoreInfoBlock:(AreaStoreInfoRequestBlock )areaStoreInfoBlock
{
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findArea" url_ex] params:@{@"areaId" : [ArriveEarlyManager shared].areaStoreInfo.areaId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            //self.areaStoreInfo = nil;
            if (areaStoreInfoBlock) {
                areaStoreInfoBlock(nil,error);
            }
            return ;
        }
        NSDictionary *dict = responseObject;
        if ([responseObject isKindOfClass:[NSDictionary class]] && [dict[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            self.areaStoreInfo = [AreaStoreInfo yy_modelWithDictionary:dict[@"responseData"]];
        }
        if (areaStoreInfoBlock) {
            areaStoreInfoBlock(self.areaStoreInfo,error);
        }
    }];
}
- (void)updateRegionalInformationBlock:(AreaStoreInfoRequestBlock )areaStoreInfoBlock
{
    LocationManager *location = [LocationManager sharedManager];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-1, -1);
    if ([ArriveEarlyManager shared].coordinate.longitude > 0) {
        coordinate = [ArriveEarlyManager shared].coordinate;
    }else
    {
        coordinate = location.coordinate;
    }
    if(coordinate.longitude > 0 && coordinate.latitude > 0){
        NSString *areaLocations = [NSString stringWithFormat:@"%f#%f", coordinate.longitude, coordinate.latitude];
        
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findAreaByPoint" url_ex] params:@{@"areaLocations" : areaLocations} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            if (error) {
                //self.areaStoreInfo = nil;
                if (areaStoreInfoBlock) {
                    areaStoreInfoBlock(nil,error);
                }
                return ;
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = responseObject;
                NSString *errStr = dic[@"responseDescription"];
                if (!errStr.length) {
                    errStr = @"";
                }
                if ([dic[@"responseCode"] intValue] == 1) {
                    NSDictionary *dateDict = dic[@"responseData"];
                    if ([dateDict isKindOfClass:[NSDictionary class]]) {
                        AreaStoreInfo *info = [AreaStoreInfo yy_modelWithDictionary:dateDict];
                        [ArriveEarlyManager shared].coordinate = coordinate;
                        [ArriveEarlyManager shared].areaStoreInfo = info;
                        areaStoreInfoBlock(info,nil);
                    }else
                    {
                        areaStoreInfoBlock(nil, [NSError errorWithDomain:@"数据格式错误" code:-1 userInfo:nil]);
                    }
                }else
                {
                    areaStoreInfoBlock(nil, [NSError errorWithDomain:errStr code:[dic[@"responseCode"] intValue] userInfo:nil]);
                }
            }else
            {
                areaStoreInfoBlock(nil, [NSError errorWithDomain:@"数据格式错误" code:-1 userInfo:nil]);
            }

        }];

    }else{
        areaStoreInfoBlock(nil, nil);
        return;
    }
    
}

- (void)updateRegionalInformationOnComplete:(AreaStoreInfoRequestBlock )areaStoreInfoBlock
{
    // 金纬度
    LocationManager *location = [LocationManager sharedManager];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-1, -1);
    if ([ArriveEarlyManager shared].coordinate.longitude > 0) {
        coordinate = [ArriveEarlyManager shared].coordinate;
    }else
    {
        coordinate = location.coordinate;
    }
    if (coordinate.latitude <= 0 || coordinate.longitude <= 0) {
        LocationManager *locationonce = [[LocationManager alloc] initOther];
        locationonce.locationOnce_stopUserLocationService = YES;
        [locationonce startLocateAndGeoCurrentCityLocationWithSuccess:^{
            if (areaStoreInfoBlock) {
                [ArriveEarlyManager shared].address = locationonce.address;
                [ArriveEarlyManager shared].coordinate = locationonce.coordinate;
                [self requestRegionalInformationWith:locationonce.coordinate onComplete:areaStoreInfoBlock];
            }
        } failure:^(NSError *error) {
            if (areaStoreInfoBlock) {
                areaStoreInfoBlock(nil,error);
            }
        }];
    }
    else
    {
        if (areaStoreInfoBlock) {
            [self requestRegionalInformationWith:coordinate onComplete:areaStoreInfoBlock];
        }
    }
}

- (void)requestRegionalInformationWith:(CLLocationCoordinate2D)coordinate onComplete:(AreaStoreInfoRequestBlock )areaStoreInfoBlock
{
    
    
    NSString *areaLocations = [NSString stringWithFormat:@"%f#%f", coordinate.longitude, coordinate.latitude];
    [[[AFBaseNetWork alloc] init] post:[@"findAreaByPoint" url_ex] params:@{@"areaLocations" : areaLocations} progress:nil responseObject:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = responseObject;
            NSString *errStr = dic[@"responseDescription"];
            if (!errStr.length) {
                errStr = @"";
            }
            if ([dic[@"responseCode"] intValue] == 1) {
                NSDictionary *dateDict = dic[@"responseData"];
                if ([dateDict isKindOfClass:[NSDictionary class]]) {
                    AreaStoreInfo *info = [AreaStoreInfo yy_modelWithDictionary:dateDict];
                    [ArriveEarlyManager shared].coordinate = coordinate;
                    [ArriveEarlyManager shared].areaStoreInfo = info;
                    areaStoreInfoBlock(info,nil);
                }else
                {
                    areaStoreInfoBlock(nil, [NSError errorWithDomain:@"数据格式错误" code:-1 userInfo:nil]);
                }
            }else
            {
                areaStoreInfoBlock(nil, [NSError errorWithDomain:errStr code:[dic[@"responseCode"] intValue] userInfo:nil]);
            }
        }else
        {
            areaStoreInfoBlock(nil, [NSError errorWithDomain:@"数据格式错误" code:-1 userInfo:nil]);
        }
    } onError:^(NSError *error) {
        areaStoreInfoBlock(nil, error);
    }];
}

- (UserInfo *)userInfo
{
    if (!_userInfo) {
        id data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if (data != nil && data != (id)kCFNull) {
            _userInfo = [UserInfo yy_modelWithJSON:data];
        }
    }
    return _userInfo;
}

- (UserLoginData *)userLogData
{
    if (!_userLogData) {
        id data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLoginData];
        if (data != nil && data != (id)kCFNull) {
            _userLogData = [UserLoginData yy_modelWithJSON:data];
        }
    }
    return _userLogData;
}

- (void)loadDefaultAddress:(CommonVoidBlock)block
{
    NSString *addressID = @"";
    if (self.userInfo.defaultAddressID.length) {
        addressID = self.userInfo.defaultAddressID;
    }else
    {
        addressID = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultAddress];
    }
    if ([addressID isKindOfClass:[NSString class]] && addressID.length) {
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findAddress" url_ex] params:@{@"id" : addressID} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            if (error) {
                block();
                return ;
            }
            NSDictionary *dict = responseObject;
            NSDictionary *data = dict[@"responseData"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                self.defaultAddress = [Adress_Info yy_modelWithDictionary:data];
            }
            block();
        }];
        return;
    }
    block();
}

+ (void)saveDefaultAddress:(Adress_Info *)adressInfo
{
    if (adressInfo.id_address && adressInfo.id_address != (id)kCFNull) {
        [[NSUserDefaults standardUserDefaults] setObject:adressInfo.id_address forKey:kDefaultAddress];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSDictionary *)loginParamsHelperWithUserName:(NSString *)userName password:(NSString *)password code:(NSString *)code
{
    NSArray *values = @[userName,password,@((long long)[[NSDate date] timeIntervalSince1970UTC]),KEY_Umeng,[NSString deviceIPAddress],code];
    NSArray *keys = @[@"userName",@"password",@"time",@"appkeyId",@"ip",@"code",@"additional"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSMutableString *allValues = [[NSMutableString alloc] init];
    for (int i=0; i < values.count; i ++) {
        if ([keys[i] isEqualToString:@"time"]) {
            [allValues appendString:KConvention];
            [allValues appendString:[NSString stringWithFormat:@"%lld",[values[i] longLongValue]]];
        }else
            [allValues appendString:values[i]];
        [parameter setValue:values[i] forKey:keys[i]];
    }
    //
    [parameter setValue:[allValues MD5String] forKey:keys.lastObject];
    //@"userName",@"password"@"code"
    return parameter;
}

/// 在登陆失效，   重新登陆的时候也清楚这个数据
+ (void)logOut
{
    [[ShoppingCarManager sharedManager] removeLocationData];
    [ArriveEarlyManager shared].userInfo = nil;
    [ArriveEarlyManager shared].userLogData = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultAddress];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserLoginData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //移除订单页面的数据
    [[NSNotificationCenter defaultCenter] postNotificationName:KLogOutSucess object:nil];
    
}

//////修改用户信息  key ： name userPhone password url
+ (void)updateUserInfofor:(NSDictionary *)userInfoDict
{
    if ([userInfoDict.allKeys containsObject:@"name"]) {
        [ArriveEarlyManager shared].userInfo.name = userInfoDict[@"name"];
    }
    if ([userInfoDict.allKeys containsObject:@"userPhone"]) {
        [ArriveEarlyManager shared].userInfo.userPhone = userInfoDict[@"newPhone"];
    }
    if ([userInfoDict.allKeys containsObject:@"password"]) {
        [ArriveEarlyManager shared].userLogData.password = userInfoDict[@"password"];\
        NSString *loginDatajsonstr = [[ArriveEarlyManager shared].userLogData yy_modelToJSONString];
        [[NSUserDefaults standardUserDefaults] setObject:loginDatajsonstr forKey:kUserLoginData];
    }
    if ([userInfoDict.allKeys containsObject:@"url"]) {
        [ArriveEarlyManager shared].userInfo.url = userInfoDict[@"url"];
    }
    NSString *jsonstr = [[ArriveEarlyManager shared].userInfo yy_modelToJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:jsonstr forKey:kUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark -  class property
+ (NSString *)deviceToken
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return app.g_deviceToken;
}

@end
