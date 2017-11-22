//
//  ShoppingCarManager.m
//  ArriveEarly
//
//  Created by m on 2016/11/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ShoppingCarManager.h"
#import "ProductTypeModel.h"

@interface ShoppingCarManager ()

@property (nonatomic, strong) NSMutableArray <ProductModel *>*productData;

@end

@implementation ShoppingCarManager

+(instancetype)sharedManager
{
    static id _sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    
    return _sharedLocationManager;
}

-(void)saveLocationData:(NSMutableArray*)data
{
    NSString *filename= [ShoppingCarManager shopingDataFilePath];
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL iscreatSuccess = [fm createFileAtPath:filename contents:nil attributes:nil];
    NSMutableArray *saveDataArray = [[NSMutableArray alloc]init];
    ProductModel *model;
    for (model in data) {
        if ([model isKindOfClass:[NSString class]]) {
            [saveDataArray addObject:model];
        }else if ([model isKindOfClass:[ProductModel class]])
        {
            [saveDataArray addObject:[model yy_modelToJSONString]];
        }
    }
    self.productData = data;
    BOOL flag = [saveDataArray writeToFile:filename atomically:YES];
    NSLog(@"saveDataArray isYES:%d - iscreatSuccess:%d",flag,iscreatSuccess);
    
}
-(id)getLcationData{
    NSString *filename= [ShoppingCarManager shopingDataFilePath];
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filename];
    NSMutableArray *backData = [[NSMutableArray alloc]init];
    ProductModel*model;
    for (id str in data) {
        model = [ProductModel yy_modelWithJSON:str];
        [backData addObject:model];
    }
//    
//    [EncapsulationAFBaseNet updateProductInfoForProducts:data onCommonBlockCompletion:^(id responseObject, NSError *error) {
//        if (error) {
//            return ;
//        }
//        if ([responseObject[@"responseData"] isKindOfClass:[NSArray class]]) {
//            NSMutableArray *newData = [[NSMutableArray alloc]init];
//            for (NSDictionary *dict in responseObject[@"responseData"]) {
//                ProductModel *newModel = [ProductModel yy_modelWithDictionary:dict];
//                [newData addObject:newModel];
//            }
//            //将数据价格更新
//            for (int i =0 ; i  < data.count; i++) {
//                ProductModel *oldModel = data[i];
//                ProductModel *nowModel = nil;
//                for (int j = 0; j < newData.count; j++) {
//                    ProductModel *mmodel = newData[j];
//                    if (oldModel.productId == mmodel.productId && oldModel.isActivity == mmodel.isActivity ) {
//                        nowModel = mmodel;
//                        break;
//                    }
//                }
//                if (nowModel) {
//                    oldModel.price = nowModel.price;
//                    oldModel.activityPrice = nowModel.activityPrice;
//                }
//            }
//            [self saveLocationData:newData];
//            
//        }
//    }];

    
    NSLog(@"backData is:%@",data);
    self.productData = backData;
    return backData;
}
-(void)removeLocationData
{
    //        退出删除plist文件
    BOOL result = NO;
    NSString *filename= [ShoppingCarManager shopingDataFilePath];
    NSError * error = nil;
    result = [[NSFileManager defaultManager] removeItemAtPath:filename error:&error];
    if (error)
    {
        self.productData = nil;
        NSLog(@"删除失败：%@",[error localizedDescription]);
    }
    else{
        NSLog(@"删除成功！！！");
    }
    
    
}
///使用block返回
- (BOOL)saveProduct:(id)product andChangeAdditionalCopies:(int)additionalCopie andProductConfig:(ActivityConfigModel *)config
{
    if (additionalCopie == 0) {
        return NO;
    }
    
    ///超过最大的购买份数
    if (config && additionalCopie>0 && config.maxBuyCount != 0  && [self getCountProductConfig:config] >= config.maxBuyCount) {
        return NO;
    }
    
    
    ProductModel *productModel = nil;
    if ([product isKindOfClass:[NSDictionary class]]) {
        productModel = [ProductModel yy_modelWithDictionary:product];
    }
    if ([product isKindOfClass:[ProductModel class]]) {
        productModel = [product yy_modelCopy];
    }
    
    if (productModel.productId) {
        BOOL isNew = YES;
        for (ProductModel *model in self.productData) {
            if ([model.productId isEqualToString:productModel.productId] && model.isActivity == productModel.isActivity) {
                isNew = NO;
                model.shopCount =  model.shopCount + additionalCopie;
                break;
            }
        }
        if (isNew) {
            if (config && productModel.isActivity) {
                productModel.productName = [NSString stringWithFormat:@"%@[%@]",productModel.productName,config.activityName];
                productModel.activityConfigID = config.activityId;
                productModel.activityName = config.activityName;
            }
            productModel.shopCount =  productModel.shopCount + additionalCopie;
            productModel.activityConfigModel = config;
            [self.productData addObject:productModel];
            
        }
    }
    NSArray *copyproductData = [self.productData mutableCopy];
    for (ProductModel *pro in copyproductData) {
        if (pro.shopCount <= 0) {
            [self.productData removeObject:pro];
        }
    }
    [self saveLocationData:self.productData];
    return YES;
}
- (void)saveProduct:(id)product andChangeAdditionalCopies:(int)additionalCopie andProductConfig:(ActivityConfigModel *)config onComplete:(void(^)(BOOL isFlag, NSError *error))complete
{
    if ([self saveProduct:product andChangeAdditionalCopies:additionalCopie andProductConfig:config]) {
        if (complete) {
            complete(YES,nil);
        }
    }else
    {
        if (complete) {
            complete(NO,[NSError errorWithDomain:[NSString stringWithFormat:@"%@ 最多可以购买 %d 份",config.activityName,config.maxBuyCount] code:-1 userInfo:nil]);
        }
    }
}
- (int)getCountProductConfig:(ActivityConfigModel *)config
{
    int count = 0;
    for (ProductModel *model in self.productData) {
        if (model.activityConfigModel.activityId == config.activityId) {
            count = count + model.shopCount;
        }
    }
    return count;
}
- (double)totalPrice
{
    double money = 0.0;
    for (ProductModel *model in self.productData) {
        if (model.isActivity) {
            money += model.activityPrice * model.shopCount;
        }else{
            money += model.price * model.shopCount;
        }
    }
    return money;
}

#pragma mark - 文件路径
+ (NSString *)shopingDataFilePath
{
    return [[self getPaath] stringByAppendingPathComponent:@"shopingData.plist"];
}
+ (NSString *)getPaath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    return [paths objectAtIndex:0];
}

- (NSMutableArray <ProductModel *>*)productData
{
    if (!_productData) {
        _productData = [self getLcationData];
    }
    return _productData;
}

@end
