//
//  DisCoverTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/11.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "DisCoverTableViewCell.h"

@implementation DisCoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = HWColor(238, 239, 240);
    
//    self.authorLabel.backgroundColor = HWColor(0xff, 0xd7, 0x05);
//    self.authorLabel.textColor = HWColor(0x49, 0x2b, 0x00);
    
//    self.timeLabel.textColor = HWColor(0x43, 0x43, 0x43);
    self.titleLabel.textColor = HWColor(0x33, 0x33, 0x33);
    
//    self.contentLabel.textColor = HWColor(0x33, 0x33, 0x33);
}

- (void)setInfo:(DiscoverInfo *)info
{
    _info  =info;
    
    //self.headImageView.image = [UIImage imageNamed:@"touxiang1"];
//    if ([info.createAuthor  isKindOfClass:[NSString class]]) {
//        self.authorLabel.text = [NSString stringWithFormat:@" %@ ",info.createAuthor];
//    }else
//    {
//        self.authorLabel.text = @"";
//    }
    
//    self.timeLabel.text = [NSDate getTimeToLocaDatewith:@"yyyy-MM-dd HH:mm" with:info.createTime/1000];
    if ([info.title isKindOfClass:[NSString class]]) {
        self.titleLabel.text = info.title;
    }else
    {
        self.titleLabel.text = @"";
    }
    
//    self.contentLabel.text = info.desc;
    
    //if (!info.foundImage.count) {
        //self.imageContentView.hidden = YES;
        ////[self.imageContentViewHeight setConstant:0];
        
    //}else
    //{
    //    self.imageContentView.hidden = NO;
        //[self.imageContentViewHeight setConstant:0];
  //  }
    
    
    
    
    
    
    if (info.foundImage.count) {
        DiscoverInfoImageInfo *imginfo = info.foundImage[0];
        
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[([imginfo.imageUrl isKindOfClass:[NSString class]]?imginfo.imageUrl:@"") imageUrl]] placeholderImage:[UIImage imageNamed:@"pic01"]];
        
    }else
    {
        self.imageView1.image = [UIImage imageNamed:@""];
    }
    if (info.foundImage.count > 1) {
        DiscoverInfoImageInfo *imginfo = info.foundImage[1];

        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[([imginfo.imageUrl isKindOfClass:[NSString class]]?imginfo.imageUrl:@"") imageUrl]] placeholderImage:[UIImage imageNamed:@"pic01"]];
        
    }else
    {
        self.imageView2.image = [UIImage imageNamed:@""];
    }
    if (info.foundImage.count > 2) {
        DiscoverInfoImageInfo *imginfo = info.foundImage[2];
        [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:[([imginfo.imageUrl isKindOfClass:[NSString class]]?imginfo.imageUrl:@"") imageUrl]] placeholderImage:[UIImage imageNamed:@"pic01"]];
    }else
    {
        self.imageView3.image = [UIImage imageNamed:@""];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
