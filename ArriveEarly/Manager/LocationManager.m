

#import "LocationManager.h"

#import "Foundation+.h"

static NSString * const kUserDefaultKeyForCity      = @"lm_city";
static NSString * const kUserDefaultKeyForProvince  = @"lm_province";
static NSString * const kUserDefaultKeyForLat       = @"lm_lat";
static NSString * const kUserDefaultKeyForLng       = @"lm_lng";


@interface LocationManager () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate>
{

}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;


@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *streetNumber;
@property (nonatomic, copy) NSString *streetName;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *address;



@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) UserLocationUpdateBlock userLocationUpdateBlock;

@property (nonatomic, copy) CommonVoidBlock successBlock;
@property (nonatomic, copy) CommonErrorBlock failureBlock;

@property (nonatomic, copy) CommonVoidBlock poiSuccessBlock;
@property (nonatomic, copy) CommonErrorBlock poiFailureBlock;
@end

@implementation LocationManager

- (void)dealloc
{
    self.geoSearch.delegate = nil;/// 检索模块的Delegate，此处记得不用的时候需要置nil，否则影响内存的释放
    self.locationService.delegate = nil;
}

+ (instancetype)sharedManager {
    static id _sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    
    return _sharedLocationManager;
}

- (instancetype)initOther {
    self = [super init];
    if (self) {
        [self _loadCachedLocationInfo];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.city = @"";
        [self _loadCachedLocationInfo];
    }
    
    return self;
}



- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

#pragma mark - 本地缓存
- (BOOL)hasLocationInfo {
    return [self.city isNotNilOrWhiteSpaceString];
}

- (void)_loadCachedLocationInfo {
    self.city = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultKeyForCity];
    self.province = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultKeyForProvince];
    self.latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultKeyForLat];
    self.longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:kUserDefaultKeyForLng];
}

- (void)_saveCurrentLocationInfoToLocalCache {
    [[NSUserDefaults standardUserDefaults] setObject:self.city forKey:kUserDefaultKeyForCity];
    [[NSUserDefaults standardUserDefaults] setObject:self.province forKey:kUserDefaultKeyForProvince];
    [[NSUserDefaults standardUserDefaults] setDouble:self.latitude forKey:kUserDefaultKeyForLat];
    [[NSUserDefaults standardUserDefaults] setDouble:self.longitude forKey:kUserDefaultKeyForLng];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)set_didUpdateBMKUserLocationBlock:(UserLocationUpdateBlock)updateBlock
{
    self.userLocationUpdateBlock = updateBlock;
}

- (void)poiSearch:(NSString *)poiContent forCity:(NSString *)city Success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure
{
    self.poiSuccessBlock = success;
    self.poiFailureBlock = failure;
    [self _configPoiSearch];
    
    if (!self.city.length) {
        CallFailureOnMainQueueWithError(self.failureBlock, [NSError errorWithCode:-1
                                                             localizedDescription:LocalString(@"搜索失败")]);
        return;
    }
    BMKCitySearchOption *poi = [BMKCitySearchOption new];
    poi.city = city;
    poi.keyword = poiContent;
    poi.pageCapacity = 20;
    
    BOOL flag = [self.poiSearch poiSearchInCity:poi];
    if (!flag) {
        NSError *error = [NSError errorWithCode:-1
                           localizedDescription:LocalString(@"搜索失败")];
        //定位  下面方法void CallFailureOnMainQueueWithError(CommonErrorBlock failure, NSError *error)
        CallFailureOnMainQueueWithError(self.failureBlock, error);
    }
}

#pragma mark - 定位更新
- (void)startLocateAndGeoCurrentCityLocationWithSuccess:(CommonVoidBlock)success failure:(CommonErrorBlock)failure {
    self.successBlock = success;
    self.failureBlock = failure;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        [self _configLocationAndSearchServicesIfNeeded];
        [self.locationService startUserLocationService];
    });

//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//    });
    
    
}

#pragma mark -Location/Geo
- (void)_configLocationAndSearchServicesIfNeeded {
    if (self.geoSearch == nil) {
        self.geoSearch = [[BMKGeoCodeSearch alloc] init];
        self.geoSearch.delegate = self;
    }
    
    if (self.locationService == nil) {
        self.locationService = [[BMKLocationService alloc] init];
        
//        self.locationService.distanceFilter;
//        self.locationService.desiredAccuracy;
//        self.locationService.headingFilter;
//        
//        self.locationService.pausesLocationUpdatesAutomatically;
//        self.locationService.allowsBackgroundLocationUpdates;
        
        self.locationService.delegate = self;
    }
}
- (void)_configPoiSearch
{
    if (self.poiSearch == nil) {
        self.poiSearch = [[BMKPoiSearch alloc] init];
        self.poiSearch.delegate = self;
    }
}

