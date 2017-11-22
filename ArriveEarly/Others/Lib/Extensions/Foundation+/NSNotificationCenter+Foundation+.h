//
//  NSNotificationCenter+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14-6-4.
//  Copyright (c) 2014年 www.codingobjc.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NotificationAdd(anObserver, aSEL, noteName, anObj)    [[NSNotificationCenter defaultCenter] \
                                                                addObserver:(anObserver) \
                                                                selector:(aSEL) \
                                                                name:(noteName) \
                                                                object:(anObj)]

#define NotificationRemove(anObserver, notifName, anObj)      [[NSNotificationCenter defaultCenter] \
                                                                removeObserver:(anObserver) \
                                                                name:(notifName) object:(anObj)]

#define NotificationRemoveObserver(anObserver)				[[NSNotificationCenter defaultCenter] \
                                                                removeObserver:(anObserver)]

#define NotificationPost(notifName, anObj, anUserInfo)		[[NSNotificationCenter defaultCenter] \
                                                                postNotificationName:(notifName) \
                                                                object:(anObj) \
                                                                userInfo:(anUserInfo)]

#define NotificationPostOnMainThread(notifName, anObj, anUserInfo) dispatch_async(dispatch_get_main_queue(), ^(void){\
                                                                [[NSNotificationCenter defaultCenter] \
                                                                 postNotificationName:(notifName) \
                                                                 object:(anObj) \
                                                                 userInfo:(anUserInfo)];\
                                                            });\

@interface NSNotificationCenter (Foundation_)

@end
