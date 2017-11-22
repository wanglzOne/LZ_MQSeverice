//
//  AECollectTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AECollectTableViewCell : UITableViewCell
//0    /    -70
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewLeading;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (assign, nonatomic) int star;

@property (assign, nonatomic) BOOL isEditing;

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (strong, nonatomic) ProductModel *product;

@end
