//
//  CommentModel.h
//  ArriveEarly
//
//  Created by m on 2016/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface CommentModel : NSObject

@property (nonatomic ,strong)User *user;

@property (nonatomic ,strong)NSString *evaContent;
@property (nonatomic ,strong)NSString *evaId;//评论ID
@property (nonatomic ,strong)NSString *evaTitle;
@property (nonatomic ,strong)NSString *evaUserId;
@property (nonatomic ,strong)NSString *evaProductId;

@property (nonatomic ,assign)double evaScore;
@property (nonatomic ,assign)long long createTime;
@property (nonatomic ,assign) BOOL isAnonymous;
@end

@interface User : NSObject

@property (nonatomic ,strong)NSString *url;

@end
