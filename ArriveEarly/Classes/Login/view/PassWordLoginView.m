//
//  PassWordLoginView.m
//  ArriveEarly
//
//  Created by m on 2016/11/4.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PassWordLoginView.h"
#import "VerificationCodeButton.h"
#import "AgreementViewController.h"



@interface PassWordLoginView ()
@property (weak, nonatomic) IBOutlet UITextField *tf_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;
@property (weak, nonatomic) IBOutlet VerificationCodeButton *codeButton;

@end

@implementation PassWordLoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+(instancetype)initCustomView
{
    return [[NSBundle mainBundle]loadNibNamed:@"PassWordLoginView" owner:self options:nil].lastObject;
}


- (IBAction)loginAction:(id)sender {
    
    if (![_tf_phoneNumber.text isChineseCellPhoneNumber]) {
        [self.superViewController.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    if (_tf_code.text.length == 0) {
        [self.superViewController.view showPopupOKMessage:@"请输入验证码..."];
        return;
    }
    
    NSDictionary *parameter = [ArriveEarlyManager loginParamsHelperWithUserName:_tf_phoneNumber.text password:@"" code:_tf_code.text];
    
    [self.delegate loginCommitParameter:parameter forTargetView:self];
    
}

- (IBAction)getCodeButtonAction:(id)sender {
    
    if (![_tf_phoneNumber.text isChineseCellPhoneNumber]) {
        [self.superViewController.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    [self showPopupLoading];
    WEAK(weakSelf);
    [EncapsulationAFBaseNet getCodeWithPhoneNumber:_tf_phoneNumber.text type:2 onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self hidePopupLoadingAnimated:YES];
        if (error) {
            [weakSelf.superViewController.view showPopupOKMessage:error.domain];
            return ;
        }
        [weakSelf.codeButton beginCountdown:90];
        [weakSelf.superViewController.view showPopupOKMessage:@"获取验证码成功，请注意查收..."];
    }];
    
}
- (IBAction)serviceAgreementButtonAction:(id)sender {
    [NormalWebPageViewController changefromeVC:self.superViewController andTitle:@"用户协议" andLoadUrl:nil];

}

- (void)clearData
{
    [self.codeButton clearTimer];
}

- (void)dealloc
{
    DLogMethod();
}

@end
