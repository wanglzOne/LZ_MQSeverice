//
//  HelpAndFeedbackViewController.m
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "settingTableViewCell.h"
@interface HelpAndFeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView_content;
@property (weak, nonatomic) IBOutlet UILabel *LABEL_message;
@property (weak, nonatomic) IBOutlet UILabel *label_count;


@end

@implementation HelpAndFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cusNavView.titleLabel.text = @"意见反馈";
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textView_content becomeFirstResponder];
}

- (IBAction)commitAction:(id)sender {
    if (_textView_content.text.length > 255) {
        [self.view showPopupErrorMessage:@"意见或反馈最多255个字"];
        return;
    }
    if (!_textView_content.text.length) {
        [self.view showPopupErrorMessage:@"请填写您的宝贵建议"];
        return;
    }
    [self.view endEditing:YES];
    NSDictionary *param = [[NSDictionary alloc] init];
    NSString *token = [ArriveEarlyManager shared].userLogData.userToken;
    if (!token) {
        token = @"";
    }
    WEAK(weakSelf);
    UIButton *btn = sender;
    btn.userInteractionEnabled = NO;
    kShowProgress(self);
    [[[AFBaseNetWork alloc] init] post:[@"suggest" url_ex] params:@{@"content":_textView_content.text, @"token" : token} progress:nil onCompletion:^(NSDictionary *dic) {
        kHiddenProgress(weakSelf);

        if ([dic[@"responseCode"] intValue] != ResponseCodeType_Success) {
            [weakSelf.view showPopupErrorMessage:dic[@"responseDescriptio"]];
            [weakSelf.textView_content becomeFirstResponder];
            btn.userInteractionEnabled = YES;
            return ;
        }
        [weakSelf.view showMsg:@"感谢您的宝贵意见/建议" withBlock:^{
            btn.userInteractionEnabled = YES;
            [weakSelf.navigationController  popViewControllerAnimated:YES];
        }];
        
    } onError:^(NSError *error) {
        kHiddenProgress(weakSelf);
        btn.userInteractionEnabled = YES;
        [weakSelf.view showPopupErrorMessage:error.domain];
        [weakSelf.textView_content becomeFirstResponder];
    }];
    //意见 建议
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (content.length > 255) {
        [self.view showPopupErrorMessage:@"意见或反馈最多255个字"];
        return NO;
    }
    _label_count.text = [NSString stringWithFormat:@"%lu/255",255-content.length];
    return YES;
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
