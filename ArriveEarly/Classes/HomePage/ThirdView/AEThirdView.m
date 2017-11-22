//
//  AEThirdView.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/26.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEThirdView.h"
#import <Foundation/Foundation.h>

@interface AEThirdView ()

@property (nonatomic , assign) long long surplus;
@property (nonatomic, strong)  NSTimer * timer;
@end

@implementation AEThirdView

+ (instancetype)createThirdViewWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:@"AEThirdView" owner:nil options:nil] firstObject];
}

- (void)refreshSecondsKillActivity
{
    ActivityConfigModel *secondsKillModel = [ArriveEaryDefaultConfigManager shared].secondsKillEveryDayConfigModel;
    [self setViewImage:self.image1 andUrl:secondsKillModel.mainUrl_isCover1 placeholderImageName:@"kenweir1"];
    
    SecondsKillActivityState sate = [ArriveEaryDefaultConfigManager shared].activityState;
    if (sate == SecondsKillActivityState_NO) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil ;
        }
        self.surplus = 0;
        self.openLabel.text = @"暂时没活动";
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
    }else if(sate == SecondsKillActivityState_NOStart) {
        self.openLabel.text = @"距离活动开始";
        self.surplus = (secondsKillModel.activityEffStart - secondsKillModel.newDate)/1000;
        [self creatTimer];
        [self updateTimer];
    }
    else if(sate == SecondsKillActivityState_AlreadyStart) {
        self.openLabel.text = @"距离活动结束";
        self.surplus = (secondsKillModel.activityEffEnd - secondsKillModel.newDate)/1000;
        [self creatTimer];
        [self updateTimer];
    }else if(sate == SecondsKillActivityState_End) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil ;
        }
        self.openLabel.text = @"活动已经结束";
        self.surplus = 0;
        self.hourLabel.text = @"00";
        self.minuteLabel.text = @"00";
        self.secondLabel.text = @"00";
    }
}



- (void)setViewImageForUrls:(NSArray *)urls
{
    NSArray * placeholderImageNames = @[@"tu-43",@"kenweir2",@"kenweir3",@"kenweir4"];
    NSArray * imageViews = @[self.image2,self.image3,self.image4,self.image5];
    for (int i= 0; i < urls.count; i ++) {
        [self setViewImage:imageViews[i] andUrl:[urls[i] imageUrl] placeholderImageName:placeholderImageNames[i]];
    }
}
- (void)setViewImage:(UIImageView *)imgView andUrl:(NSString *)url placeholderImageName:(NSString *)name
{
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:name]];
}

-(void)initGetDataSource:(NSArray *)ary Date:(NSString *)nowDate
{
    if (!ary.count) {
        return;
    }
    
    NSMutableArray *mainImages = [[NSMutableArray alloc] initWithCapacity:ary.count];
    for (NSDictionary *dict in ary) {
        NSString *imgUrl = @"0";
        NSArray *listImages = dict[@"listImage"];
        if ([listImages isKindOfClass:[NSArray class]]) {
            for (NSDictionary *listDict in listImages) {
                if ([listDict isKindOfClass:[NSDictionary class]]) {
                    if (listDict[@"isCover"] && listDict[@"isCover"] != (id)kCFNull) {
                        int isCover = [listDict[@"isCover"] intValue];
                        if (isCover == 1) {
                            if ([listDict[@"imageUrl"] isKindOfClass:[NSString class]])
                            {
                                imgUrl = listDict[@"imageUrl"];
                            }
                        }
                    }
                }
            }
        }
        [mainImages addObject:imgUrl];
    }
    [self setViewImageForUrls:mainImages];
    
    NSArray *names = @[self.twoNameLabel,self.threeNameLabel,self.fourNameLabel,self.fiveNameLabel];
    NSArray *contents = @[self.twoContentLabel,self.threeContentLabel,self.fourContentLabel,self.fiveContentLabel];
    
    int i = 0;
    for (NSDictionary *dict in ary) {
        [self setUIforNameLabel:names[i] andContentLabel:contents[i] withData:dict];
        i ++;
    }
}


