//
//  OtherActivityViewController.h
//  ArriveEarly
//
//  Created by m on 2016/11/12.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 活动二级页面
 */
@interface OtherActivityViewController : UIViewController
@property (nonatomic ,strong) NSDictionary *configDict;

@property (nonatomic, strong) ActivityConfigModel *configModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic ,copy) NSString *activityID;
@end
