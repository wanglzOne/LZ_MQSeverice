//
//  NSString+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/14.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import <UIKit/UIKit.h>

@interface NSString (Foundation_)

#pragma Hash
- (NSString*)MD5String;
- (NSString*) sha1;
#pragma Utils
/// Trimming the string with
///过滤开始和结束的 空格 符号。
- (NSString*)stringByTrimming;
/**
 *  去掉首尾的空格之后 字符串是否是@“”
 *
 *  @return <#return value description#>
 */
- (BOOL)isNotNilOrWhiteSpaceString;
/**
 *  验证车牌号
 *
 *  @return <#return value description#>
 */

//车身颜色
-(BOOL) isCorrectCarColor;
//金额
-(BOOL) isCorrectMoney;
//司机名字
-(BOOL) isCorrectDirverName;

- (BOOL)is_car_regx;

/**
 *  邮箱
 *
 *  @return <#return value description#>
 */
- (BOOL)isValidEmail;

/**
 *  中国电话号码
 *
 *  @return <#return value description#>
 */
- (BOOL)isChineseCellPhoneNumber;
/**
 *  判断是否是整数（包括 + - 都可以）
 *
 *  @return <#return value description#>
 */
- (BOOL)isAnInteger;
/**
 *  判断 小数的
 *
 *  @return <#return value description#>
 */
- (BOOL)isAnFloat;
/**
 *  限制小数的位数
 *
 *  @param digit 最大的小数位数   0-digit位小数
 *
 *  @return <#return value description#>
 */
- (BOOL)isAnFloatWithDigits:(int)digit;
#pragma mark - URL
- (NSString*)URLEncodeString;

- (NSString*)urlQueryStringValueEncodeUsingUTF8Encoding;
- (NSString*)urlQueryStringValueEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString*)urlQueryStringValueDecodeUsingUTF8Encoding;
- (NSString*)urlQueryStringValueDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString*)appendQueryStringKey:(NSString*)key withValue:(id)value;
- (NSString*)appendQueryStringKey:(NSString*)key withStringValue:(NSString*)value;

- (NSDictionary*)queryStringToDictionary;

/**
 *  判断一个字符串是否是纯数字
 *
 *  @param string
 *
 *  @return is-yes  no
 */
- (BOOL)isAllNum:(NSString*)string;
- (BOOL)isAllNum;
- (BOOL)isAllLetter;
/**
 *  根据文字 内容、以及字号大小计算出文字的 Size
 */


+ (NSString *)objToJSONStr2:(id)obj;

+ (NSString *)objToJSONStr:(id)obj;

- (NSString *)nilReplace;
///查看 是否包 含某 一个字符串
- (BOOL)myContainsString:(NSString*)other;
/**
 *  给 label 这些 设置 某一部分 字的颜色     self 必须要包含着colorStr
 *
 *  @param strColor <#strColor description#>
 *  @param colorStr <#colorStr description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableAttributedString*)setStrColor:(UIColor*)strColor colorStr:(NSString*)colorStr;

/**
 *  将 换行符 /r/r  替换为 /r
 *
 *  @return <#return value description#>
 */
- (NSString *)getASingleNewline;

+ (NSString *)deviceIPAddress;
/// 判断
- (BOOL)isInputNormalString;

@end
