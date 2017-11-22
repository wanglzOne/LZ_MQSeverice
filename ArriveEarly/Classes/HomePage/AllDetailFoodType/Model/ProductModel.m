//
//  ProductModel.m
//  ArriveEarly
//
//  Created by m on 2016/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ProductModel.h"

@implementation lableKvModel

@end

@implementation productClassModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"id_class" : @"id"};
}

@end
@implementation  ProductImageInfo
@end
@implementation ProductModel

+ (instancetype)special_yy_modelWithDictionary:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]] &&  dict != (id)kCFNull && [dict[@"productInfo"] isKindOfClass:[NSDictionary class]] && dict[@"productInfo"]  != (id)kCFNull) {
        ProductModel *model = [ProductModel yy_modelWithDictionary:dict[@"productInfo"]];
        if (dict[@"activityPrice"] != (id)kCFNull) {
            model.activityPrice = [dict[@"activityPrice"] doubleValue];
        }
        if (dict[@"apId"] != (id)kCFNull) {
            model.isActivity = [dict[@"apId"] intValue];
        }
        if (!model.productId) {
            model.productId = dict[@"productId"];
        }
        //
        
        if ([dict[@"proImageList"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *mImages = [[NSMutableArray alloc] init];
            for (NSDictionary *imgDict in dict[@"proImageList"]) {
                if ([imgDict isKindOfClass:[NSDictionary class]])
                {
                    ProductImageInfo *info = [ProductImageInfo yy_modelWithDictionary:imgDict];
                    [mImages addObject:info];
                }
            }
            model.productImage = mImages;
        }
        //model.mainCoverImageUrl = @"";
//        for (ProductImageInfo *imgInfo in model.productImage) {
//            model.mainCoverImageUrl = imgInfo.image_url;
//            if (imgInfo.is_cover == 1) {
//                model.mainCoverImageUrl = imgInfo.image_url;
//            }
//        }
        
        return model;
    }
    return nil;
}
+ (instancetype)findById_special_yy_modelWithDictionary:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]] &&  dict != (id)kCFNull) {
        ProductModel *model = [ProductModel yy_modelWithDictionary:dict];
        if ([dict[@"activityProducts"] isKindOfClass:[NSDictionary class]] && dict[@"activityProducts"] != (id)kCFNull) {
            if (dict[@"activityProducts"][@"apId"] != (id)kCFNull) {
                model.isActivity = [dict[@"activityProducts"][@"apId"] intValue];
            }
            if (dict[@"activityProducts"][@"activityPrice"] != (id)kCFNull && !model.activityPrice) {
                model.activityPrice = [dict[@"activityProducts"][@"activityPrice"] doubleValue];
            }
        }
        return model;
    }
    return nil;
}


- (NSString *)mainCoverImageUrl
{
    if (!_mainCoverImageUrl) {
        for (ProductImageInfo *imgInfo in self.productImage) {
            if (imgInfo.is_cover == 1) {
                _mainCoverImageUrl = imgInfo.image_url;
            }
        }
    }
    return _mainCoverImageUrl;
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productId" : @"id"};
}

- (double)newPrice
{
    if (self.isActivity) {
        return self.activityPrice;
    }
    return self.price;
}

- (NSString *)showSaleand
{
    NSString*str  = nil;
    for (lableKvModel *m in self.lableKvs) {
        NSDictionary *dic = [m yy_modelToJSONObject];
        if ([[str stringByAppendingString:dic[@"value"]] isKindOfClass:[NSString class]] && [str stringByAppendingString:dic[@"value"]] != (id)kCFNull) {
            str = [NSString stringWithFormat:@"口感 %@",[str stringByAppendingString:dic[@"value"]]];
        }
    }
    NSString *sale = [NSString stringWithFormat:@"销量 %ld",self.saleCount];
    if (str) {
        return [NSString stringWithFormat:@"口感 %@    销量 %@",str,sale];
    }
    return sale;
}

@end
