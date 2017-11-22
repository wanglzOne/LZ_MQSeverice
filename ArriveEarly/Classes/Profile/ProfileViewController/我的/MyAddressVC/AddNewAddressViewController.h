//
//  AddNewAddressViewController.h
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Adress_Info.h"

#import "BaseSettingViewController.h"

typedef enum : NSUInteger {
    AddNewAddressShowType_Add,
    AddNewAddressShowType_Edite,
} AddNewAddressShowType;


/**
 添加地址  编辑地址
 */
@interface AddNewAddressViewController : BaseSettingViewController
@property (nonatomic , strong) Adress_Info *addressInfo;
@property (nonatomic , assign) AddNewAddressShowType showType;

@end
