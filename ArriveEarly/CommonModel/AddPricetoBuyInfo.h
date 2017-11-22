//
//  AddPricetoBuyInfo.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>


///加价购配置model
@interface AddPricetoBuyConfigInfo : NSObject
@property (nonatomic, copy) NSString *tagId;

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) NSString *moreSort;



@property (nonatomic, copy) NSString *tagParentId;
@property (nonatomic, copy) NSString *configId;



@end

///超值加价购model
@interface AddPricetoBuyInfo : NSObject

@property (nonatomic, copy) NSString *addedUser;
//门店区域id
@property (nonatomic, copy) NSString *moreAreaId;

@property (nonatomic, copy) NSString *moreId;

@property (nonatomic, copy) NSString *moreName;

//加价购 价格
@property (nonatomic, assign) CGFloat morePrice;
//加价购份数 点的
@property (nonatomic, assign) int productCount;

@property (nonatomic, assign) long long noMoreTime;

@property (nonatomic, copy) NSString* productId;


//加价购 所属区标识
@property (nonatomic, copy) NSString *moreTagId;

///tags
@property (nonatomic, strong) AddPricetoBuyConfigInfo* configInfo;

@property (nonatomic, strong) ProductModel* productInfo;



@end
