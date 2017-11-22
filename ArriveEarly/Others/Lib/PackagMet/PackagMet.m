//
//  PackagMet.m
//  XiaoBuOutWork
//
//  Created by 陈彬 on 15-5-20.
//  Copyright (c) 2015年 com.eteamsun. All rights reserved.
//

#define kScreenSizes [UIScreen mainScreen].bounds.size

#import "PackagMet.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>

static PackagMet *_instance ;
@implementation PackagMet
- (void)dealloc
{
    DLogMethod();
}
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance ;
}

/**
 *  字体格式
 */
+ (void)initZTFont:(UILabel *)label
              numF:(NSInteger)numF
             color:(UIColor *)color
{
    label.font = [UIFont systemFontOfSize:numF];
    label.textColor = color;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
}
/**
 *  改变多个uilable 的字体格式
 *
 *  @param labAry UILabel数组
 *  @param numF   字号
 *  @param color  字体颜色
 */
+ (void)initZTFonts:(NSArray *)labAry
              numF:(NSInteger)numF
             color:(UIColor *)color
{
    for (UILabel * label in labAry)
    {
        label.font = [UIFont systemFontOfSize:numF];
        label.textColor = color;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
    }
}


//获取现在的时间
+(void)currentTimeLabel:(UILabel *)label
                   date:(UIDatePicker *)dates
                    Num:(NSInteger)num
{
    NSString * str;
    
    //获取现在的时间
    NSDate *currentTime;
    if (num == 0) {
        currentTime = [NSDate date];
    }else{
        currentTime = [dates date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *NowTime = [formatter stringFromDate:currentTime];
    
    //获取现在是星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:currentTime];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            str = @"日";
            break;
        case 2:
            str = @"一";
            break;
        case 3:
            str = @"二";
            break;
        case 4:
            str = @"三";
            break;
        case 5:
            str = @"四";
            break;
        case 6:
            str = @"五";
            break;
        case 7:
            str = @"六";
            break;
        default:
            break;
    }
    
    label.text = [NSString stringWithFormat:@"%@  周%@", NowTime, str];
}

/**
 *  根据当前时间获取星期
 *
 *  @return 星期几
 */
+ (NSString *)initGetNowTimeWeek
{
    NSString * str;
    //获取现在的时间
    NSDate *currentTime = [NSDate date];
    //获取现在是星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:currentTime];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            str = @"7";
            break;
        case 2:
            str = @"1";
            break;
        case 3:
            str = @"2";
            break;
        case 4:
            str = @"3";
            break;
        case 5:
            str = @"4";
            break;
        case 6:
            str = @"5";
            break;
        case 7:
            str = @"6";
            break;
        default:
            break;
    }
    return str;
}

//时间计算/S
+ (NSString *)checkOrderDate:(id)date
                      string:(NSString *)Str
{
    NSString *string = [NSString stringWithFormat:@"%@",date] ;
    string = [string substringWithRange:NSMakeRange(0, string.length - 3)];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970: [string doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:Str];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString ;
}


+ (NSString *)checkNowTimeStr:(NSString *)str
                       nsdate:(NSDate *)dates
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:str];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: dates];
    NSDate *localeDate = [dates  dateByAddingTimeInterval: interval];
    NSString *NowTime = [formatter stringFromDate:localeDate];
    return NowTime;
}


