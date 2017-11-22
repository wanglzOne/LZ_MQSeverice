//
//  BaseCustomNavViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/10.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "BaseCustomNavViewController.h"

@interface BaseCustomNavViewController ()

@end

@implementation BaseCustomNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCustomNavigationWithTitle:@""];
    
    self.view.backgroundColor = Color_Nolmal_BGColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
