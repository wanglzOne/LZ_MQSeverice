//
//  NSFileManager+Foundation+.m
//  Foundation+
//
//  Created by ZhangTinghui on 14-5-26.
//  Copyright (c) 2014年 www.codingobjc.com. All rights reserved.
//

#import "NSFileManager+Foundation+.h"

@implementation NSFileManager (Foundation_)

+ (void)makeSureDirectoryExistsAtPath:(NSString *)directoryPath {
    if ([DefaultFileManager() fileExistsAtPath:directoryPath]) {
        return;
    }
    
    NSError *error;
    if (![DefaultFileManager() createDirectoryAtPath:directoryPath
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:&error]) {
#if DEBUG
        NSLog(@"%@", error.description);
#endif
    }
}

+ (BOOL)setItemAtPath:(NSString *)itemPath excludeFromiCloud:(BOOL)exclude {
    
    if (![DefaultFileManager() fileExistsAtPath:itemPath]) {
        return NO;
    }
    
    NSError *error = nil;
    NSNumber *oldValue = nil;
    NSURL *itemURL = [NSURL fileURLWithPath:itemPath];
    BOOL successed = [itemURL getResourceValue:&oldValue
                                        forKey:NSURLIsExcludedFromBackupKey
                                         error:&error];
    if (successed && [oldValue boolValue] == exclude) {
        return YES;
    }
    
    successed = [itemURL setResourceValue:@(exclude)
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if(!successed) {
#if DEBUG
        NSLog(@"Set [%@] exclude[%@] from iCloud errored[%@]",
              [itemURL lastPathComponent], exclude? @"YES": @"NO", error);
#endif
    }
    
    return successed;
}

@end
