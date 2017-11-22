//
//  AETopCollectionViewController.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AETopCollectionViewController : UIViewController

@property (nonatomic, strong) UICollectionView * topCollectionVC;

-(void)getScrollorImgDataSource:(NSArray *)ary;
@end
