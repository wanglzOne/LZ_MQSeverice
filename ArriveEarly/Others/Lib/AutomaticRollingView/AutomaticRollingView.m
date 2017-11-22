//
//  AutomaticRollingView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/30.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AutomaticRollingView.h"

@interface AutomaticRollingView ()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    int timerCount;
}

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray<UIImageView*> *imgViews;

@property (strong, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) NSArray *placeholderImageNames;
@end

@implementation AutomaticRollingView

- (instancetype) initWithFrame:(CGRect)frame WithNetImageUrls:(NSArray *)imageUrls localPlaceholderImages:(NSArray *)placeholderImageNames
{
    self = [super initWithFrame:frame];
    if (self) {
        timerCount = 0;
        self.imageUrls = imageUrls;
        self.placeholderImageNames = placeholderImageNames;
        
        [self createScrollView];
        [self  setUpTimer];
        
    }
    return self;
}
- (void)refreshWithNetImageUrls:(NSArray *)imageUrls localPlaceholderImages:(NSArray *)placeholderImageNames
{
    for (UIImageView *img in self.imgViews) {
        [img removeFromSuperview];
    }
    
    self.imageUrls = imageUrls;
    self.placeholderImageNames = placeholderImageNames;
    [self createScrollView];
    [self  setUpTimer];
}
- (void)createScrollView
{
    UIScrollView *gdSC = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:gdSC];
    gdSC.backgroundColor = [UIColor clearColor];
    gdSC.pagingEnabled = YES;
    gdSC.showsHorizontalScrollIndicator = NO;
    gdSC.delegate = self;
    gdSC.contentSize = CGSizeMake(self.placeholderImageNames.count * CGRectGetWidth(self.frame), 0);
    self.scrollView = gdSC;
    
    [self initImageView];
    [self createPageControl];
}

- (void)createPageControl {
    if (!_pageControl) {
        UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.frame) - 16,CGRectGetWidth(self.frame), 8)];
        page.pageIndicatorTintColor = [UIColor lightGrayColor];
        page.currentPageIndicatorTintColor =  [UIColor redColor];
        page.currentPage = 0;
        [self addSubview:page];
        _pageControl = page;
    }
    _pageControl.numberOfPages = self.placeholderImageNames.count;
    [self bringSubviewToFront:_pageControl];
}

- (void)initImageView {
    
    NSMutableArray *m = [[NSMutableArray alloc] init];
    int i=0;
    for (id obj in self.placeholderImageNames) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.frame), 0,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        imgView.userInteractionEnabled = YES;
        NSURL *url = nil;
        if (i < self.imageUrls.count) {
            url = [NSURL URLWithString:self.imageUrls[i]];
        }
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:self.placeholderImageNames[i]]];
        
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)]];
        [_scrollView addSubview:imgView];
        [m addObject:imgView];
        i++;
    }
    _imgViews = m;
}



- (void)scorll
{
   // _pageControl.currentPage = timerCount;
    
    [self.scrollView setContentOffset:CGPointMake(timerCount*CGRectGetWidth(self.frame), 0) animated:YES];
    
    timerCount ++;
    if (timerCount == self.placeholderImageNames.count) {
        timerCount = 0;
    }
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)tapG
{
    
}


#pragma mark - 滚动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    timerCount =  scrollView.contentOffset.x/CGRectGetWidth(self.frame);
    _pageControl.currentPage = timerCount;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    int i =  scrollView.contentOffset.x/CGRectGetWidth(self.frame);
//    _pageControl.currentPage = i;
//    timerCount = i;
}
- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}
- (void)setUpTimer {
    if (!self.placeholderImageNames.count) {
        return;
    }
    if (_autoScrollDelay < 0.2) {
        _autoScrollDelay = 5;
    }
    if (_timer) {
        return;
    }
    _timer = [NSTimer timerWithTimeInterval:_autoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc
{
    DLogMethod();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
