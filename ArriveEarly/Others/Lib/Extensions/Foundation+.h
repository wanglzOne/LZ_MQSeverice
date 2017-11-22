//
//  Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/13.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

/**
 *  Extensions for Foundation.framework
 */
#ifndef Foundation__Foundation__h
#define Foundation__Foundation__h

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "Blocks+Foundation+.h"
#import "Dispatch+Foundation+.h"
#import "NSBundle+Foundation+.h"
#import "NSData+Foundation+.h"
#import "NSError+Foundation+.h"
#import "NSException+Foundation+.h"
#import "NSFileManager+Foundation+.h"
#import "NSNotificationCenter+Foundation+.h"
#import "NSObjCRuntime+Foundation+.h"
#import "NSPathUtilities+Foundation+.h"
#import "NSString+Foundation+.h"
#import "NSIndexPath+Foundation+.h"
#import "NSDate+Foundation+.h"
#import "UIImage+Compress.h"
#import "UIView+HUDExtensions.h"
#import "NSDictionary+escapeUnicode.h"
#import "NSString+Unicde.h"
#import "NSString+GetSize.h"

#import "UIView+SetBoard.h"

#import "UIView+GetTopView.h"
#import "UIButton+EX.h"

#import "UIViewController+VCBlock.h"

#import "UIImage+Extensions.h"

#import "UILabel+LabelExtensions.h"

#endif


/*
 dispatch_group_t dispatchGroup = dispatch_group_create();
 dispatch_group_async(dispatchGroup, dispatch_get_global_queue(0, 0), ^() {
     //block1
 });
 dispatch_group_async(dispatchGroup, dispatch_get_global_queue(0, 0), ^() {
    //block2
 });
 dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^() {
    //end  等待两个 block1、2都执行完之后才执行这个函数
 });
另外一种用法
 //                  等待时间 DISPATCH_TIME_FOREVER永久等地啊
 //        dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
 //        dispatch_async(dispatch_get_main_queue(), ^{
 //            // 主线程处理
 //        });
 
 */