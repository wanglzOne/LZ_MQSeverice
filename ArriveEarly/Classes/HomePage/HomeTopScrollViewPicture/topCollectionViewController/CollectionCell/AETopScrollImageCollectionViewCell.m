//
//  AETopScrollImageCollectionViewCell.m
//  自定义collectionViewCell崩溃的问题
//
//  Created by chenxianwu on 16/9/22.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AETopScrollImageCollectionViewCell.h"

@interface AETopScrollImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *scrollImageView;

@end
@implementation AETopScrollImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTopImage:(UIImage *)topImage{
    _topImage = topImage;
    self.scrollImageView.image = topImage;
}
@end
