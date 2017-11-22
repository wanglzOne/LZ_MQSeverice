//
//  BaseManger.h
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks+Foundation+.h"

void CallSuccessOnMainQueue(CommonVoidBlock success);

void CallFailureOnMainQueueWithError(CommonErrorBlock failure, NSError* error);

@interface BaseManger : NSObject

@end
