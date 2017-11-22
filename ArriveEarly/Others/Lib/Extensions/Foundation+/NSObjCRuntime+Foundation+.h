//
//  NSObjCRuntime+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/13.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#ifndef Foundation__NSObjCRuntime_Foundation_h
#define Foundation__NSObjCRuntime_Foundation_h

#import <Foundation/Foundation.h>

/**
 *  DLog
 */
#pragma mark - DLog
#if DEBUG
#define DLog(args...)       (NSLog(@"%@", [NSString stringWithFormat:args]))
#else
#define DLog(args...)       // do nothing.
#endif

#define DLogMethodName()	DLog(@"%s", __PRETTY_FUNCTION__)
#define DLogBOOL(b)         DLog(@"%@", b? @"YES": @"NO")
#define DLogCGPoint(p)		DLog(@"CGPoint(%f, %f)", p.x, p.y)
#define DLogCGSize(s)		DLog(@"CGSize(%f, %f)", s.width, s.height)
#define DLogCGRect(r)		DLog(@"{CGRect{origin(%f, %f), size(%f, %f)}", \
                                    r.origin.x, r.origin.y, r.size.width, r.size.height)
#define DLogObject(obj)     DLog(@"%@", (obj))
 

/** 输出*/
#ifdef DEBUG
#define DLogMethod() NSLog(@"^ %s", __func__)
#define DDLog(...) NSLog(__VA_ARGS__)
#else
#define DDLog(...)
#define DLogMethod(...)
#endif

/** 获取硬件信息*/
#define SXSCREEN_W [UIScreen mainScreen].bounds.size.width
#define SXSCREEN_H [UIScreen mainScreen].bounds.size.height
#define SXCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define SXCurrentSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

/** 适配*/
#define SXiOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define SXiOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define SXiOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define SXiOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SXiOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define SXiPhone4_OR_4s    (SXSCREEN_H == 480)
#define SXiPhone5_OR_5c_OR_5s   (SXSCREEN_H == 568)
#define SXiPhone6_OR_6s   (SXSCREEN_H == 667)
#define SXiPhone6Plus_OR_6sPlus   (SXSCREEN_H == 736)
#define SXiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


/**
 *  Math
 */
#pragma mark - Math
//#define fequal(a, b)            (fabs((a) - (b)) < FLT_EPSILON)
//#define fequalzero(a)           (fabs(a) < FLT_EPSILON)
#define DegreesToRadian(x)      (M_PI * (x) / 180.0f)
#define RadianToDegrees(x)      (180.0f * (x) / M_PI)
#define RandomNumber(min, max)  ((min) + arc4random()%((max)-(min)+1))

#endif