/**
 *  计算前后一个月
 *
 *  @param date  要计算的时间
 *  @param withFlag 正数为后一个月 负数为前一个月
 *
 *  @return 计算后的时间
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withFlag:(int)Flag
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:Flag];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
    
}

- (void)initHUDProgresSelfView:(UIViewController *)views title:(NSString *)strTitle
{
    ProgressHud = [[MBProgressHUD alloc] initWithView:views.view];
    ProgressHud.minSize = MBHUDSize;
    ProgressHud.label.font = [UIFont systemFontOfSize:13];
    [views.view addSubview:ProgressHud];
    ProgressHud.label.text = strTitle;
}

- (void)initHideProgressHud
{
    [ProgressHud hideAnimated:YES];
}

- (void)initShowProgressHud:(UIViewController *)views
{
    [views.view bringSubviewToFront:ProgressHud];
    [ProgressHud showAnimated:YES];
}

+ (void)showAllTextView:(UIViewController *)view
               NsString:(NSString *)labelT
{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view.view];
    
    [view.view addSubview:HUD];
    HUD.minSize = CGSizeMake(100, 30);
    
    HUD.label.text = labelT;
    HUD.label.font = [UIFont systemFontOfSize:12];
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    HUD.yOffset = kScreenSizes.height - 350;
    HUD.xOffset = view.view.bounds.origin.x;
    

    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}


+ (void)showHudTextView:(UIViewController *)view
                hudView:(MBProgressHUD *)HUD
               NsString:(NSString *)labelT
{
    HUD = [[MBProgressHUD alloc] initWithView:view.view];
    [view.view addSubview:HUD];
    HUD.minSize = MBHUDSize;
    if (labelT == nil) {
        HUD.label.text = @"加载中...";
    }
    else
    {
        HUD.label.text = labelT;
    }
    [HUD show:YES];
    HUD.label.font = [UIFont systemFontOfSize:13];
}


+ (void)initWithUILabelText:(UILabel *)label
                   sizeWith:(CGSize)size
{
    CGSize containSize = size;//创建一个最大的Size
    UIFont * font = label.font;
    CGRect autorect = [label.text boundingRectWithSize:containSize options:
                       NSStringDrawingTruncatesLastVisibleLine|
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    CGPoint oldCenter = label.frame.origin;
    label.frame = CGRectMake(oldCenter.x + 5,  oldCenter.y, size.width, CGRectGetHeight(autorect)+25);
}

+ (void)initWithUITextView:(UITextView *)label
                  sizeWith:(CGSize)size
{
    CGSize containSize = size;//创建一个最大的Size
    UIFont * font = label.font;
    CGRect autorect = [label.text boundingRectWithSize:containSize options:
                       NSStringDrawingTruncatesLastVisibleLine|
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    CGPoint oldCenter = label.frame.origin;
    label.frame = CGRectMake(oldCenter.x,  oldCenter.y, label.frame.size.width, CGRectGetHeight(autorect)+15);
}

///**
// *  圆环百分比
// */
//+ (void)initKDGoalBar:(id)view
//               netNum:(NSInteger)num
//               menNum:(NSInteger)menNum
//               colors:(UIColor *)colors
//{
//    KDGoalBar*firstGoalBar = [[KDGoalBar alloc] initWithFrame:CGRectMake(0, 0, 25, 25) UIcolor:colors];
//    firstGoalBar.menNum = (float)menNum;
//    [firstGoalBar setPercent:(int)num animated:NO];
//    [view addSubview:firstGoalBar];
//}

+ (NSString *)initNeedAry:(id)ary
{
    NSString * str = [ary componentsJoinedByString:@","];
    NSString * str1 = [str stringByReplacingOccurrencesOfString:@"," withString:@"@"];
    return str1;
}

+ (NSString *)initTimeWeekDate:(id)date
                           str:(NSString *)Str
{
    NSString *string = [NSString stringWithFormat:@"%@",date] ;
    string = [string substringWithRange:NSMakeRange(0, string.length - 3)];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970: [string doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:Str];
//    NSString *dateString = [dateFormat stringFromDate:nd];
    //获取现在是星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:nd];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    NSString * str;
    switch (weekday) {
        case 1:
            str = @"日";
            break;
        case 2:
            str = @"一";
            break;
        case 3:
            str = @"二";
            break;
        case 4:
            str = @"三";
            break;
        case 5:
            str = @"四";
            break;
        case 6:
            str = @"五";
            break;
        case 7:
            str = @"六";
            break;
        default:
            break;
    }
    return str;
}

+ (NSDateComponents *)initDateComponentsView
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    return dateComponents;
}

