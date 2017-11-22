//
//  AEConst.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/18.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG


#define KBaseUrl(url) [[NSString stringWithFormat:@"%@%@%@/",KBaseIP,KBaseU,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]





#define AELog(descri,aeprint,...) NSLog(@"%@----%@",descri,aeprint)
#define AETestColor  [UIColor yellowColor]

#else

#define AELog(...)

#define KBaseUrl(url) [[NSString stringWithFormat:@"%@%@%@/",KBaseIP,KBaseU,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

#define AETestColor  [UIColor yellowColor]

#endif


#define AEColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define AEGlobalBg AEColor(0, 0, 0)
#define AETabBarItemTitleColor AEColor(123,105,88)
#define AENotificationCenter [NSNotificationCenter defaultCenter]
#define ScreenWith [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#define SuppressPerformSelectorLeakWarning(Stuff)                                                                   \
do {                                                                                                            \
_Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
_Pragma("clang diagnostic pop")                                                                             \
} while (0)



extern NSString* const KConvention;
extern NSString* const kBaiduMapKey;
extern NSString* const kZhiFuBaoKey;
extern NSString* const kWCHATAPPID;

extern NSString* const RSAPublicKey;
extern NSString* const RSAPrivateKey;

extern NSString* const KEY_Umeng;
extern NSString* const KBaseU;
extern NSString* const KBaseMQ;
extern NSString* const KBaseIP;

extern NSString* const KProductPhoneNumber;
/*
 static const NSInteger End_processControl = 101;
 //流程控制标题 Type
 static NSInteger const TITLETYPE = 12345;
 */



extern NSString* const KChangeAddressNotificationKey;
extern NSString* const KLogOutSucess;


extern const NSInteger HomeTopScrollPictureHeight;//首页轮播图的高度
extern const NSInteger ButtonTitleHeight;//按钮文字的高度
extern const NSInteger ButtonMargion;//图片和文字之间的的间距
extern const NSInteger HomeSecondeViewHeight;//轮播图下边第二个视图的高度
extern const NSInteger HomeThirdViewHeight;//第三个视图的高度
extern const NSInteger NumberOfPages;//指示器的个数
extern const NSInteger CurrentPage ;//当前指示器的在哪一页
extern const NSInteger EstimatedHeight;//cell预估高度
extern const NSInteger HomeTopSearchBtnWith;//顶部搜索按钮宽度
extern const NSInteger HomeTopSearchBtnHeight;//顶部搜素按钮高度
extern const NSInteger homeTopSearchCornerRadius;
extern const NSInteger HomeTopSearchBtnMargion; //边距
extern const NSInteger Margion;//按钮距离视图四周的边距
extern const NSInteger  MaxMargion;//按钮与按钮之间的间距
extern const NSInteger Number;//一排多少个
extern const NSInteger searchClockMargion;//搜索框与闹钟之间的距离
extern const NSInteger clockWidth;//闹钟的宽度
extern const NSInteger searchBtnWidth;//搜索按钮的宽度
