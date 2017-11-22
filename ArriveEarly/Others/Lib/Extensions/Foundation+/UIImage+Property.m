//
//  UIImage+Property.m
//  IDoerTW
//
//  Created by iosdev on 16/2/25.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "UIImage+Property.h"

#import <objc/runtime.h>

@implementation UIImage (Property)

//static 是静态，只分配一次内存空间，再次执行的时候也不会再分配新的内存空间.
//const 是常量，意思是和圆周率（Pi）一样，3.14常量一样，初始化之后就不可改。

//http://blog.163.com/pei_hua100/blog/static/805697592009550281616/

//const void *key  三种声明方式
//static const char* const KImageSourceType   有什么区别
static const char* KImageSourceType = "ImageSourceType";

static const char* KWatermarkForTime = "WatermarkForTime";


//static const void* KImageSourceType = &KImageSourceType;
//
//static char KImageSourceType;//&kKDTActionHandlerTapBlockKey

- (UIImageSourceType)imageSourceType
{
    return [objc_getAssociatedObject(self, KImageSourceType) intValue];
}

- (void)setImageSourceType:(UIImageSourceType)imageSourceType
{
    objc_setAssociatedObject(self, KImageSourceType, [NSNumber numberWithInt:imageSourceType], OBJC_ASSOCIATION_ASSIGN);
}


- (BOOL)isWatermarkForTime
{
    return [objc_getAssociatedObject(self, KWatermarkForTime) boolValue];
}

- (void)setIsWatermarkForTime:(BOOL)isWatermarkForTime
{
    objc_setAssociatedObject(self, KWatermarkForTime, [NSNumber numberWithBool:isWatermarkForTime], OBJC_ASSOCIATION_ASSIGN);
}

@end
