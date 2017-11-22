//
//  TestLoginView.m
//  ArriveEarly
//
//  Created by m on 2016/11/4.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "TestLoginView.h"

#import "PasswordBackViewController.h"

#import "RegistViewController.h"

@interface TestLoginView ()
@property (weak, nonatomic) IBOutlet UITextField *tf_account;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end

@implementation TestLoginView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.descLabel.textColor = HWColor(0x4d, 0x4d, 0x4d);
    [self.registBtn setTitleColor:HWColor(0x4d, 0x2a, 0x00) forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:HWColor(0x4d, 0x2a, 0x00) forState:UIControlStateNormal];
}

+(instancetype)initCustomView
{
    return [[NSBundle mainBundle] loadNibNamed:@"TestLoginView" owner:self options:nil].lastObject;
}

- (IBAction)loginAction:(id)sender {
    if (![_tf_account.text isChineseCellPhoneNumber]) {
        [self.superViewController.view showPopupOKMessage:@"请输入11位手机号码..."];
        return;
    }
    if (_tf_password.text.length == 0) {
        [self.superViewController.view showPopupOKMessage:@"请输入密码..."];
        return;
    }
    
    NSDictionary *parameter = [ArriveEarlyManager loginParamsHelperWithUserName:_tf_account.text password:_tf_password.text code:@""];
    
    [self.delegate loginCommitParameter:parameter forTargetView:self];
    
}

- (IBAction)registAction:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    registVC.dismissVC = self.superViewController;
    [self.superViewController.navigationController pushViewController:registVC animated:YES];
}
- (IBAction)forgotPasswordAction:(id)sender {
    
    PasswordBackViewController *vc = [[PasswordBackViewController alloc] initWithNibName:@"PasswordBackViewController" bundle:nil];
    [self.superViewController.navigationController pushViewController:vc animated:YES];
    
}

@end
