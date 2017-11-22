//
//  DiscoverDetailViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 17/1/11.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "DiscoverDetailViewController.h"
#import "CellDetailsViewController.h"
@interface DiscoverDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([_info.id_discover isKindOfClass:[NSString class]]) {
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"foundInfoBody" url_ex] params:@{@"foundId" : _info.id_discover} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            if (error) {
                [self.view showPopupErrorMessage:error.domain];
                return ;
            }
            //        NSMutableString *content = [[NSMutableString alloc] initWithString:@"<html><body>"];
            //        NSDictionary *dict =  responseObject[@"responseData"];
            //        if ([dict isKindOfClass:[NSDictionary class]]) {
            //            [content appendFormat:@"%@%@",dict[@"content"],@"</body></html>"];
            //        }
            NSString *content = @"";
            NSDictionary *dict =  responseObject[@"responseData"];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                content = dict[@"content"];
            }
            [self.webView loadHTMLString:content baseURL:nil];
        }];
    }
    
    
    
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)defialAction:(id)sender {
    if (![self.info.productId isKindOfClass:[NSString class]]) {
        return;
    }
    kShowProgress(self);
    
    ProductModel *model  = [[ProductModel alloc] init];
    model.isActivity = 0;
    model.productId = self.info.productId;
    [EncapsulationAFBaseNet updateProductInfoForProducts:@[model] onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(self);
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        NSDictionary *dict = responseObject;
        if ([dict[@"responseData"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dataDict in dict[@"responseData"] ) {
                ProductModel *model = [ProductModel findById_special_yy_modelWithDictionary:dataDict];
                if (model) {
//                    if (model.productState != ProductState_shelved) {
//                        continue;
//                    }
                    [dataArr addObject:model];
                }
            }
        }
        
        if (dataArr.count) {
            CellDetailsViewController *vc = [[CellDetailsViewController alloc]init];
            vc.dataSource = dataArr;
            vc.isActivity = NO;
            vc.isStart = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self.view showPopupErrorMessage:@"获取商品失败"];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  =YES;
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
