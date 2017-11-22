//
//  CustomBaiDuMapView.m
//  ETPassenger
//
//  Created by  YiDaChuXing on 16/10/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "CustomBaiDuMapView.h"

#import "PinChooseLocationView.h"

#import "LocationManager.h"

static const int CUSRouteAnnotation_carType = 1000;

static const int CUSRouteAnnotation_exp = 1001;
static const int CUSRouteAnnotation_user = 1002;
static const int CUSRouteAnnotation_mq = 1003;


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
@interface CUSRouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点     10:我的位置           1000:表示 其他车
    int _degree;
    int _cuscartype;
    int _mytag;
}
@property (nonatomic) int mytag;

@property (nonatomic) int type;

@property (nonatomic) int degree;

@property (nonatomic) int cuscartype;

@end

@implementation CUSRouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@synthesize cuscartype = _cuscartype;
@end



@interface CustomBaiDuMapView ()<BMKMapViewDelegate,CLLocationManagerDelegate>
{
    PinChooseLocationView *_pinChooseLocationView;
}
@property (nonatomic, strong) CUSRouteAnnotation *position;
@property (nonatomic, strong) CUSRouteAnnotation *userPosition;

@property (nonatomic, copy) RregionDidChangeBlock block;
@end

@implementation CustomBaiDuMapView

//setTrafficEnabled 实时路况
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mapBMKView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mapBMKView.zoomLevel = 19.0 ;
//        [self.mapBMKView setMapType:BMKMapTypeStandard];
//        
//        
//        [self.mapBMKView setRegion:BMKCoordinateRegionMake([LocationManager sharedManager].coordinate, BMKCoordinateSpanMake(100, 100)) animated:YES];
        self.mapBMKView.showsUserLocation = YES;
        self.mapBMKView.buildingsEnabled = NO;
        
         [self.mapBMKView setShowsUserLocation:YES];//显示定位的蓝点儿
        DLog(@"%f -- %f",[LocationManager sharedManager].coordinate.latitude,[LocationManager sharedManager].coordinate.longitude);
        
        [self addSubview:self.mapBMKView];
        [self viewWillAppear];
        
        [self.mapBMKView setCenterCoordinate:[LocationManager sharedManager].coordinate animated:NO];
        //[self showUserPosition];
        
    }
    return self;
}

-(void)setShowsUserLocationIsShow:(BOOL)show{
    [self.mapBMKView setShowsUserLocation:show];//显示定位的蓝点儿
}
- (void)viewWillAppear{
    [self.mapBMKView viewWillAppear];
    self.mapBMKView.delegate = self ;
    self.mapBMKView.zoomLevel = 19.0 ;
}

- (void)showUserPosition
{
    if (!self.userPosition) {
        self.userPosition = [[CUSRouteAnnotation alloc] init];
        self.userPosition.type = CUSRouteAnnotation_user;
    }
    self.userPosition.cuscartype = 0;
    self.userPosition.coordinate =  [LocationManager sharedManager].coordinate;
    [self.mapBMKView addAnnotation:self.userPosition];
}
- (void)setPositonfor:(CLLocationCoordinate2D)corr andImageName:(NSString *)name
{
    //[self showUserPosition];
    [self.mapBMKView setCenterCoordinate:corr];
    if (!self.position) {
        self.position = [[CUSRouteAnnotation alloc] init];
        self.position.type = CUSRouteAnnotation_exp;
    }
    self.position.cuscartype = 0;
    self.position.coordinate =  corr;
    [self.mapBMKView addAnnotation:self.position];
}



- (BMKPointAnnotation *)addAnnotation:(CLLocationCoordinate2D)corr annoType:(int)type annoEntity:(BMKPointAnnotation *)currP
{
    //[self showUserPosition];
    if(currP) [self.mapBMKView removeAnnotation:currP];
    [self.mapBMKView setCenterCoordinate:corr];
    
        CUSRouteAnnotation * tempAnno = [[CUSRouteAnnotation alloc] init];
        tempAnno.type = type;
    
    tempAnno.cuscartype = 0;
    tempAnno.coordinate =  corr;
    [self.mapBMKView addAnnotation:tempAnno];
    return tempAnno;
}
- (void)setRregionDidChangeBlock:(RregionDidChangeBlock)block
{
    self.block = block;
    WEAK(weakSelf);
    [_location_once startLocateAndGeoCurrentCityLocationWithSuccess:^{
        if (weakSelf.block) {
            weakSelf.block(weakSelf.location_once);
        }
    } failure:^(NSError *error) {
        if (weakSelf.block) {
            weakSelf.block(weakSelf.location_once);
        }
    }];
}
//地图设置点
- (void)setCarforData:(NSDictionary *)carInfoDict
{
    NSArray *taxis = carInfoDict[@"taxis"];
    if (taxis.count) {
        [self.mapBMKView removeAnnotations:self.mapBMKView.annotations];
        /*
        NSMutableArray *ma = [[NSMutableArray alloc] initWithCapacity:taxis.count];
        CUSRouteAnnotation *point = [[CUSRouteAnnotation alloc] init];
        point.type = CUSRouteAnnotation_carType;
        point.cuscartype = 0;
        CLLocationCoordinate2D loca2d = CLLocationCoordinate2DMake(taxiInfo.latitude, taxiInfo.longitude);
        point.coordinate =  loca2d;
        [ma addObject:point];//startInfo.lng / pow(10, 6)
        [self.mapBMKView addAnnotations:ma];
         */
    }
    
    
}

