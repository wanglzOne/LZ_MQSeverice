//
//  OrderNoteViewController.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/3.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSettingViewController.h"

typedef void(^NoteStringBlock)(NSString *noteStr);

/**
 订单 备注
 */
@interface OrderNoteViewController : BaseSettingViewController

//- (void)

@property (nonatomic, strong) NSString *noteString;

- (void)setNoteStringBlock:(NoteStringBlock)block;

@end
