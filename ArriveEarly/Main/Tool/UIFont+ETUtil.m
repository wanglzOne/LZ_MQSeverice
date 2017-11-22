//
//  UIFont+ETUtil.m
//  EasyDriver
//
//  Created by chenxianwu on 16/4/28.
//  Copyright © 2016年 EasyTaxi. All rights reserved.
//

#import "UIFont+ETUtil.h"

static const NSUInteger kDefaultSetFontSize=14;
static const NSUInteger kHomeButtonTitleSize =12;
@implementation UIFont (ETUtil)
/**设置界面默认字体*/
+(instancetype) defaultSetFont{
    
    return [UIFont systemFontOfSize:kDefaultSetFontSize];
}
/**设置主页按钮的字体大小*/
+(instancetype) homeButtonTitle{
    
     return [UIFont systemFontOfSize:kHomeButtonTitleSize];
}
@end
