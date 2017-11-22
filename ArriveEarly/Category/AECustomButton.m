//
//  AECustomButton.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AECustomButton.h"

@implementation AECustomButton

-(CGRect) titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleWith = CGRectGetWidth(contentRect);
   
    return CGRectMake(0,CGRectGetHeight(contentRect) - ButtonTitleHeight, titleWith, ButtonTitleHeight);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
  CGFloat imageHeight = CGRectGetWidth(contentRect) -ButtonMargion - ButtonTitleHeight;
    CGFloat imageWith = imageHeight;
    CGFloat imageX = CGRectGetWidth(contentRect) * 0.5;
    return CGRectMake(imageX - imageWith /2.0, 0, imageWith , imageHeight);
}

@end
