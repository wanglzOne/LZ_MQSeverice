//
//  AEThirdView.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/26.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AEThirdViewDelegate <NSObject>

//监听按钮的点击
-(void) buttonClickWithNumber:(UIButton *) number;

@end
@interface AEThirdView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *image1;//kenweir
@property (weak, nonatomic) IBOutlet UIImageView *image2;//kenweir1
@property (weak, nonatomic) IBOutlet UIImageView *image3;//kenweir2
@property (weak, nonatomic) IBOutlet UIImageView *image4;//kenweir3
@property (weak, nonatomic) IBOutlet UIImageView *image5;//kenweir4




@property (weak, nonatomic) IBOutlet UILabel *oneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveContentLabel;
///距离开始 label
@property (weak, nonatomic) IBOutlet UILabel *openLabel;

@property (nonatomic ,assign)id<AEThirdViewDelegate>delegate;


+(instancetype) createThirdViewWithXib;
///配置天天秒杀的数据  修改：配置其他活动
-(void)initGetDataSource:(NSArray *)ary Date:(NSString *)nowDate;
- (void)refreshSecondsKillActivity;

@end
