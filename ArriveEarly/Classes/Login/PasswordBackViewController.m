//
//  PasswordBackViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/5.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PasswordBackViewController.h"

#import "VerificationCodeButton.h"

@interface PasswordBackViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet UITextField *tf_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *tf_againPassword;
//把请求封装进 but中 就不用去处理了
@property (weak, nonatomic) IBOutlet VerificationCodeButton *butttonCode;

@end

@implementation PasswordBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavigationWithTitle:@"找回密码"];
    self.cusNavView.backgroundColor = [UIColor whiteColor];
    [self.view setBackgroundColor:Color_Nolmal_BGColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)getVerificationCodeAction:(id)sender {
    
    if (![_tf_phoneNumber.text isChineseCellPhoneNumber]) {
        [self.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    WEAK(weakSelf);
    kShowProgress(self);
    [EncapsulationAFBaseNet getCodeWithPhoneNumber:_tf_phoneNumber.text type:4 onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);
        if (error) {
            [weakSelf.view showPopupOKMessage:error.domain];
            return ;
        }
        [weakSelf.butttonCode beginCountdown:90];
        [weakSelf.view showPopupOKMessage:@"获取验证码成功，请注意查收..."];
    }];
    
}
- (IBAction)confirmAction:(id)sender {
    
    if (![_tf_phoneNumber.text isChineseCellPhoneNumber]) {
        [self.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    if (_tf_code.text.length == 0) {
        [self.view showPopupOKMessage:@"请输入验证码..."];
        return;
    }
    if (_tf_newPassword.text.length<6 || _tf_newPassword.text.length>20) {
        [self.view showPopupOKMessage:@"请输入满足规则的密码密码..."];
        return;
    }
    if (![_tf_newPassword.text isEqualToString:_tf_againPassword.text]) {
        [self.view showPopupOKMessage:@"两次输入的密码不一致"];
        return;
    }
    
    //NSDictionary *parameter = [ArriveEarlyManager loginParamsHelperWithUserName:_tf_phoneNumber.text password:_tf_newPassword.text code:_tf_code.text];
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"findBackPass" url_ex] params:@{@"code" : _tf_code.text,@"newPassword" : _tf_newPassword.text,@"userPhone" : _tf_phoneNumber.text} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        
        [self.view showMsg:@"恭喜修改成功" withBlock:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
       
        
        
    }];
    
    
}
- (IBAction)frogetPhoneNumberAction:(id)sender {
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.butttonCode clearTimer];
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
