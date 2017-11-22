//
//  AEIncreaseNewAddressViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEIncreaseNewAddressViewController.h"

@interface AEIncreaseNewAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *FillAddressTextField;//填写收货地址

@property (weak, nonatomic) IBOutlet UITextField *FillPhoneNumber;//填写收货手机号
@property (weak, nonatomic) IBOutlet UITextField *DoorNumber;//具体门牌号

@end

@implementation AEIncreaseNewAddressViewController

- (IBAction)LocationClickButton:(UIButton *)sender {
    //点击选择
}
- (IBAction)BackButton:(UIButton *)sender {
    //返回按钮
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)SaveButton:(UIButton *)sender {
    //保存按钮 ，点击保存将保存好的数据传给上一页
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