- (CLLocationDistance)_distanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1
                                      coordinate2:(CLLocationCoordinate2D)coordinate2 {
    
    if (!CLLocationCoordinate2DIsValid(coordinate1)
        || !CLLocationCoordinate2DIsValid(coordinate2)) {
        return CLLocationDistanceMax;
    }
    
    BMKMapPoint onePoint = BMKMapPointForCoordinate(coordinate1);
    BMKMapPoint twoPoint = BMKMapPointForCoordinate(coordinate2);
    return BMKMetersBetweenMapPoints(onePoint,twoPoint);;
}

- (CLLocationDistance)utilDistanceBetweenCoordinate1:(CLLocationCoordinate2D)coordinate1
                                         coordinate2:(CLLocationCoordinate2D)coordinate2 {
    return [self _distanceBetweenCoordinate1:coordinate1 coordinate2:coordinate2];
}

#pragma mark -BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (userLocation.location == nil) {
        return;
    }
    
    if (self.locationOnce_stopUserLocationService) {
        [self.locationService stopUserLocationService];
    }

    
    self.speed = userLocation.location.speed;
    
    self.location = userLocation.location;
    
    CLLocationCoordinate2D oldCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    self.title = userLocation.title;
    self.subTitle = userLocation.subtitle;
    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.coordinate = currentCoordinate;
    CLLocationDistance distance = [self _distanceBetweenCoordinate1:oldCoordinate coordinate2:currentCoordinate];
//    if (distance > 50) {
//        CallSuccessOnMainQueue(self.successBlock);
//        return;
//    }
    if (distance < 200 && [self.city isNotNilOrWhiteSpaceString]) {
        CallSuccessOnMainQueue(self.successBlock);
        return;
    }

    if (self.userLocationUpdateBlock) {
        self.userLocationUpdateBlock(userLocation);
    }
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = currentCoordinate;
    BOOL success = [self.geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (!success) {
        NSError *error = [NSError errorWithCode:-1
                           localizedDescription:LocalString(@"定位失败")];
        //定位  下面方法void CallFailureOnMainQueueWithError(CommonErrorBlock failure, NSError *error)
        CallFailureOnMainQueueWithError(self.failureBlock, error);
    }
    
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    DLog(@"定位失败：%@", error.localizedDescription);
    CallFailureOnMainQueueWithError(self.failureBlock, error);
}

#pragma mark -BMKGeoCodeSearchDelegate
//反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error {
    
    if (error == BMK_SEARCH_NO_ERROR) {
        self.city = result.addressDetail.city;
        self.province = result.addressDetail.province;
        self.district = result.addressDetail.district;
        self.streetNumber = result.addressDetail.streetNumber;
        self.streetName = result.addressDetail.streetName;
        self.address = [NSString stringWithFormat:@"%@%@" ,result.addressDetail.streetName, result.addressDetail.streetNumber];
        self.poiList = result.poiList;
        if (result.poiList.count) {
            self.poiInfo = result.poiList[0];
            self.address = self.poiInfo.name;
        }
        CallSuccessOnMainQueue(self.successBlock);
        
        
        
        
//        DLog(@"速度：%f",self.speed);
        return;
    }
    
    NSError *errorInfo = [NSError errorWithCode:-1 localizedDescription:LocalString(@"定位失败")];
    CallFailureOnMainQueueWithError(self.failureBlock, errorInfo);
}
//返回地址信息搜索结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.geoCodeResult = result;
    DLog(@"%@ %@ %f",result,result.address,result.location.longitude);
}


#pragma mark -- BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        self.poiResult = poiResult;
        CallSuccessOnMainQueue(self.poiSuccessBlock);
        return;
    }
    NSError *errorInfo = [NSError errorWithCode:errorCode localizedDescription:LocalString([LocationManager bmkErrStrforErrorCode:errorCode])];
    CallFailureOnMainQueueWithError(self.poiFailureBlock, errorInfo);
}

