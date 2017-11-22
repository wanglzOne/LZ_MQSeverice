//
//  GDScrollBanner.m
//  GDScrollBanner
//
//  Created by xiaoyu on 16/1/29.
//  Copyright © 2016年 Guoda. All rights reserved.
//

#import "GDScrollBanner.h"

#import "UIImageView+WebCache.h"

#define pageSize 16

#define GDWidth self.frame.size.width

#define GDHeight self.frame.size.height

@interface GDScrollBanner ()<UIScrollViewDelegate>
{
    NSArray *_imgViews;
    
}
@property (nonatomic, copy) NSArray *imageData;


@end
@implementation GDScrollBanner{

    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_PageControl;
    
    NSTimer *_timer;
    
    NSInteger _currentIndex;//当前显示的是第几个
    
    NSInteger _MaxImageCount;//图片个数
    
    BOOL _isNetwork;//是否是网络图片
    
}

- (instancetype) initWithFrame:(CGRect)frame WithNetImageUrls:(NSArray *)imageUrl LocalPlaceholderImages:(NSArray *)placeholderImageNames
{
    self = [super initWithFrame:frame];
    if ( self) {
        _isNetwork = YES;
        self.placeImageNames = placeholderImageNames;
        [self createScrollView];
        if (imageUrl.count == 0) {
            imageUrl = @[@""];
        }
        [self setImageData:imageUrl];
        [self setMaxImageCount:_imageData.count];
        
    }
    return self;
}

#pragma mark - 本地图片
- (instancetype) initWithFrame:(CGRect)frame WithLocalImages:(NSArray *)imageNames{

    if (imageNames.count < 2 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        
        _isNetwork = NO;
        
        [self createScrollView]; //创建滚动view
        
        [self setImageData:imageNames];//加入本地image
        
        [self setMaxImageCount:_imageData.count];//设置数量
    }
    
    return self;
    
}
#pragma mark - 网络图片
- (instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageNames {

    if (imageNames.count < 2) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        _isNetwork = YES;
        
        [self createScrollView];
        
        [self setImageData:imageNames];
        
        [self setMaxImageCount:_imageData.count];
        
    }
    return self;
}
#pragma mark - 设置数量
- (void)setMaxImageCount:(NSInteger)MaxImageCount {

    _MaxImageCount = MaxImageCount;
    
    [self initImageView];//复用imageView初始化
    
    [self createPageControl];//pageControl
    
    [self setUpTimer];//定时器
    
    [self changeImageforIndex:0];
}
- (void)createScrollView {
    UIScrollView *gdSC = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:gdSC];
    gdSC.backgroundColor = [UIColor clearColor];
    gdSC.pagingEnabled = YES;
    gdSC.showsHorizontalScrollIndicator = NO;
    gdSC.delegate = self;
    gdSC.contentSize = CGSizeMake(GDWidth * 3, 0);//复用，创建三个
    _AutoScrollDelay = 2.0;
    _currentIndex = 0;//开始显示的是第一个   前一个是最后一个   后一个是第二张
    _scrollView = gdSC;
}
- (void)setImageData:(NSArray *)imageNames {
    
    
    if (_isNetwork) {
        _imageData = [imageNames copy];
//        [self getImage];
    }else {
        //本地
        NSMutableArray *local = [NSMutableArray arrayWithCapacity:imageNames.count];
        for (NSString *name in imageNames) {
            [local addObject:[UIImage imageNamed:name]];
        }
        _imageData = [local copy];
    }



}
- (void)initImageView {
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    int i=0;
    for (id obj in _imageData) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*GDWidth, 0,GDWidth, GDHeight)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
        [_scrollView addSubview:imgView];
        [m addObject:imgView];
        i++;
    }
    _imgViews = m;
}
//点击事件
- (void)imageViewDidTap {
    if (self.smartImgdidSelectAtIndex != nil) {
        self.smartImgdidSelectAtIndex(_currentIndex);
    }
}
- (void)createPageControl {
    UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,GDHeight - pageSize,GDWidth, 7)];
    
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    page.currentPageIndicatorTintColor =  [UIColor redColor];
    page.numberOfPages = _MaxImageCount;
    page.currentPage = 0;
    
    [self addSubview:page];
    
    _PageControl = page;
    
}
#pragma mark - 定时器
- (void)setUpTimer {
    if (_AutoScrollDelay < 0.2) return;//太快了
    if (!_MaxImageCount) {
        return;
    }
    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
- (void)scorll {
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +GDWidth, 0) animated:YES];
}
#pragma mark - 给复用的图赋值
- (void)changeImageforIndex:(NSInteger )index
{
    UIImageView *imgView = _imgViews[index];
    if (_isNetwork) {
        UIImage *placeholderImage = nil;
        if (self.placeImageNames.count > index) {
            placeholderImage = [UIImage imageNamed:self.placeImageNames[index]];
        }else
        {
            placeholderImage = _placeImage;
        }
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:_imageData[index]] placeholderImage:placeholderImage];
        
    }else {
        imgView.image = _imageData[index];
    }
}

#pragma mark - 滚动代理
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}
- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {//开始滚动，判断位置，然后替换复用的三张图
    [self changeImageWithOffset:scrollView.contentOffset.x];
}
- (void)changeImageWithOffset:(CGFloat)offsetX {
    
    int index  = _scrollView.contentSize.width/offsetX;
    
    [self changeImageforIndex:index];
    _currentIndex = index;
    
    _PageControl.currentPage = _currentIndex;
}
-(void)dealloc {
    [self removeTimer];
}
#pragma mark - set方法，设置间隔时间
- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay {
    _AutoScrollDelay = AutoScrollDelay;
    [self removeTimer];
    [self setUpTimer];
}
@end
