//
//  RegistViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "RegistViewController.h"
#import "AgreementViewController.h"
#import "VerificationCodeButton.h"
#import "LoginViewController.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UITextField *tf_psaaword;
@property (weak, nonatomic) IBOutlet VerificationCodeButton *button_code;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavigationWithTitle:@"注册"];
    self.cusNavView.backgroundColor = [UIColor clearColor];
    UIImageView* bgimage = (UIImageView *)self.view;
    bgimage.image = [UIImage imageNamed:@"loginBGImage"];
    
}




- (IBAction)getCode:(id)sender {
    if (![_tf_phoneNumber.text isChineseCellPhoneNumber]) {
        [self.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    
    WEAK(weakSelf);
    kShowProgress(self);
    [EncapsulationAFBaseNet getCodeWithPhoneNumber:_tf_phoneNumber.text type:1 onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);
        if (error) {
            [weakSelf.view showPopupOKMessage:error.domain];
            return ;
        }
        [weakSelf.button_code beginCountdown:90];
        [weakSelf.view showPopupOKMessage:@"获取验证码成功，请注意查收..."];
    }];
    
}


- (IBAction)registAction:(id)sender {
    if (![_tf_phoneNumber.text isChineseCellPhoneNumber]) {
        [self.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    if (_tf_code.text.length == 0) {
        [self.view showPopupOKMessage:@"请输入验证码..."];
        return;
    }
    if (_tf_psaaword.text.length == 0) {
        [self.view showPopupOKMessage:@"请输入密码..."];
        return;
    }
    NSDictionary *parameter = [ArriveEarlyManager loginParamsHelperWithUserName:_tf_phoneNumber.text password:_tf_psaaword.text code:_tf_code.text];
    WEAK(weakSelf);
    kShowProgress(self);


    [ArriveEarlyManager registerRequestWith:parameter onComplete:^(id data, NSError *error) {
        kHiddenProgress(weakSelf);
        if (error) {
            [self.view showPopupOKMessage:error.domain];
            return ;
        }
        [[UIApplication sharedApplication].keyWindow showPopupOKMessage:@"恭喜注册成功"];
        [self.navigationController popViewControllerAnimated:NO];
        [self.dismissVC dismissViewControllerAnimated:YES completion:nil];

    }];
}
- (IBAction)argrementAction:(id)sender {
    [NormalWebPageViewController changefromeVC:self andTitle:@"使用协议" andLoadUrl:nil];
    
//    AgreementViewController *vc = [[AgreementViewController alloc] initWithNibName:@"AgreementViewController" bundle:nil];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (IBAction)agreeAndRead:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
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