#pragma mark -------------- 获取屏幕中心点位置经纬度 ---------------------------
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    /**
     *  获取指针附近车辆位置
     */
//    [self loadNearbyTaxi];
    
    //获取屏幕中心点位置经纬度
    CLLocationCoordinate2D mapCooedinate = [mapView convertPoint:_pinChooseLocationView.pinPoing toCoordinateFromView:mapView];
    
    if (self.slidingChoiceUpdateArressblock) {
        
        self.slidingChoiceUpdateArressblock(mapCooedinate);
        
    }
    
    return;
    WEAK(weakSelf);
    if (self.block) {
        self.block(nil);
    }
    
    
    
    
    [_location_once reverseGeoCode:mapCooedinate success:^{
        NSLog(@"%@",_location_once.address);
        STRONG(strong_weakSelf, weakSelf)
        if (weakSelf.block) {
            weakSelf.block(strong_weakSelf->_location_once);
        }
    } failure:^(NSError *error) {
        if (weakSelf.block) {
            weakSelf.block(nil);
        }
    }];
}

#define mark - BMKMapViewDelegate    MapView的Delegate，mapView通过此类来通知用户对应的事件
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CUSRouteAnnotation class]]) {
        return [self getCUSRouteAnnotationView:view viewForAnnotation:(CUSRouteAnnotation*)annotation];
    }
    return nil;
}
- (BMKAnnotationView*)getCUSRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(CUSRouteAnnotation*)routeAnnotation
{
    
    BMKAnnotationView* view = nil;
    
    switch (routeAnnotation.type) {
        case CUSRouteAnnotation_carType://乘客头像
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"map_center"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"map_center"];
                view.image = [UIImage imageNamed:@"ios-地图舒适轿车"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = false;
            }
            view.annotation = routeAnnotation;
            
        }
            break;
        case CUSRouteAnnotation_exp://乘客头像
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"expAddress"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"expAddress"];
                view.image = [UIImage imageNamed:@"expAddress"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = false;
            }
            view.annotation = routeAnnotation;
            
        }
            break;
        case CUSRouteAnnotation_user://
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"userMap"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"userMap"];
                view.image = [UIImage imageNamed:@"userMap"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = false;
            }
            view.annotation = routeAnnotation;//map_center
            
        }
            break;
        case CUSRouteAnnotation_mq://
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"addrMap"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"addrMap"];
                view.image = [UIImage imageNamed:@"per"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = false;
            }
            view.annotation = routeAnnotation;//map_center
            
        }
            break;
        default:
            break;
    }
    
    return view;
}
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}
- (NSString*)getMyBundlePath1_trajectory:(NSString *)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
    return filePath ;
}
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    NSLog(@"paopaoclick");
}


- (void)beginSlidingChoiceUpdateArress:(SlidingChoiceUpdateArressblock)slidingChoiceUpdateArressblock
{
    self.slidingChoiceUpdateArressblock = slidingChoiceUpdateArressblock;
    [self createPinChooseLocationView];
}
- (void)createPinChooseLocationView
{
    if (!_pinChooseLocationView) {
        _pinChooseLocationView = [PinChooseLocationView createPinChooseLocationView];
        _pinChooseLocationView.center = CGPointMake(self.center.x, self.center.y - CGRectGetHeight( _pinChooseLocationView.frame) - 50);
        [self addSubview:_pinChooseLocationView];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)clear
{
    [self.mapBMKView viewWillDisappear];
    
    //_location_once = nil;
    self.mapBMKView.delegate = nil;
   // [self.mapBMKView removeFromSuperview];
    //self.mapBMKView = nil;
}

- (void)dealloc
{
    DLogMethod();
    //[[LocationManager sharedManager] set_didUpdateBMKUserLocationBlock:nil];
}


@end
