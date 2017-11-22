//
//  AETopSearchView.h
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/27.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AETopSearchView : UIView
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

+(instancetype) createTopSearchButton;

-(void) SearchViewClickWithTarget:(id) target action:(SEL) action;

@end
