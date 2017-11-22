//
//  CommentTableViewCell.h
//  ArriveEarly
//
//  Created by m on 2016/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) double score;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (nonatomic ,strong) CommentModel *model;

@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;



+(instancetype)creatCell:(UITableView*)tableView;
-(void)setContent:(NSString*)text;

@end
