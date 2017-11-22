//
//  MyAddressViewController.h
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

#import "Adress_Info.h"

typedef enum : NSUInteger {
    AddressShowTypeChoose,
    AddressShowTypeManagement,
} AddressShowType;



typedef void(^ChooseAddressBlock)(NSArray<Adress_Info*>*adresss);


/**
 我的地址  选择收获地址
 */
@interface MyAddressViewController : BaseSettingViewController

@property (nonatomic, assign) AddressShowType showType;

- (void)setChooiceAddressOnCompleteBlock:(ChooseAddressBlock)block;

@end
