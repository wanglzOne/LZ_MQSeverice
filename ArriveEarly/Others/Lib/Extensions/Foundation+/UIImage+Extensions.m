//
//  UIImage+Extensions.m
//  IDoerTW
//
//  Created by iosdev on 16/3/7.
//  Copyright © 2016年 iosdev. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

- (UIImage*)setCornerRadius:(CGFloat)cornerRadiu viewSize:(CGSize)viewSize
{
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);

    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewSize.width, viewSize.height) cornerRadius:cornerRadiu] addClip];

    [self drawInRect:CGRectMake(0, 0, viewSize.width, viewSize.height)];

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return image;
}
+ (NSString *)base64StringforImageJPGData:(NSData *)imageData
{
    NSString *mimeType = @"jpg";
    /*
     if ([self imageHasAlpha: image]) {
     imageData = UIImagePNGRepresentation(image);
     mimeType = @"image/png";
     } else {
     imageData = UIImageJPEGRepresentation(image, 1.0f);
     mimeType = @"image/jpeg";
     }
     */
    return [NSString stringWithFormat:@"%@,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}

- (NSString *) base64String
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    if ([self imageHasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"jpg";
    }
    /*
     if ([self imageHasAlpha: image]) {
     imageData = UIImagePNGRepresentation(image);
     mimeType = @"image/png";
     } else {
     imageData = UIImageJPEGRepresentation(image, 1.0f);
     mimeType = @"image/jpeg";
     }
     */
    return [NSString stringWithFormat:@"%@,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
    
}
- (BOOL) imageHasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
+ (BOOL) imageHasAlphaImage: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (UIImage *) getImageforBase64String: (NSString *) imgSrc
{
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    //data = [imgSrc dataUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}

@end
