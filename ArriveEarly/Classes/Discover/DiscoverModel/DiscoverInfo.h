//
//  DiscoverInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/11.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverInfoImageInfo : NSObject
@property (nonatomic, copy) NSString *id_info;
@property (nonatomic ,copy) NSString *imageUrl;
@property (nonatomic ,copy) NSString *foundId;
@property (nonatomic ,assign) int is_cover;

@end

@protocol DiscoverInfoImageInfo;

@interface DiscoverInfo : NSObject

@property (nonatomic, copy) NSString *id_discover;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *createAuthor;
@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *desc;


@property (nonatomic, strong) NSArray <DiscoverInfoImageInfo>*foundImage;



@end
