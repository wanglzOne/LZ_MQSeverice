//
//  BaseSettingViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "BaseSettingViewController.h"

@interface BaseSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@end

@implementation BaseSettingViewController

+ (instancetype)changefromeVC:(UIViewController *)superVC andChangeToVCName:(NSString *)toVCName onComplete:(ChangeSuccessBlock)block
{
    Class tovc = NSClassFromString(toVCName);
    BaseSettingViewController *baseVC = [[tovc alloc] initWithNibName:toVCName bundle:nil];
    baseVC.changedBlock = block;
    [superVC.navigationController  pushViewController:baseVC animated:YES];
    return baseVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Color_Nolmal_BGColor;
    self.automaticallyAdjustsScrollViewInsets =     NO;
    self.cusNavView.backgroundColor = [UIColor whiteColor];
    
    _changeButton.layer.cornerRadius = 22.0;
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
