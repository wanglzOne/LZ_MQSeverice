//
//  OrderNormalTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/15.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderNormalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleContentWith;

- (void)configUI:(NSString *)sectionName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *henadWidth;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;


@end
