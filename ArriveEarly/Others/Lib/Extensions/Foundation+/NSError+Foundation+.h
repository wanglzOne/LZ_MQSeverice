//
//  NSError+Foundation+.h
//  Foundation+
//
//  Created by ZhangTinghui on 14-6-17.
//  Copyright (c) 2014年 www.codingobjc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Foundation_)

+ (id)errorWithCode:(NSInteger)code localizedDescription:(NSString*)description;

+ (id)errorWithDomain:(NSString*)domain code:(NSInteger)code localizedDescription:(NSString*)description;

@end
