//
//  ChangeNameViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "ChangeNameViewController.h"

@interface ChangeNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tf_name;

@end

@implementation ChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"修改用户名";
    
    
    
}
- (IBAction)changeEnterAction:(id)sender {
    UIButton *btn = sender;
    if (![_tf_name.text isInputNormalString]) {
        [self.view showPopupErrorMessage:@"不能输入特殊字符串..."];
        return;
    }
    if (_tf_name.text.length<4 || _tf_name.text.length>20) {
        [self.view showPopupErrorMessage:@"请按照规则进行..."];
        return;
    }
    WEAK(weakSelf);
    //注意更新本地的数据 ArriveEarlyManager -> userinfo
//    kShowProgress(self);
    btn.userInteractionEnabled = NO;
    
//    [[AFHTTPSessionManager manager] POST:<#(nonnull NSString *)#> parameters:<#(nullable id)#> progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//
//
    
    
    
    [[EncapsulationAFBaseNet new] changeUserInfo:@{@"name" : _tf_name.text} onCommonBlockCompletion:^(id responseObject, NSError *error) {
//                kHiddenProgress(weakSelf);
        
        if (error) {
            btn.userInteractionEnabled = YES;
            [self.view showPopupErrorMessage:@"修改用户信息失败..."];
            return ;
        }
        BLOCK_EXIST(weakSelf.changedBlock,weakSelf,_tf_name.text);
        [self.navigationController popViewControllerAnimated:YES];
        
                [self.view showMsg:@"恭喜修改成功" withBlock:^{
                    btn.userInteractionEnabled = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
    }];


    

   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DLogMethod();
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
