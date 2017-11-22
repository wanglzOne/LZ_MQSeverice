//
//  NSFileManager+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14-5-26.
//  Copyright (c) 2014年 www.codingobjc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultFileManager()                      [NSFileManager defaultManager]
#define AttributesOfFileSystemForPath(path, err)  [DefaultFileManager() attributesOfFileSystemForPath:(path) \
                                                                        error:(err)]
#define AttributesOfItemAtPath(path, err)         [DefaultFileManager() attributesOfItemAtPath:(path) error:(err)]
#define SizeOfItemAtPath(path)                    [[AttributesOfItemAtPath((path), (nil)) objectForKey:NSFileSize] \
                                                        doubleValue]
#define DiskSize()                                ([[AttributesOfFileSystemForPath(NSHomeDirectory(), nil) \
                                                        objectForKey:NSFileSystemSize] doubleValue])
#define DiskFreeSize()                            ([[AttributesOfFileSystemForPath(NSHomeDirectory(), nil) \
                                                        objectForKey:NSFileSystemFreeSize] doubleValue])


@interface NSFileManager (Foundation_)

/**
 *  Make sure directory path is existed, if not created it
 *
 *  @param directoryPath path for the directory
 */
+ (void)makeSureDirectoryExistsAtPath:(NSString *)directoryPath;


/**
 *  Set item do not be backup to iCloud
 *
 *  @param itemPath path of item
 *  @param exclude  whether is not be backup to iCloud
 *
 *  @return YES, if success; otherwise return NO.
 */
+ (BOOL)setItemAtPath:(NSString *)itemPath excludeFromiCloud:(BOOL)exclude;

@end
