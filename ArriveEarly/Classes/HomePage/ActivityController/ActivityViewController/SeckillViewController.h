//
//  SeckillViewController.h
//  ArriveEarly
//
//  Created by m on 2016/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 秒杀活动二级页面
 */
@interface SeckillViewController : UIViewController
@property (nonatomic ,strong) NSDictionary *configDict;
@property (nonatomic, strong) ActivityConfigModel *configModel;



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic ,strong)NSString *activityID;


@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;
@property (weak, nonatomic) IBOutlet UILabel *toEndlabel;
@property (weak, nonatomic) IBOutlet UIImageView *moonImageView;
///如果活动已经开始 设置为 NO    
@property (nonatomic ,assign) BOOL isShow;

@end
