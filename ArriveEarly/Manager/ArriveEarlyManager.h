//
//  ArriveEarlyManager.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AreaStoreInfoRequestBlock)(AreaStoreInfo *areaStoreInfo, NSError *erroe);


typedef void (^LoginSuccessBlock)(void);

typedef void (^NOLoginBlock)(void);


typedef void (^LoginBlock)(id data, NSError *error);


typedef void (^RegBlock)(id data, NSError *error);


@interface ArriveEarlyManager : NSObject

@property (nonatomic, copy, class) NSString *deviceToken;

+ (instancetype)shared;

@property (nonatomic, strong, readonly) UserInfo *userInfo;
@property (nonatomic, strong, readonly) AreaStoreInfo *areaStoreInfo;
@property (nonatomic, strong, readonly) UserLoginData *userLogData;

///加载默认地址  存储默认地址
@property (nonatomic, strong, readonly) Adress_Info *defaultAddress;
/// 首先是加载  用户的 UserInfo的默认地址  如果没有 加载本地存储的默认地址id
- (void)loadDefaultAddress:(CommonVoidBlock)block;
/// 如果用户UserInfo设置了默认地址 存入用户的默认地址      如果没有UserInfo就加载本地存储的默认地址。     （调用地设置默认地址之后 记得更新userInfo并且存储 ）
+ (void)saveDefaultAddress:(Adress_Info *)adressInfo;


///   用于存储选择的经纬度    在首页进入选择地址页面之后  手动选择了地址  就要去记录这个地址。
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, strong)NSString *address;





//////修改用户信息  key ： name userPhone password url
+ (void)updateUserInfofor:(NSDictionary *)userInfoDict;

+ (void)loginSuccess:(LoginSuccessBlock)successblock fail:(NOLoginBlock)failblock;

+ (void)loginRequestWith:(NSDictionary *)params onComplete:(LoginBlock)logblock;

+ (void)registerRequestWith:(NSDictionary *)params onComplete:(LoginBlock)logblock;

+ (NSDictionary *)loginParamsHelperWithUserName:(NSString *)userName password:(NSString *)password code:(NSString *)code;
///更新用户信息
+ (void)updateUserInfoWithTokenComplete:(LoginBlock)logblock;

+ (void)logOut;




///前提是要有经纬度才能更新  直接更新方法，不会发送通知。更新结果会在block中返回。
///每一次启动程序建议调用此方法更新区域信息成功之后更新首页信息。   用户在使用程序过程中会定位用户位置。当用户移动距离超过1KM/....会更新区域信息，然后发送通知。
///
- (void)updateRegionalInformationOnComplete:(AreaStoreInfoRequestBlock )areaStoreInfoBlock;

- (void)updateRegionalInformationBlock:(AreaStoreInfoRequestBlock )areaStoreInfoBlock;
/**
 根据门店id去更新门店信息。

 @param areaStoreInfoBlock <#areaStoreInfoBlock description#>
 */
- (void)updateareaStoreInfoBlock:(AreaStoreInfoRequestBlock )areaStoreInfoBlock;

- (void)updateRegionalInformationBlock:(AreaStoreInfoRequestBlock )areaStoreInfoBlock;


@end
