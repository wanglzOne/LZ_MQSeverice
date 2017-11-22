//
//  AESecondView.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/20.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AESecondView.h"
#import "AECustomButton.h"

@interface AESecondView ()
{
    BOOL show;
}
@property (nonatomic, strong) NSMutableArray * secondImageArray;
@property (nonatomic, strong) NSMutableArray * secondTitleArray;
@property (nonatomic, strong) NSMutableArray * secondImgURLArray;

@end
@implementation AESecondView

-(void)getSecondData:(NSArray *)ary
{
    
    show = NO;
    if (ary.count > 0) {
        self.secondClassIDArray = [[NSMutableArray alloc]init];
        self.secondImgURLArray = [[NSMutableArray alloc]init];
        [self.secondTitleArray removeAllObjects];
        NSMutableArray *imgArray = [[NSMutableArray alloc]init];
        NSMutableArray *titleAry = [[NSMutableArray alloc]init];
        NSMutableArray *classIDAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in ary) {
            [imgArray addObject:[dic[@"imgUrl"] imageUrl]];
            [titleAry addObject:dic[@"className"]];
            [classIDAry addObject:dic[@"classId"]];
        }
        self.secondImgURLArray = [NSMutableArray arrayWithArray:imgArray];
        self.secondTitleArray = [NSMutableArray arrayWithArray:titleAry];
        self.secondClassIDArray = [NSMutableArray arrayWithArray:classIDAry];
        show = YES;
        
        
        [self createSecondView];
    }
    
}

-(NSMutableArray *) secondImageArray{
    if (!_secondImageArray) {
        _secondImageArray = [NSMutableArray arrayWithObjects:@"icon-meishi",@"icon-fenwei",@"icon-xiaochi",@"icon-zaodian",@"icon-tiandian",@"icon-jincai",@"icon-chaoshi",@"icon-shangjiayouhuijuan", nil];
    }
    return _secondImageArray;
}

-(NSMutableArray *) secondTitleArray{
    if (! _secondTitleArray) {
    
        _secondTitleArray = [NSMutableArray arrayWithObjects:@"美食",@"风味",@"小吃街",@"早点",@"甜点",@"净菜",@"超市",@"红包",nil];
    }
    return _secondTitleArray;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, ScreenWith, KHEIGHT_6(180));
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(instancetype)createSecondView{
   
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    //按钮的宽
    const NSInteger ButtonWith = (ScreenWith - 2 * Margion - 3 * MaxMargion) / Number;
    //按钮的高
    const NSInteger ButtonHeight = ButtonWith ;
   
//    for (NSString * titleString in )
    int max = (int)self.secondTitleArray.count;
    if (max > 8) {
        max = 8;
    }else{
        max = max;
    }
        for (int i = 0 ; i < max; i++)
        {
            NSString *titleString = self.secondTitleArray[i];        
    
        NSInteger index = [self.secondTitleArray indexOfObject:titleString];
        
        //行
        const NSInteger  row = index / Number;
        //列
        const NSInteger  columns = index % Number;
        
        //创建按钮
        AECustomButton * customButton = [AECustomButton buttonWithType:UIButtonTypeCustom];
        customButton.frame = CGRectMake(Margion + columns * (ButtonWith + MaxMargion) , Margion + row * (ButtonWith + Margion), ButtonWith, ButtonHeight);
        customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [customButton setTitle:self.secondTitleArray[index] forState:UIControlStateNormal];
        customButton.titleLabel.font = [UIFont homeButtonTitle];
        [customButton setTitleColor:UIColorFromRGBA(0x000000, 1) forState:UIControlStateNormal];
        if (self.secondImgURLArray.count > 0) {
            [customButton sd_setImageWithURL:self.secondImgURLArray[index] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:self.secondImageArray[index]]];
        }
        else{
        [customButton setImage: [UIImage imageNamed:self.secondImageArray[index]] forState:UIControlStateNormal];
        }
        [customButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        customButton.tag = UIButtonTypeMeiShi + index;
      
        //添加按钮
        [self addSubview:customButton];
    }
    return self;
}

-(void)awakeFromNib{
    
    
}

#pragma mark ---按钮点击事件
-(void) buttonClick:(UIButton *) sender{
    NSInteger index = sender.tag;
    NSLog(@"点击第%ld个按钮————————>",(long)index);
    self.state = index;
    [self callFuncWithNumber:sender];
    
}
#pragma mark---实现协议方法
-(void) callFuncWithNumber:(UIButton *) number{
    
    if ([self.delegate conformsToProtocol:@protocol(AESecondViewDelegate)]) {
        [self.delegate buttonClickWhichOneWithNumber:number];
    }
}
@end
