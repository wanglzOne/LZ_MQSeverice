//
//  ChangePasswordViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf_passwork_old;
@property (weak, nonatomic) IBOutlet UITextField *tf_passwork_new;
@property (weak, nonatomic) IBOutlet UITextField *tf_passwork_againNew;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"修改密码";
}
- (IBAction)changeButtonClick:(id)sender {
    UIButton *btn = sender;
    if (_tf_passwork_old.text.length<=0) {
        [self.view showPopupErrorMessage:@"请输入旧密码..."];
        return;
    }
    if (![_tf_passwork_new.text isEqualToString:_tf_passwork_againNew.text]) {
        [self.view showPopupErrorMessage:@"新密码不一致..."];
        return;
    }
    if (![_tf_passwork_new.text isEqualToString:_tf_passwork_againNew.text] || _tf_passwork_againNew.text.length<6 || _tf_passwork_againNew.text.length > 20) {
        [self.view showPopupErrorMessage:@"请按照规则进行..."];
        return;
    }
    //注意更新本地的数据 ArriveEarlyManager -> userinfo
    btn.userInteractionEnabled = NO;
    WEAK(weakSelf);
    kShowProgress(self);
    //@"password" ,@"newPassword",@"oldPassword"
    [EncapsulationAFBaseNet changeUserInfo:@{@"password" : _tf_passwork_new.text,@"oldPassword" : _tf_passwork_old.text,@"newPassword":_tf_passwork_new.text} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);
        
        if (error) {
            btn.userInteractionEnabled = YES;
            [self.view showPopupErrorMessage:error.domain];
            return ;
        }
        [self.view showMsg:@"恭喜修改密成功" withBlock:^{
            btn.userInteractionEnabled = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
