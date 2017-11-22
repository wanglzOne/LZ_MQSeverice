//
//  PackagMet.h
//  XiaoBuOutWork
//
//  Created by 陈彬 on 15-5-20.
//  Copyright (c) 2015年 com.eteamsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface PackagMet : UIView
{
    MBProgressHUD * ProgressHud;
}

/**
 *  单利
 *
 *  @return 对象
 */
+ (instancetype)shareInstance;

/**
 *  改变单个uilable 的字体格式
 *
 *  @param label UILabel
 *  @param numF   字号
 *  @param color  字体颜色
 */
+ (void)initZTFont:(UILabel *)label numF:(NSInteger)numF color:(UIColor *)color;
/**
 *  改变多个uilable 的字体格式
 *
 *  @param labAry UILabel数组
 *  @param numF   字号
 *  @param color  字体颜色
 */
+ (void)initZTFonts:(NSArray *)labAry
               numF:(NSInteger)numF
              color:(UIColor *)color;

+(void)currentTimeLabel:(UILabel *)label date:(UIDatePicker *)dates Num:(NSInteger)num;



/**
 *  时间计算
 */
+ (NSString *)checkOrderDate:(id)date string:(NSString *)Str;

/**
 *  缓冲图标
 */
- (void)initHUDProgresSelfView:(UIViewController *)views
                         title:(NSString *)strTitle;
- (void)initHideProgressHud;
- (void)initShowProgressHud:(UIViewController *)views;
/**
 *  提示成功
 */
+ (void)showAllTextView:(UIViewController *)view NsString:(NSString *)labelT;

/**
 *  文本自适应
 */
+ (void)initWithUILabelText:(UILabel *)label sizeWith:(CGSize)size;

/**
 *  文本框自适应高度
 */
+ (void)initWithUITextView:(UITextView *)label sizeWith:(CGSize)size;

/**
 *  获取当前时间
 */
+ (NSString *)checkNowTimeStr:(NSString *)str nsdate:(NSDate *)dates;
/**
 *  圆环百分比
 */
//+ (void)initKDGoalBar:(id)view netNum:(NSInteger)num menNum:(NSInteger)menNum colors:(UIColor *)colors;
/**
 *  以@符号分割  数组转换为字符串
 */
+ (NSString *)initNeedAry:(id)ary;

/**
 *  计算星期
 */
+ (NSString *)initTimeWeekDate:(id)date str:(NSString *)Str;

/**
 *  根据当前时间获取星期
 *
 *  @return 星期几
 */
+ (NSString *)initGetNowTimeWeek;

/**
 *  获取本周是今年的第几周
 */
//+ (NSInteger)initWeekOfYear;

/**
 *  获取一年中得数据
 *
 *  @return ;
 @property NSInteger year;
 @property NSInteger month;
 @property NSInteger day;
 @property NSInteger hour;
 @property NSInteger minute;
 @property NSInteger second;
 @property NSInteger nanosecond NS_AVAILABLE(10_7, 5_0);
 @property NSInteger weekday;
 @property NSInteger weekdayOrdinal;
 @property NSInteger quarter NS_AVAILABLE(10_6, 4_0);
 @property NSInteger weekOfMonth NS_AVAILABLE(10_7, 5_0);
 @property NSInteger weekOfYear NS_AVAILABLE(10_7, 5_0);
 @property NSInteger yearForWeekOfYear NS_AVAILABLE(10_7, 5_0);

 */
+ (NSDateComponents *)initDateComponentsView;

/**
 *  计算前后一个月
 *
 *  @param date  要计算的时间
 *  @param Flag  后一个月 负数为前一个月
 *
 *  @return 计算后的时间
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withFlag:(int)Flag;

/**
 *  等待
 */
+ (void)showHudTextView:(UIViewController *)view hudView:(MBProgressHUD *)HUD  NsString:(NSString *)labelT;

/**
 *  判断权限
 */
//+ (void)initGetCusVivsitEmpNetWorkingSuccessHandle:(void (^)(id object))successHandle dataError:(void (^)(id object))dataError;
/**
 *  UIButton 画边框先圆角
 */
+ (void)initButtonLayerBut:(UIView *)but
                    corner:(NSInteger)num
                  borwidth:(NSInteger)borWNum
                   bocolor:(CGColorRef)color;
/**
 *  字符串字典 转 字典
 */
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

/**
 *  将BASE64图片转换成Image
 */
- (NSString*)encodeURL:(NSString *)string;
+(id)mydataWithBase64EncodedString:(NSString *)string ;

/**
 *  删除换行符
 */
+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr;
/*
 *  自定义Btn
 */
+ (UIButton *)getButtonLayer:(UIButton *)button Width:(CGFloat )Width BorderColor:(UIColor *)color CornerRadius:(CGFloat)radius;

+ (UIButton *)getButtonTitle:(UIButton *)button Title:(NSString *)title Font:(CGFloat)size Color:(UIColor *)color;
/*
 *  自定义View
 */

+(UIView *)customView:(UIView *)view CornerRadius:(CGFloat)radius BorderWidth:(CGFloat)width borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor;
/*
 *  自定义Label
 */
+ (UILabel *)getLabelLayer:(UILabel *)label Width:(CGFloat )Width BorderColor:(UIColor *)color CornerRadius:(CGFloat)radius;

+ (UILabel *)getLabelTitle:(UILabel *)label text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)Alignment;
/*
 *  自定义分割线
 */
+ (UIView *)getSeparatView:(CGFloat )yy;

/**
 *  传入需要转换的时间
 *  获取的时间与现有时间的差值
 */
+ (NSString *) GetTimeChange:(NSString *)TimeString;

/**
 *  获取当前手机连接的wifi名字
 */
+ (NSString *)getWifiName;

/**
 *  获取当前手机连接的wifi的IP地址
 */
+ (NSString *) localWiFiIPAddress;
/**
 *  获得文件名（不带后缀）
 */
+ (NSString *)getFileNameByFilePath:(NSString *)filePath;
/**
 *  获得文件的扩展类型（不带'.'）
 */
+ (NSString *)getFileSuffixByFilePath:(NSString *)filePath;
/**
 *  从路径中获得完整的文件名（带后缀）
 */
+ (NSString *)getCompleteFileNameByFilePath:(NSString *)filePath;
/**
 *  将文件存储到沙盒内 返回路径
 *  @param filename 存储的文件名
 */
+ (NSString *)getFilePathOnLocation:(NSString *)filename;
/**
 *  获取返回数据的Key
 */
+ (NSString *)getDataWithData:(NSArray *)dataAry Key :(NSString *)key;

+ (NSString *)getDoubleFromString:(NSString *)string numberOfxiaoshu:(NSInteger )num;



@end
