//
//  NSString+Foundation+.m
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/14.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#import "NSString+Foundation+.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation NSString (Foundation_)

#pragma Hash
- (NSString*)MD5String
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    const char* bytes = [self UTF8String];
    CC_MD5(bytes, (CC_LONG)strlen(bytes), result);
    return [NSString stringWithFormat:
                         @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                     result[0], result[1], result[2], result[3], result[4],
                     result[5], result[6], result[7], result[8], result[9],
                     result[10], result[11], result[12], result[13], result[14], result[15]];
}
- (NSString*)sha1
{
    const char* cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    int length = (int)data.length;
    CC_SHA1(data.bytes, length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

#pragma Utils
- (NSString*)stringByTrimming
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//司机名字
-(BOOL) isCorrectDirverName{
    
    NSString * regex=@"^[\u4e00-\u9fa5]{1,10}$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}
//车身颜色
-(BOOL) isCorrectCarColor{
    
     NSString * regex=@"[a-zA-Z\\u4e00-\\u9fa5]{1,10}$";
    NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}
//金额判断
-(BOOL) isCorrectMoney{

        NSString * regex=@"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
        NSPredicate * pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [pred evaluateWithObject:self];
}
//过滤掉特殊符号
- (BOOL)isNotNilOrWhiteSpaceString
{
    return [self stringByTrimming].length > 0;
}
- (BOOL)is_car_regx
{
    NSString* regex = @"^[\\u4E00-\\u9FA5][a-zA-z][\\da-zA-Z]{5}$"; //only keep the basic rule on local client
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
- (BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString* stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString* laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString* emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isChineseCellPhoneNumber
{
    //    NSString *regex = @"^((13[0-9])|(145)|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString* regex = @"^(1[0-9][0-9])\\d{8}$"; //only keep the basic rule on local client
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isAnInteger
{
    /*
     ^[1-9]\d*$　 　 //匹配正整数
     ^-[1-9]\d*$ 　 //匹配负整数
     */
    NSString* regex = @"^-?[1-9]\\d*$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isAnFloat
{
    NSString* regex = @"^-?([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|0?\\.0+|0)$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
- (BOOL)isAnFloatWithDigits:(int)digit
{
    NSString* regex = [NSString stringWithFormat:@"^-?\\d*(?:\\.\\d{0,%d})?$", digit];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}
#pragma mark - URL
- (NSString*)URLEncodeString
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)self;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

- (NSString*)urlQueryStringValueEncodeUsingUTF8Encoding
{
    return [self urlQueryStringValueEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)urlQueryStringValueEncodeUsingEncoding:(NSStringEncoding)encoding
{
    CFStringEncoding stringEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
        (CFStringRef)self,
        NULL,
        (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
        stringEncoding);
    return (NSString*)CFBridgingRelease(stringRef);
}

- (NSString*)urlQueryStringValueDecodeUsingUTF8Encoding
{
    return [self urlQueryStringValueDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)urlQueryStringValueDecodeUsingEncoding:(NSStringEncoding)encoding
{
    CFStringEncoding stringEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef stringRef = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
        (CFStringRef)self,
        CFSTR(""),
        stringEncoding);
    return (NSString*)CFBridgingRelease(stringRef);
}

- (NSString*)appendQueryStringKey:(NSString*)key withValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [self appendQueryStringKey:key withStringValue:[(NSNumber*)value stringValue]];
    }

    if ([value isKindOfClass:[NSString class]]) {
        return [self appendQueryStringKey:key withStringValue:value];
    }

    return nil;
}

- (NSString*)appendQueryStringKey:(NSString*)key withStringValue:(NSString*)value
{
    if ([self rangeOfString:@"?"].length == 0) {
        return [NSString stringWithFormat:@"%@?%@=%@", [self stringByTrimming], key, [value urlQueryStringValueEncodeUsingUTF8Encoding]];
    }
    else {
        if ([self rangeOfString:@"&"].location == (self.length - 1)) {
            return [NSString stringWithFormat:@"%@%@=%@", [self stringByTrimming], key, [value urlQueryStringValueEncodeUsingUTF8Encoding]];
        }
        else {
            return [NSString stringWithFormat:@"%@&%@=%@", [self stringByTrimming], key, [value urlQueryStringValueEncodeUsingUTF8Encoding]];
        }
    }
}

- (NSDictionary*)queryStringToDictionary
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    for (NSString* param in [self componentsSeparatedByString:@"&"]) {
        NSArray* elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2) {
            continue;
        }
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }

    return params;
}

- (BOOL)isAllNum:(NSString*)string
{
    unichar c;
    for (int i = 0; i < string.length; i++) {
        c = [string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)isAllNum
{
    unichar c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isAllLetter
{
    unichar c;
    for (int i = 0; i < self.length; i++) {
        c = [self characterAtIndex:i];
        if (!isalpha(c)) {
            return NO;
        }
    }
    return YES;
}

+ (NSString*)objToJSONStr:(id)obj
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\\\u" withString:@"\\u"];
    return jsonStr;
}

+ (NSString*)objToJSONStr2:(id)obj
{
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\\\u" withString:@"\\u"];
    return jsonStr;
}

- (NSString*)nilReplace
{
    if (self && ![self isEqualToString:@""]) {
        return self;
    }
    return @"";
}

- (BOOL)myContainsString:(NSString*)other
{
    NSRange range = [self rangeOfString:other];
    return (range.length != 0) ? YES : NO;
}

- (NSMutableAttributedString*)setStrColor:(UIColor*)strColor colorStr:(NSString*)colorStr
{
    NSString* titleStr = self;
//    if (![self myContainsString:colorStr]) {
//        titleStr = [self stringByAppendingString:colorStr];
//    }
    NSMutableAttributedString* noteStr = [[NSMutableAttributedString alloc] initWithString:titleStr ? titleStr : @""];
    NSInteger location = [[noteStr string] rangeOfString:colorStr].location;
    NSRange redRange = NSMakeRange(location, colorStr.length);
    
    [noteStr addAttribute:NSForegroundColorAttributeName value:strColor range:redRange];
    /*
     NSMutableAttributedString* noteStr = [[listInfo.title copy] setStrColor:[UIColor redColor] colorStr:@"*"];
     [baseView.title setAttributedText:noteStr];
     */
    return noteStr;
}

- (NSString*)getASingleNewline
{
    NSString* ddd = [self stringByReplacingOccurrencesOfString:@"\r\r" withString:@"\r"];
    if ([ddd myContainsString:@"\r\r"]) {
        [self getASingleNewline];
    }
    return ddd;
}

+ (NSString *)deviceIPAddress
{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                //pdp_ip0  en0
                //
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"lo0"]  || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    NSLog(@"手机的IP是：%@", address);
    
    return address;
}

/*
 * 字母、数字、中文正则判断（包括空格）【注意3】
 */
- (BOOL)isInputNormalString {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
