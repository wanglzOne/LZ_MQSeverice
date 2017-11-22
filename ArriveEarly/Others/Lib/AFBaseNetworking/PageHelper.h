//
//  PageHelper.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/11.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageHelper : NSObject
{
    int ps;
}
//@property (nonatomic, assign) int changePageSize;




@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) int pageSize;


@property (nonatomic, assign) int total;
@property (nonatomic, assign) int rows;

@property (nonatomic, strong) NSDictionary *params;
//++
- (void)add;
//--
- (void)falseAdd;

@end
