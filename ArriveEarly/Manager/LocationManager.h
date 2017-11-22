//
//  LocationManager.h
//  Parking

#import "BaseManger.h"


typedef void(^UserLocationUpdateBlock)(BMKUserLocation*userLocation);



/**
 *  LocationManager : 位置服务逻辑管理器
 */
@interface LocationManager : BaseManger
/**
 *  初始化
 */
+ (instancetype)sharedManager;
- (instancetype)initOther ;


@property (nonatomic,assign) BOOL locationOnce_stopUserLocationService;

/// 是否已有位置信息
- (BOOL)hasLocationInfo;
/**
 *  速度，单位为米/秒
 */
@property (assign, nonatomic) CLLocationSpeed speed;
@property (nonatomic,strong) CLLocation *location;

@property (nonatomic,assign) int locationType;

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subTitle;
//当前城市
@property (nonatomic, copy, readonly) NSString *city;
///省
@property (nonatomic, copy, readonly) NSString *province;
///街道号码
@property (nonatomic, copy, readonly) NSString *streetNumber;
@property (nonatomic, copy, readonly) NSString *streetName;
///区
@property (nonatomic, copy, readonly) NSString *district;
///地址
@property (nonatomic, copy, readonly) NSString *address;
///CLLocationCoordinate2D一个结构体，其中包含 地理坐标使用WGS参数 84参考系<reference frame>
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

///这个是搜索单个经纬度  返回过来的 poi信息数组
///地址周边POI信息，成员类型为BMKPoiInfo
@property (nonatomic, strong) NSArray<BMKPoiInfo*>* poiList;
@property (nonatomic, strong) BMKPoiInfo *poiInfo;

///下面的属性用于 通过 城市 关键字检索的poi信息数组
@property (nonatomic, strong) BMKPoiResult *poiResult;
@property (nonatomic, strong) BMKPoiDetailResult *poiDetailResult;

/**
 *  定位更新
 */
- (void)startLocateAndGeoCurrentCityLocationWithSuccess:(CommonVoidBlock)success failure:(CommonErrorBlock)failure;

/**
 *  根据坐标获取地址详情
 */
- (void)reverseGeoCode:(CLLocationCoordinate2D)coordinate success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure;

- (CLLocationDistance)utilDistanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1
                                         coordinate2:(CLLocationCoordinate2D)coordinate2;
- (void)reverseGeoCodeWithAddress:(NSString *)address andCity:(NSString *)city success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure;
//依据地理名词拿到的检索结果
@property (nonatomic, strong) BMKGeoCodeResult *geoCodeResult;

- (void)stopLocation;

///外部传入经纬度 获取 具体的 地址信息，
- (void)updateLocationMssagefor:(CLLocationCoordinate2D)coordinate Success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure;

- (void)set_didUpdateBMKUserLocationBlock:(UserLocationUpdateBlock)updateBlock;
///poisearch  检索兴趣点
- (void)poiSearch:(NSString *)poiContent forCity:(NSString *)city Success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure;

@end
