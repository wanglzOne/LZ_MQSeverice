//
//  AccountImageTableViewCell.h
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountImageTableViewCell : UITableViewCell<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIButton *headImageButtton;
@property (copy, nonatomic) NSString *headUrl;
@property (weak, nonatomic) UIViewController *superVC;
@end
