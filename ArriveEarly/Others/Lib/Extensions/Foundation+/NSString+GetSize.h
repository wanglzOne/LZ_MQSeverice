//
//  NSString+GetSize.h
//  SalesCheck
//
//  Created by iosdev on 15/7/15.
//  Copyright (c) 2015年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetSize)
/**
  依据text 获得 在规定尺寸的范围的  CGSize
 */
+ (CGSize)getSizelabelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;
/**
 *  给一个字符串插入 字符   （电话号码）
 *
 *  @param markStr <#markStr description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)insertMark:(NSString*)markStr;
/**
 *  根据 文字内容 返回 一个CGSize
 *
 *  @param fontSize <#fontSize description#>
 *  @param maxSize  <#maxSize description#>
 *
 *  @return <#return value description#>
 */
- (CGSize)sizeOfTextFont:(CGFloat)fontSize maxSize:(CGSize)maxSize;
@end
