//
//  CustomBaiDuMapView.h
//  ETPassenger
//
//  Created by  YiDaChuXing on 16/10/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationManager.h"

typedef void(^RregionDidChangeBlock)(LocationManager *locationManager);

typedef void(^SlidingChoiceUpdateArressblock)(CLLocationCoordinate2D corr2d);

@interface CustomBaiDuMapView : UIView

@property (nonatomic, strong) BMKMapView *mapBMKView;


@property (nonatomic, strong) LocationManager *location_once;

@property (nonatomic, copy)SlidingChoiceUpdateArressblock slidingChoiceUpdateArressblock;
- (void)beginSlidingChoiceUpdateArress:(SlidingChoiceUpdateArressblock)slidingChoiceUpdateArressblock;
//@property (nonatomic, strong) NSArray<BMKPoiInfo*>* poiList;

- (void)createPinChooseLocationView;


- (void)setRregionDidChangeBlock:(RregionDidChangeBlock)block;

- (void)setCarforData:(NSDictionary *)carInfoDict;

- (void)viewWillAppear;

- (void)clear;
- (BMKPointAnnotation *)addAnnotation:(CLLocationCoordinate2D)corr annoType:(int)type annoEntity:(BMKPointAnnotation *)currP;
- (void)showUserPosition;

- (void)setPositonfor:(CLLocationCoordinate2D)corr andImageName:(NSString *)name;

-(void)setShowsUserLocationIsShow:(BOOL)show;

@end
