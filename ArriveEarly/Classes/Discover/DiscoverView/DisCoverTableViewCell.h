//
//  DisCoverTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/11.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverInfo.h"


@interface DisCoverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *placeContent;


///  高度80
//@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


///自动变化的  内容
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

///  75 ==>>（375-46）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageContentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;


@property (strong, nonatomic) DiscoverInfo *info;

@end
