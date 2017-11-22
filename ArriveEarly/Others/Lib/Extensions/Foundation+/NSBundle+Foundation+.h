//
//  NSBundle+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14/11/14.
//  Copyright (c) 2014年 codingobjc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalString(string)                     NSLocalizedString((string), nil)
#define FormatString(args...)                   [NSString stringWithFormat:args]

#define MainBundle()                                ([NSBundle mainBundle])
#define PathForBundleResource(resName, resType)     [MainBundle() pathForResource:(resName) ofType:(resType)]
#define URLForBundleResource(resName, resType)      [MainBundle() URLForResource:(resName) \
                                                                    withExtension:(resType)]
#define APPDisplayName()                            [MainBundle() \
                                                        objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define AppBundleIdentifier()                       [MainBundle() \
                                                        objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define AppReleaseVersionNumber()                   [MainBundle() \
                                                        objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define AppBuildVersionNumber()                     [MainBundle() objectForInfoDictionaryKey:@"CFBundleVersion"]

@interface NSBundle (Foundation_)

@end
