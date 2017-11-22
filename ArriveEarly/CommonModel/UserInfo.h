//
//  UserInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
///判断新老用户  0:新用户   1老用户
@property (nonatomic, assign) NSInteger userState;
///是否是老用户
@property (nonatomic, assign) BOOL isTheoldUser;

@property (nonatomic, copy) NSString *defaultAddressID;

@property (nonatomic, copy) NSString *identityId;
@property (nonatomic, copy) NSString *identityImgUrl;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *userFlag;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userProperty;

@property (nonatomic, copy) NSString *userType;


@end


@interface UserLoginData : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *reqIp;
@property (nonatomic, copy) NSString *pushId;
@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, copy) NSString *password;
@end

