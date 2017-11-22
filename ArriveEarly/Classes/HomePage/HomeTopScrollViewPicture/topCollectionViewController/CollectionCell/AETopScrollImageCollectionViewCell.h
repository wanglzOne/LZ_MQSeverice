//
//  AETopScrollImageCollectionViewCell.h
//  自定义collectionViewCell崩溃的问题
//
//  Created by chenxianwu on 16/9/22.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AETopScrollImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage * topImage;

@property (weak, nonatomic) IBOutlet UIButton *cbutton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end
