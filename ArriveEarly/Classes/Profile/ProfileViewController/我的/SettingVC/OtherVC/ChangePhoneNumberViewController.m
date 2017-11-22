//
//  ChangePhoneNumberViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ChangePhoneNumberViewController.h"
#import "VerificationCodeButton.h"

@interface ChangePhoneNumberViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_old_PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *_tf_new_PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet VerificationCodeButton *codeButton;

@end

@implementation ChangePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"更换绑定手机号";
}
- (IBAction)getCode:(id)sender {
    if (![__tf_new_PhoneNumber.text isChineseCellPhoneNumber]) {
        [self.view showPopupErrorMessage:@"请输入正确的手机号码"];
        return;
    }
    WEAK(weakSelf);
    kShowProgress(self);
    [EncapsulationAFBaseNet getCodeWithPhoneNumber:__tf_new_PhoneNumber.text type:3 onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);
        if (error) {
            [weakSelf.view showPopupErrorMessage:error.domain];
            return ;
        }
        [weakSelf.codeButton beginCountdown:90];
        [weakSelf.view showPopupErrorMessage:@"验证码获取成功请注意查收"];
    }];
}
- (IBAction)changeButttonClick:(id)sender {
    if (![self.tf_old_PhoneNumber.text isChineseCellPhoneNumber] || ![__tf_new_PhoneNumber.text isChineseCellPhoneNumber]) {
        [self.view showPopupErrorMessage:@"请输入正确的手机号码"];
        return ;
    }
    if (_tf_code.text.length <= 0) {
        [self.view showPopupErrorMessage:@"请输入验证码"];
        return ;
    }
    UIButton *btn = sender;
    btn.userInteractionEnabled = NO;
    WEAK(weakSelf);
    kShowProgress(self);
    /*
     @"userPhone"
     newPhone
     oldPhone"
     \*/
    [EncapsulationAFBaseNet changeUserInfo:@{@"userPhone" : @"",@"newPhone":__tf_new_PhoneNumber.text,@"oldPhone":_tf_old_PhoneNumber.text,@"code" : _tf_code.text} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);

        if (error) {
            btn.userInteractionEnabled = YES;
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        BLOCK_EXIST(weakSelf.changedBlock,weakSelf,__tf_new_PhoneNumber.text);
        [weakSelf.view showMsg:@"恭喜修改成功" withBlock:^{
            btn.userInteractionEnabled = YES;
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.codeButton clearTimer];
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
