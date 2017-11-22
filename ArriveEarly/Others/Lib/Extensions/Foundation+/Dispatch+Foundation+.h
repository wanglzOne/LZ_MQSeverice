//
//  Dispatch+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/13.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#ifndef Foundation__Dispatch_Foundation__h
#define Foundation__Dispatch_Foundation__h

#import <Foundation/Foundation.h>

#define DispatchAfterCancel()   cancelFDNDispatchAfter = YES;
#define DispatchAfterIfNotCanceled(seconds, block)  __block BOOL cancelFDNDispatchAfter = NO;\
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, \
            (int64_t)((seconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
                if (!cancelFDNDispatchAfter && (block)) { \
                    block();\
                }\
            })

#endif
