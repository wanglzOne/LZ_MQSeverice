//
//  BaseActivityModel.h
//  ArriveEarly
//
//  Created by m on 2016/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseActivityModel : NSObject
@property (nonatomic ,strong)NSString *activityContent;//描述
@property (nonatomic ,assign) long long activityEffEnd;
@property (nonatomic ,assign) long long activityEffStart;
@property (nonatomic ,assign) long long activityGenTime;//创建时间
@property (nonatomic ,strong) NSString *activityGenerator;//创建者
@property (nonatomic ,strong) NSString *activityId;
@property (nonatomic ,strong) NSString *activityName;
@property (nonatomic ,assign) int activityState;//活动是否进行 0是未进行 1是进行
@property (nonatomic ,assign) int activityType;//活动是否限时 0不限时 1是限时



@end
