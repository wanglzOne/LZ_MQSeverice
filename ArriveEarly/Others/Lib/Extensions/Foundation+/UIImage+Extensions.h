//
//  UIImage+Extensions.h
//  IDoerTW
//
//  Created by iosdev on 16/3/7.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)
- (UIImage*)setCornerRadius:(CGFloat)cornerRadiu viewSize:(CGSize)viewSize;

+ (NSString *)base64StringforImageJPGData:(NSData *)imageData;
- (NSString *) base64String;
- (UIImage *) getImageforBase64String: (NSString *) imgSrc;
@end
