//
//  AFBaseNetWork.h
//  ETPassenger
//
//  Created by  YiDaChuXing on 16/6/30.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>


typedef void(^CommonBlockCompletion)(id responseObject);
typedef void(^CommonBlockDictionary)(NSDictionary *dic);
typedef void(^CommonBlockError)(NSError *error);

typedef void (^NSProgressBlock)(NSProgress *uploadProgress);

@interface AFBaseNetWork : NSObject

//AFNetworking
@property (nonatomic, readonly, getter = manager) AFHTTPSessionManager *manager;
- (id)initWithBaseUrl:(NSString *)baseUrl;
///返回字典结果
- (void)post:(NSString *)url
      params:(NSDictionary *)params
    progress:(NSProgressBlock)uploadProgressBlock
onCompletion:(CommonBlockDictionary)completionCallback
     onError:(CommonBlockError)errorCallback;
///返回 id 对象结果
- (void)post:(NSString *)url
      params:(NSDictionary *)params
    progress:(NSProgressBlock)uploadProgressBlock
responseObject:(CommonBlockCompletion)completionCallback
     onError:(CommonBlockError)errorCallback;

///处理GET请求  返回 id 对象结果
- (void)get:(NSString *)url
     params:(NSDictionary *)params
responseObject:(CommonBlockCompletion)completionCallback
    onError:(CommonBlockError)errorCallback;
/// 返回经过解析的 数据字典
- (void)get:(NSString *)url
     params:(NSDictionary *)params
onCompletion:(CommonBlockDictionary)completionCallback
    onError:(CommonBlockError)errorCallback;

///上传图片
- (void)upImage:(NSString *)url
         params:(NSDictionary *)params
         images:(NSArray *)imageArray
       progress:(NSProgressBlock)uploadProgressBlock
   onCompletion:(CommonBlockDictionary)completionCallback
        onError:(CommonBlockError)errorCallback;
@end
