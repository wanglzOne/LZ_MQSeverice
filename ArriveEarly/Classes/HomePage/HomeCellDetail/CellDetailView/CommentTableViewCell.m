//
//  CommentTableViewCell.m
//  ArriveEarly
//
//  Created by m on 2016/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
@implementation CommentTableViewCell

+(instancetype)creatCell:(UITableView *)tableView
{
    static NSString *identifer = @"cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CommentTableViewCell class]) owner:nil options:nil] firstObject];
    }
    return cell;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置背景或者选中背景
    }
    return  self;
}


-(void)setModel:(CommentModel *)model
{
    _model = model;
    self.timeLabel.text = [NSDate getTimeToLocaDatewith:@"yyyy-MM-dd HH:mm" with:model.createTime / 1000];
    
    NSString *name = model.evaUserId;
    
    if (name.length < 3) {
        self.userName.text = @"***";
    }else
    {
        NSMakeRange(3, 4);
//        name = [name stringByReplacingCharactersInRange:NSMakeRange(1, name.length-2) withString:@"****"];
         name = [name stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.userName.text = name;
    }
      [self.userHeaderImg sd_setImageWithURL:[NSURL URLWithString:[model.user.url imageUrl]] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    
    /*
    //userHeaderImg
    if (model.isAnonymous) {
        NSString *name = model.evaUserId;
        if (name.length < 3) {
            self.userName.text = @"***";
        }else
        {
            NSMakeRange(3, 4);
            name = [name stringByReplacingCharactersInRange:NSMakeRange(1, name.length-2) withString:@"****"];
            self.userName.text = name;
        }
    }else
    {
        NSString *phone = model.evaUserId;
        if (phone.length == 11) {
            phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        self.userName.text = phone;
    }
    */
    
    self.commentLabel.text = model.evaContent;
//    [self setContent:self.commentLabel.text];
    self.score = model.evaScore;
    int num = (int)self.score;
    switch (num) {
        case 0:
            [self.starOne setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starTwo setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starThree setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFour setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFive setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.starTwo setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starThree setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFour setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFive setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.starThree setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFour setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFive setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.starFour setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            [self.starFive setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.starFive setImage:[UIImage imageNamed:@"wjx"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