/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        self.poiDetailResult = poiDetailResult;
        CallSuccessOnMainQueue(self.poiSuccessBlock);
        return;
    }
    NSError *errorInfo = [NSError errorWithCode:errorCode localizedDescription:LocalString([LocationManager bmkErrStrforErrorCode:errorCode])];
    CallFailureOnMainQueueWithError(self.poiFailureBlock, errorInfo);
}


#pragma mark - 根据坐标获取地址详情
- (void)reverseGeoCode:(CLLocationCoordinate2D)coordinate success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure {
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
    self.successBlock = success;
    self.failureBlock = failure;
    [self _configLocationAndSearchServicesIfNeeded];
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
    BOOL successLocal = [self.geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (!successLocal) {
        NSError *error = [NSError errorWithCode:-1
                           localizedDescription:LocalString(@"定位失败")];
        CallFailureOnMainQueueWithError(self.failureBlock, error);
    }
}
#pragma mark - 根据 地理坐标获取 CLLocationCoordinate2D
- (void)reverseGeoCodeWithAddress:(NSString *)address andCity:(NSString *)city success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure
{
    [self _configLocationAndSearchServicesIfNeeded];
    BMKGeoCodeSearchOption *geoCode = [[BMKGeoCodeSearchOption alloc] init];
    //    geoCode.city = @"成都市";
    geoCode.address = @"天府广场";
    [self.geoSearch geoCode:geoCode];
    
}

- (void)updateLocationMssagefor:(CLLocationCoordinate2D)coordinate Success:(CommonVoidBlock)success failure:(CommonErrorBlock)failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    [self _configLocationAndSearchServicesIfNeeded];
    
    CLLocationCoordinate2D oldCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
//    self.title = @"";
//    self.subTitle = userLocation.subtitle;
    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.coordinate = currentCoordinate;
    
//    CLLocationDistance distance = [self _distanceBetweenCoordinate1:oldCoordinate coordinate2:currentCoordinate];
//    if (distance < 200 && [self.city isNotNilOrWhiteSpaceString]) {
//        CallSuccessOnMainQueue(self.successBlock);
//        return;
//    }
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = currentCoordinate;
    BOOL isSuccess = [self.geoSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if (!isSuccess) {
        NSError *error = [NSError errorWithCode:-1
                           localizedDescription:LocalString(@"定位失败")];
        //定位  下面方法void CallFailureOnMainQueueWithError(CommonErrorBlock failure, NSError *error)
        CallFailureOnMainQueueWithError(self.failureBlock, error);
    }

}

- (void)stopLocation
{
    self.geoSearch.delegate = nil;
    self.geoSearch = nil;
    self.locationService.delegate = nil;
    self.locationService = nil;
}

- (int)locationType
{
    // 获取网络情况
    NSArray* subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber* dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = [subview valueForKey:@"dataNetworkType"];
            break;
        }
    }
    if ([dataNetworkItemView integerValue] == 5) {
        return 2;//gps
    }
    return 1;
}

+ (NSString *)bmkErrStrforErrorCode:(BMKSearchErrorCode)errorCode
{
    NSArray *datas = @[@"检索成功",@"检索词有歧义",@"检索地址有岐义",@"该城市不支持公交搜索",@"不支持跨城市公交",@"没有找到检索结果",@"起终点太近",@"key错误",@"网络连接错误",@"网络连接超时",@"还未完成鉴权，请在鉴权通过后重试"];
    if (errorCode<datas.count) {
        return datas[errorCode];
    }
    return @"未知错误";
}
/*
 BMK_SEARCH_NO_ERROR = 0,///<检索结果正常返回
 BMK_SEARCH_AMBIGUOUS_KEYWORD,///<检索词有岐义
 BMK_SEARCH_AMBIGUOUS_ROURE_ADDR,///<检索地址有岐义
 BMK_SEARCH_NOT_SUPPORT_BUS,///<该城市不支持公交搜索
 BMK_SEARCH_NOT_SUPPORT_BUS_2CITY,///<不支持跨城市公交
 BMK_SEARCH_RESULT_NOT_FOUND,///<没有找到检索结果
 BMK_SEARCH_ST_EN_TOO_NEAR,///<起终点太近
 BMK_SEARCH_KEY_ERROR,///<key错误
 BMK_SEARCH_NETWOKR_ERROR,///网络连接错误
 BMK_SEARCH_NETWOKR_TIMEOUT,///网络连接超时
 BMK_SEARCH_PERMISSION_UNFINISHED,///还未完成鉴权，请在鉴权通过后重试

 */

@end
