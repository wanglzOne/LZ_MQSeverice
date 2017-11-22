//
//  AETopCollectionViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AETopCollectionViewController.h"
#import "AETopScrollImageCollectionViewCell.h"

@interface AETopCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) NSMutableArray * TopimageArray;//图片数组
@property (nonatomic, strong) NSArray * imageTitleArray;//图片标题数组
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AETopCollectionViewController

-(void)getScrollorImgDataSource:(NSArray *)ary
{
    self.dataSource = [NSMutableArray arrayWithArray:ary];
    
    [self.topCollectionVC reloadData];
    
}

-(UICollectionView *) topCollectionVC{
    
    if (!_topCollectionVC) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(ScreenWith, KHEIGHT_6(255));
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        
        UICollectionView * topCollectionVC = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, KHEIGHT_6(255)) collectionViewLayout:flowLayout];
        _topCollectionVC =topCollectionVC;
        topCollectionVC.bounces = NO;
        topCollectionVC.showsHorizontalScrollIndicator = NO;
        topCollectionVC.delegate = self;
        topCollectionVC.dataSource= self;
        topCollectionVC.pagingEnabled = YES;
    }
    return _topCollectionVC;
}

-(NSArray *)imageTitleArray{
    if (!_imageTitleArray) {
        _imageTitleArray = [NSArray arrayWithObjects:@"banner",@"banner1",@"banner2", nil];
    }
    return _imageTitleArray;
}

-(NSMutableArray *)TopimageArray{
  
    if (!_TopimageArray) {
        _TopimageArray = [NSMutableArray array];
        
        for (NSInteger index = 0; index< self.imageTitleArray.count; index ++) {
        
            UIImage * topImage =[UIImage imageNamed:self.imageTitleArray[index]];
            
            [_TopimageArray addObject:topImage];
        }
        
    }
    return _TopimageArray;
}
static NSString * const reuseIdentifier = @"ITEM";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.topCollectionVC];
    [self.topCollectionVC registerNib:[UINib nibWithNibName:NSStringFromClass([AETopScrollImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
  
}

//进来进行网络请求获取滚动图片

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.dataSource.count == 0) {
        return self.TopimageArray.count;
    }
    else{
    return self.dataSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AETopScrollImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.dataSource.count == 0) {
        cell.topImage = self.TopimageArray[indexPath.item];
    }
    NSString *url = @"";
    if ([self.dataSource[indexPath.item][@"bannerHeadImgUrl"] isKindOfClass:[NSString class]]) {
        url = [self.dataSource[indexPath.item][@"bannerHeadImgUrl"] imageUrl];
    }
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"banner"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
//    cell.cbutton.tag = indexPath.item + 10000;
//    [cell.cbutton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)clickButton:(UIButton *)btn
{
    NSInteger index = btn.tag - 10000;
    NormalWebPageViewController *vc = [[NormalWebPageViewController alloc] initWithNibName:@"NormalWebPageViewController" bundle:nil];
    if ([self.dataSource[index][@"bannerUrl"] isKindOfClass:[NSString class]]) {
        vc.url = self.dataSource[index][@"bannerUrl"];
        vc.url = self.dataSource[index][@"bannerUrl"];
        if ([self.dataSource[index][@"bannerTitle"] isKindOfClass:[NSString class]]){
            vc.cusTitle = self.dataSource[index][@"bannerTitle"];
        }
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:vc animated:YES];
        }
    }

    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    NSLog(@"点击是第几个滚动的图片%ld",index);
    //bannerUrl
    NormalWebPageViewController *vc = [[NormalWebPageViewController alloc] initWithNibName:@"NormalWebPageViewController" bundle:nil];
    if ([self.dataSource[indexPath.item][@"bannerUrl"] isKindOfClass:[NSString class]]) {
        vc.url = self.dataSource[indexPath.item][@"bannerUrl"];
        vc.url = self.dataSource[indexPath.item][@"bannerUrl"];
        if ([self.dataSource[indexPath.item][@"bannerTitle"] isKindOfClass:[NSString class]]){
            vc.cusTitle = self.dataSource[indexPath.item][@"bannerTitle"];
        }
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:vc animated:YES];
        }
    }
    
    
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
