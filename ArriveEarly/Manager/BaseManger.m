//
//  BaseManger.m
//  EasyDriver
//
//  Created by  YiDaChuXing on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import "BaseManger.h"


void CallSuccessOnMainQueue(CommonVoidBlock success) {
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (success) {
                success();
            }
            
        });
    }
}

void CallFailureOnMainQueueWithError(CommonErrorBlock failure, NSError *error) {
    if (failure)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            failure(error);
        });
    }
}
@implementation BaseManger

@end
