//
//  ActivityConfigModel.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/24.
//  Copyright © 2016年. All rights reserved.
//

#import "ActivityConfigModel.h"

@implementation ImageConfig

@end

@implementation ActivityConfigModel

- (NSArray *)listImage_isCover0
{
    if (_mainUrl_isCover1 && _listImage_isCover0) {
        return _listImage_isCover0;
    }
    NSString *mainUrl = nil;
    self.listImage_isCover0 = nil;
    NSMutableArray *lisImg = [[NSMutableArray alloc] initWithCapacity:self.listImage.count];
    for (ImageConfig *config in self.listImage) {
        if (config.isCover == 1) {
            mainUrl = [config.imageUrl imageUrl];
        }else
        {
            if (config.imageUrl.length) {
                [lisImg addObject:[config.imageUrl imageUrl]];
            }
        }
    }
    _mainUrl_isCover1 = mainUrl;
    return lisImg;
}

- (NSString *)mainUrl_isCover1
{
    if (_mainUrl_isCover1 && _listImage_isCover0) {
        return _mainUrl_isCover1;
    }
    NSString *mainUrl = nil;
    self.listImage_isCover0 = nil;
    NSMutableArray *lisImg = [[NSMutableArray alloc] initWithCapacity:self.listImage.count];
    for (ImageConfig *config in self.listImage) {
        if (config.isCover == 1) {//wlz 1----0
            mainUrl = [config.imageUrl imageUrl];
        }else
        {
            if (config.imageUrl.length) {
                [lisImg addObject:[config.imageUrl imageUrl]];
            }
        }
    }
    _listImage_isCover0 = lisImg;
    return mainUrl;
}


- (long long )countdownSeconds
{
    
    
    return 0;
}

@end
