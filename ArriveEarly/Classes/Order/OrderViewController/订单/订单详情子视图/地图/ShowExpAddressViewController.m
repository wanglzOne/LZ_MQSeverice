//
//  ShowExpAddressViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/12.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "ShowExpAddressViewController.h"
#import "CustomBaiDuMapView.h"
@interface ShowExpAddressViewController ()
@property (strong, nonatomic) CustomBaiDuMapView *mapView;
@property (strong, nonatomic) Adress_Info * addressInfo;
@property (strong, nonatomic) BMKPointAnnotation * addr;
@property (strong, nonatomic) BMKPointAnnotation * exp;
/*
 empId = 18228106168;
 empLat = "30.5917700";
 empLon = "104.0611300";
 */
@property (strong, nonatomic) NSMutableDictionary *expNewPositionData;
@end

@implementation ShowExpAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"位置";
    
    [self.cusNavView createRightButtonWithTitle:@"刷新" image:nil target:self action:@selector(texPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _mapView = [[CustomBaiDuMapView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];//200
    [self.view addSubview:_mapView];
    //[self updateExpNewPosition];
    [self getAddressPosition];
    
    
    
}

- (void)texPhoneNumber
{
    [self updateExpNewPosition];
}

- (void)getAddressPosition
{
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findAddress" url_ex] params:@{@"id" : self.orderInfo.booksInfo.addressId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            return ;
        }
        
        NSDictionary *dict = responseObject;
        NSDictionary *data = dict[@"responseData"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            self.addressInfo = [Adress_Info yy_modelWithDictionary:data];
            [self updateExpNewPosition];
        }
    }];
}


- (void)updateExpNewPosition
{
    if (![self.orderInfo.booksInfo.expressId isKindOfClass:[NSString class]] || self.orderInfo.booksInfo.orderStatus != OrderStatus_distributing) {
        //[self.mapView showUserPosition];
        return;
    }
    [EncapsulationAFBaseNet updateExpNewPosition:self.orderInfo.booksInfo.expressId onCommonBlockCompletion:^(id responseObject, NSError *error) {
        
        //[self.mapView showUserPosition];
        
        if (error) {
            return ;
        }
        
        if(self.addressInfo){
            
            self.addr = [self.mapView addAnnotation:CLLocationCoordinate2DMake(self.addressInfo.latitude, self.addressInfo.longtitude) annoType:1003 annoEntity:self.addr];
            
        }

        
        self.expNewPositionData =  [responseObject[@"responseData"] copy];
        if (self.expNewPositionData[@"empLat"] != (id)kCFNull && self.expNewPositionData[@"empLon"] != (id)kCFNull) {
            self.exp = [self.mapView addAnnotation:CLLocationCoordinate2DMake([self.expNewPositionData[@"empLat"] doubleValue], [self.expNewPositionData[@"empLon"] doubleValue]) annoType:1001 annoEntity:self.exp];
            
            
        }
          }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
