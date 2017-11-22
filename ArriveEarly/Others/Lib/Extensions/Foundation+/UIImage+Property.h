//
//  UIImage+Property.h
//  IDoerTW
//
//  Created by iosdev on 16/2/25.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIImageSourceType) {
    /**
     *  未知
     */
    UIImageSourceTypeNormal = 0,
    /**
     *  拍照获得
     */
    UIImageSourceTypeTakingPicture,
    /**
     *  相册选择获得
     */
    UIImageSourceTypePhotosLibrary,
};

@interface UIImage (Property)

/**
 *  为了记录照片来源而 创建的属性
 */
@property (nonatomic, assign) UIImageSourceType imageSourceType;

/**
 *  image 是否添加了时间水印
 */
@property (nonatomic, assign) BOOL isWatermarkForTime;


@end
