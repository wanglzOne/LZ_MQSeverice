//
//  ProductModel.h
//  ArriveEarly
//
//  Created by m on 2016/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProductType) {
    ProductTypeNormal = 0, ///正常价格商品
    ProductTypeActivity = 1, /// 活动价格商品
    ProductTypeAddPriceBuy = 2, /// 加价购商品
};

typedef NS_ENUM(NSInteger, ProductState) {
    ProductState_waiteToShelves = 0, ///等待上架
    ProductState_shelved = 1, /// 已上架
    ProductState_delete = 2, /// 删除
};

@interface lableKvModel : NSObject

@property (nonatomic ,assign) int key;
@property (nonatomic ,strong)NSString *value;

@end

@protocol lableKvModel;

@interface productClassModel : NSObject
@property (nonatomic ,strong)NSString *cityId;
@property (nonatomic ,strong)NSString *classId;
@property (nonatomic ,strong)NSString *className;
@property (nonatomic ,strong)NSString *classPrentId;
@property (nonatomic ,strong)NSString *classSort;
@property (nonatomic ,strong)NSString *createTime;
@property (nonatomic ,strong)NSString *creator;
@property (nonatomic ,strong)NSString *flag;
@property (nonatomic ,strong)NSString *id_class;
@property (nonatomic ,strong)NSString *imgUrl;
@property (nonatomic ,strong)NSString *note;

@end

@interface ProductImageInfo : NSObject

@property (nonatomic ,copy) NSString *image_url;
@property (nonatomic ,assign) int is_cover;

@end

@protocol ProductImageInfo;
///0：正常价格   1：活动价  2：加价购
@interface ProductModel : NSObject

+ (instancetype)special_yy_modelWithDictionary:(NSDictionary *)dict;
+ (instancetype)findById_special_yy_modelWithDictionary:(NSDictionary *)dict;
/// 菜品状态，0-待上架；1-已上架；2-删除；
@property (nonatomic ,assign)int productState;

//@property (nonatomic ,copy)NSString * apId;
// isActivity  其实 就是 apid  传给服务器 用来判断 活动商品的
@property (nonatomic ,assign)int isActivity;// 1:是活动  0：不是
@property (nonatomic ,assign)int isNew;// 是否是新菜品 1:是  0：不是

@property (nonatomic, copy) NSString *mainCoverImageUrl;

@property (nonatomic, strong) NSArray <ProductImageInfo>*productImage;

@property (nonatomic, strong) NSString *activityName;

@property (nonatomic ,assign)double vipPrice;
@property (nonatomic ,assign)double price;
@property (nonatomic ,assign)double activityPrice;

@property (nonatomic ,assign)int count;

@property (nonatomic ,strong)NSString *productId;
@property (nonatomic ,strong)NSString *label;
@property (nonatomic ,strong)NSArray <lableKvModel>*lableKvs;

@property (nonatomic ,strong)productClassModel *productClass;
@property (nonatomic ,strong)NSString * productClassId;

///   p 单元格下面显示
@property (nonatomic ,copy)NSString * productIntroduction;
///  商品信息  在详情里面显示
@property (nonatomic ,copy)NSString * productDesc;
/// 一句话简介
@property (nonatomic ,copy)NSString * productMDesc;

@property (nonatomic ,strong)NSString * productHeadImgUrl;
@property (nonatomic ,strong)NSString * productName;

@property (nonatomic ,assign)NSInteger saleCount;

@property (nonatomic ,assign)NSInteger goodEvaCount;

/// 用于收藏页面
@property (nonatomic ,assign)  CGFloat goodEva;


///一个商品盒子费用
@property (nonatomic ,assign) double meelFee;

///自定义字段   加入购物车中的数量
@property (nonatomic ,assign)int shopCount;//加入购物车商品的数量
///自定义字段   加入购物车中的数量
@property (nonatomic ,copy) NSString *activityConfigID;

///自定义字段 这个 根据商品 类型 获取价格   如果是加价购的 就要取morePrice 加价购model配置
///只是在购物车 结算时候有用
@property (nonatomic ,assign)double newPrice;

///查询是否 被收藏。   0表示未查询    1表示未收藏     2表示已经收藏了        修改服务器 用户是否收藏这个菜品  传1取消收藏 传2表示收藏他
@property (nonatomic ,assign) int isCollection;

//自定义字段
///评价内容  在评价页面使用
@property (nonatomic ,strong)NSString * evaContent;
/// 评价星际
@property (nonatomic ,assign)int evaScore;



///用于记录最新存储/更新的时间  （秒）
@property (nonatomic ,assign)int saveTime;



@property (nonatomic ,strong) NSString * showSaleand;

@property (nonatomic) BOOL isOpen;// 满减的View

@property (nonatomic) BOOL isOpenNew;// 新菜品的View

////在做本地数据 购物车 存储的时候 赋值
@property (nonatomic ,strong) ActivityConfigModel * activityConfigModel;



@end