- (void)setUIforNameLabel:(UILabel *)nameLabel andContentLabel:(UILabel *)contentLabel withData:(NSDictionary *)dict
{
    nameLabel.text = dict[@"activityName"];
    if ([dict[@"activityContent"] isKindOfClass:[NSString class]]) {
        contentLabel.text = dict[@"activityContent"];
    }else
    {
        contentLabel.text = @"";
    }
}


-(void)creatTimer
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
-(void)updateTimer
{
    --self.surplus;
    //毫秒   最好是 ArriveEaryDefaultConfigManager 自己管理线程  自己管理时间 才不会出bug
    [ArriveEaryDefaultConfigManager shared].secondsKillEveryDayConfigModel.newDate = [ArriveEaryDefaultConfigManager shared].secondsKillEveryDayConfigModel.newDate+1000;
    
    if(self.surplus / 3600 < 10)
    {
        self.hourLabel.text = [NSString stringWithFormat:@"0%lld",self.surplus / 3600];
    }
    else{
    self.hourLabel.text = [NSString stringWithFormat:@"%lld",self.surplus / 3600];
    }
    if (self.surplus % 3600 / 60 < 10) {
        self.minuteLabel.text = [NSString stringWithFormat:@"0%lld",self.surplus % 3600 / 60];
    }
    else{
        self.minuteLabel.text = [NSString stringWithFormat:@"%lld",self.surplus % 3600 / 60];
    }
    if (self.surplus % 3600 % 60 < 10) {
        self.secondLabel.text = [NSString stringWithFormat:@"0%lld",self.surplus % 3600 % 60];
    }
    else{
        self.secondLabel.text = [NSString stringWithFormat:@"%lld",self.surplus % 3600 % 60];
    }
    
}
//点击事件
- (IBAction)clickAction:(UIButton *)sender {
    NSInteger index = sender.tag;
   DLog(@"点击的是第%ld",(long)index);
    [self callFuncWithNumber:sender];
}

#pragma mark---实现协议方法
-(void) callFuncWithNumber:(UIButton *) number{
    
    if ([self.delegate conformsToProtocol:@protocol(AEThirdViewDelegate)]) {
        [self.delegate buttonClickWithNumber:number];
    }
}
/*
 
 //    self.oneNameLabel.text = ary[0][@"activityName"];
 #warning ------计算活动结束时间--------
 NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[ary[0][@"activityEffEnd"] longLongValue]/1000];
 NSLog(@"天天秒杀活动结束时间------>%lld  = %@",[ary[0][@"activityEffEnd"] longLongValue],endDate);
 NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[ary[0][@"activityEffStart"] longLongValue]/1000];
 NSLog(@"天天秒杀活动开始时间------>%lld  = %@",[ary[0][@"activityEffStart"] longLongValue],startDate);
 
 NSDate *now = [NSDate dateWithTimeIntervalSince1970:[nowDate longLongValue]/1000];
 NSLog(@"服务器当前时间---------->%@ = %@",nowDate,now);
 
 //    （[ary[0][@"activityEffEnd"] longLongValue] - [nowDate longLongValue])/1000
 self.surplus = ([ary[0][@"activityEffEnd"] longLongValue] - [nowDate longLongValue])/1000;
 NSLog(@"剩余的活动时间长度是----------->%lld",self.surplus);
 
 if (self.timer) {
 [self.timer invalidate];
 self.timer = nil ;
 }
 
 
 [self creatTimer];
 if ([nowDate longLongValue] >  [ary[0][@"activityEffStart"] longLongValue] && [ary[0][@"activityEffEnd"] longLongValue] > [nowDate longLongValue]) {
 self.openLabel.text = @"距离结束";
 }else
 {
 self.openLabel.text = @"距离开始";
 }
 
 if (self.surplus <= 0 ) {
 //__________________当时间走完以后__________________进行处理______________
 self.hourLabel.text = @"00";
 self.minuteLabel.text = @"00";
 self.secondLabel.text = @"00";
 self.openLabel.text = @"暂时没活动";
 [self.timer invalidate];
 self.timer = nil ;
 }
 */
@end
