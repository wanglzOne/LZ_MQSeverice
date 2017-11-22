//
//  NSIndexPath+Foundation_.h
//  Parking
//
//  Created by ZhangTinghui on 15/1/15.
//  Copyright (c) 2015年 www.660pp.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define RowIndexOfSectionRow(section, row) ((section) * 10000 + (row))
#define RowIndexOfIndexPath(indxePath) RowIndexOfSectionRow((indxePath).section, (indxePath).row)

@interface NSIndexPath (Foundation_)

@end
