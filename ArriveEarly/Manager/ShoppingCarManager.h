//
//  ShoppingCarManager.h
//  ArriveEarly
//
//  Created by m on 2016/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 保存购物车本地数据
 */
@interface ShoppingCarManager : NSObject
@property  (nonatomic, assign) double totalPrice;
@property (nonatomic, strong, readonly) NSMutableArray <ProductModel *>*productData;

+(instancetype)sharedManager;

-(void)saveLocationData:(NSMutableArray*)data;
-(id)getLcationData;
-(void)removeLocationData;

///获得 指定活动 商品加入购物车的份数。
- (int)getCountProductConfig:(ActivityConfigModel *)config;

- (BOOL)saveProduct:(id)product andChangeAdditionalCopies:(int)additionalCopie andProductConfig:(ActivityConfigModel *)config;

- (void)saveProduct:(id)product andChangeAdditionalCopies:(int)additionalCopie andProductConfig:(ActivityConfigModel *)config onComplete:(void(^)(BOOL isFlag, NSError *error))complete;


@end