//+ (void)initGetCusVivsitEmpNetWorkingSuccessHandle:(void (^)(id object))successHandle
//                                         dataError:(void (^)(id object))dataError
//{
//    NSMutableDictionary * parmas = [NSMutableDictionary dictionary];
//    [parmas setObject:@"getEmpPowerState" forKey:@"op"];
//    [parmas setObject:userId forKey:@"employeeid"];
//    [[NetWorkManager shareInstance] postMethodWithUrl:KPUrl
//                                           Parameters:parmas
//                                        successHandle:^(id object) {
//        if ([object[@"datas"][0][@"power_state"] intValue] == 2) {
//            successHandle(object) ;
//        }else{
//            dataError(object) ;
//        }
//    } dataError:^(id object) {
//        [PackagMet initAlertViewShowStr:object[@"errormsg"]];
//    } errorHandle:^(NSError *error) {
//    }];
//}
//
+ (void)initButtonLayerBut:(UIView *)but
                    corner:(NSInteger)num
                  borwidth:(NSInteger)borWNum
                   bocolor:(CGColorRef)color
{
    but.layer.borderWidth = borWNum;
    but.layer.borderColor = color;
    but.layer.cornerRadius = num;
    but.layer.masksToBounds = YES;
}

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}


#pragma mark -----------------------------------  将BASE64图片转换成Image ------------------
- (NSString*)encodeURL:(NSString *)string
 {
   NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
       if (newString) {
            return newString;
           }
       return @"";
  }

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (id)mydataWithBase64EncodedString:(NSString *)string {
    if (string == nil)
       [NSException raise:NSInvalidArgumentException format:@""];
   
    if ([string length] == 0)
            return [NSData data];

   static char * decodingTable = NULL;
     if (decodingTable == NULL) {
          decodingTable = malloc(256);
     if (decodingTable == NULL)
          return nil;
          memset(decodingTable, CHAR_MAX, 256);
           NSUInteger i;
     for (i = 0; i < 64; i++)
          decodingTable[(short) encodingTable[i]] = i;
          }
       const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
        if (characters == NULL)
               return nil;
       char *bytes = malloc((([string length] + 3) / 4) * 3);
       if (bytes == NULL)
         return nil;
        NSUInteger length = 0;
        NSUInteger i = 0;
    
      while (YES) {
        char buffer[4];
       short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++) {
        if (characters[i] == '\0')
        break;
        if (isspace(characters[i]) || characters[i] == '=')
        continue;
        buffer[bufferLength] = decodingTable[(short)characters[i]];
        if (buffer[bufferLength++] == CHAR_MAX) {
        free(bytes);
        return nil;
        }
        }

       if (bufferLength == 0)
           break;
       if (bufferLength == 1) {
           free(bytes);
             return nil;
           }
  
     bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
       if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
       if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
       realloc(bytes, length);
       return [NSData dataWithBytesNoCopy:bytes length:length];
}

/**
 *  删除换行符
 *
 */
+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:dataStr];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    NSCharacterSet*newLineAndWhitespaceCharacters = [ NSCharacterSet newlineCharacterSet];
    // 扫描
    while (![scanner isAtEnd])
    {
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@"|"];
        }
    }
    return result;
}

//自定义Btn

+ (UIButton *)getButtonLayer:(UIButton *)button Width:(CGFloat )Width BorderColor:(UIColor *)color CornerRadius:(CGFloat)radius {
    [button.layer setCornerRadius:radius];
    [button.layer setBorderWidth:Width];
    [button.layer setBorderColor:color.CGColor];
    return button;
}

+ (UIButton *)getButtonTitle:(UIButton *)button Title:(NSString *)title Font:(CGFloat)size Color:(UIColor *)color {
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

// 获取分割线

+ (UIView *)getSeparatView:(CGFloat )yy {
    UIView *separatView = [[UIView alloc] initWithFrame:CGRectMake(0, yy, KScreenWidth, 1)];
    [separatView setBackgroundColor:UIColorFromRGBA(0xf0f0f0, 1)];
    return separatView;
}

+ (UIView *)customView:(UIView *)view CornerRadius:(CGFloat)radius BorderWidth:(CGFloat)width borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor {
    if (!view) {
        view = [[UIView alloc]init];
    }
    [view.layer setCornerRadius:radius];
    [view.layer setBorderWidth:1];
    [view.layer setBorderColor:borderColor.CGColor];
    [view setBackgroundColor:backgroundColor];
    return view;
}

+ (UILabel *)getLabelLayer:(UILabel *)label Width:(CGFloat )Width BorderColor:(UIColor *)color CornerRadius:(CGFloat)radius {
    [label.layer setBorderColor:color.CGColor];
    [label.layer setBorderWidth:Width];
    [label.layer setCornerRadius:radius];
    return label;
}

+ (UILabel *)getLabelTitle:(UILabel *)label text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)Alignment {
    if (!label) {
        label = [[UILabel alloc]init];
    }
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = Alignment;
    return label;
}

