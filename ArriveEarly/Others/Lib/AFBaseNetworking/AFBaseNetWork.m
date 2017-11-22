//
//  AFBaseNetWork.m
//  ETPassenger
//
//  Created by  YiDaChuXing on 16/6/30.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "AFBaseNetWork.h"

#define kServer_HttpTimeOut 15

@interface AFBaseNetWork ()
@property (nonatomic, strong) NSMutableDictionary *blockDict;
@end

@implementation AFBaseNetWork

@synthesize manager;


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
        manager = [AFHTTPSessionManager manager];
        //传入的json格式数据
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:kServer_HttpTimeOut];
        //默认返回JSON类型（可以不写）
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //设置返回类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"Type-Text",@"text/plain", nil];
    }
    return self;
}
- (id)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
        [manager.requestSerializer setTimeoutInterval:kServer_HttpTimeOut];
    }
    return self;
}
- (void)post:(NSString *)url
     params:(NSDictionary *)params
    progress:(NSProgressBlock)uploadProgressBlock
onCompletion:(CommonBlockDictionary)completionCallback
    onError:(CommonBlockError)errorCallback
{
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        }
               completionCallback(dict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(error);
    }];
}
- (void)post:(NSString *)url
      params:(NSDictionary *)params
    progress:(NSProgressBlock)uploadProgressBlock
responseObject:(CommonBlockCompletion)completionCallback
     onError:(CommonBlockError)errorCallback
{

    
    //    params = [params escapeUnicodeDict];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = responseObject;
        if ([url containsString:@"queryMore"]) {
            DLog(@"获取加价购 data ：-->> \n%@",responseObject);
        }
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            
            data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        if (completionCallback) {
            completionCallback(data);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorCallback) {
            errorCallback(error);
        }
    }];
}
- (void)get:(NSString *)url
     params:(NSDictionary *)params
responseObject:(CommonBlockCompletion)completionCallback
    onError:(CommonBlockError)errorCallback
{
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionCallback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(error);
    }];
}

- (void)get:(NSString *)url
     params:(NSDictionary *)params
onCompletion:(CommonBlockDictionary)completionCallback
    onError:(CommonBlockError)errorCallback
{
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        if ([dict isKindOfClass:[NSDictionary class]]) {
            completionCallback(dict);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"数据错误" code:-1 userInfo:nil];
            errorCallback(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(error);
    }];
}

- (void)upImage:(NSString *)url
         params:(NSDictionary *)params
         images:(NSArray *)imageArray
       progress:(NSProgressBlock)uploadProgressBlock
   onCompletion:(CommonBlockDictionary)completionCallback
        onError:(CommonBlockError)errorCallback
{
    
    NSMutableArray* compressedArray = [NSMutableArray array];
    dispatch_apply(imageArray.count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        UIImage* image = [imageArray objectAtIndex:index];
        NSData*data = UIImageJPEGRepresentation(image, 1.0);
        if (data) {
            [compressedArray addObject:data];
        }
    });
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 1;
        for (NSData* imageData in compressedArray) {
            NSString* str = [NSString stringWithFormat:@"%d.jpeg", i];
            [formData appendPartWithFileData:imageData
                                        name:str
                                    fileName:str
                                    mimeType:@"image/jpeg"];
            i++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        }
        if ([dict isKindOfClass:[NSDictionary class]]) {
            completionCallback(dict);
        }
        else
        {
            NSError *error = [NSError errorWithDomain:@"数据错误" code:-1 userInfo:nil];
            errorCallback(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorCallback(error);
    }];
}



@end