+ (NSString *) GetTimeChange:(NSString *)TimeString {
    
    NSDate *currentTimeDate = [NSDate date];    //  现在时间
    //获取时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *getTimeDate = [formatter dateFromString:TimeString];
    
    // 现在时间 与 获取时间 之差
    long dd = (long)[currentTimeDate timeIntervalSince1970] - [getTimeDate timeIntervalSince1970];
    
    NSString *timeString=@"";
    
    // 1小时内。。
    if (dd/3600<1)
    {
        if (dd/60 <= 5) {
            timeString = @"刚刚";
        }else{
            timeString = [NSString stringWithFormat:@"%ld", dd/60];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    //   1小时 < 时间差 < 1天
    if (dd/3600 > 1 && dd/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/3600];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    //   1天 < 时间差 < 2天
    if (dd/86400 >=1 && dd/86400 < 2){
        timeString = @"昨天";
    }
    //   2天 < 时间差 < 4天
    if (dd/86400 >= 2 && dd/86400<5)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/86400];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    // 4天 < 时间差
    if (dd/86400 > 4) {
        timeString = [TimeString substringWithRange:NSMakeRange(0, 10)];
    }
    return timeString;
}

+ (NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *) localWiFiIPAddress
{
    
    /*
     #include <arpa/inet.h>
     #include <netdb.h>
     #include <net/if.h>
     #include <ifaddrs.h>
     #import <dlfcn.h>
     #import <SystemConfiguration/SystemConfiguration.h>
     
     */
    
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+ (NSString *)getFileNameByFilePath:(NSString *)filePath {
    return [filePath stringByDeletingPathExtension];
}

+ (NSString *)getFileSuffixByFilePath:(NSString *)filePath {
    return [filePath pathExtension];
}

+ (NSString *)getCompleteFileNameByFilePath:(NSString *)filePath {
    return [filePath lastPathComponent];
}

+ (NSString *)getFilePathOnLocation:(NSString *)filename {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *path =[documentPaths objectAtIndex:0];
    //    文件保存路径
    NSString *filePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@", filename]];
    return filePath;
}

/**
 *  获取返回数据的Key
 */
+ (NSString *)getDataWithData:(NSArray *)dataAry Key:(NSString *)key
{
    NSString *keyValue;
    if (dataAry.count > 0) {
        for (NSInteger index = 0; index < dataAry.count; index ++) {
            NSMutableDictionary *dataDict = [dataAry objectAtIndex:index];
            NSString *capTion = [dataDict objectForKey:@"Caption"];
            if ([capTion isEqualToString:key]) {
                NSArray *keyAry = [dataDict allKeys];
                for (NSString *subkey in keyAry) {
                    if ([[dataDict objectForKey:subkey] isEqualToString:key] && ![subkey isEqualToString:@"Caption"]) {
                        keyValue = subkey;
                        return keyValue;
                    }
                }
            }
        }
    }else {
        return nil;
    }
    return nil;
}

+ (NSString *)getDoubleFromString:(NSString *)string numberOfxiaoshu:(NSInteger )num {
    NSString *aaa;
    switch (num) {
        case 2:
            aaa = Money([string floatValue]);
            break;
            
        case 4:
            aaa = Money([string floatValue]);
            break;
            
        case 8:
            aaa = Money([string floatValue]);
            break;
            
        default:
            break;
    }
    return aaa;
}

@end
