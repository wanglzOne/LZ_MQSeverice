//
//  PaySuccessViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/16.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "RootViewController.h"

#import "OrderViewController.h"

#import "AEShareMainView.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"支付结果";
    [self.cusNavView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [AEShareMainView showShareViewWith:AEShareTypePaySuccess];
    
}



- (IBAction)lookOrder:(id)sender {
    [self backButtonAction];
    
    
}

- (void)backButtonAction
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    UINavigationController *nav = (UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        UIViewController *rootVC = [nav.viewControllers firstObject];
        if ([rootVC isKindOfClass:[RootViewController class]]) {
            RootViewController *root = (RootViewController *)rootVC;
            
            OrderViewController *orderVC = (OrderViewController *)[root changeToClass:[OrderViewController class]];
            [orderVC changetoDetailsOrderViewControllerWithOrderid:self.order.orderId];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showShareView
{
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        if (platformType == UMSocialPlatformType_WechatSession) {
            
            [self shareTextToPlatformType:platformType];
        }
        if (platformType == UMSocialPlatformType_WechatTimeLine) {
            
            [self shareTextToPlatformType:platformType];
        }
        if (platformType ==UMSocialPlatformType_QQ) {
            
            
            [self shareTextToPlatformType:platformType];
        }
        if (platformType == UMSocialPlatformType_Qzone) {
            
            
            
            [self shareTextToPlatformType:platformType];
        }
        
    }];
}
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"保全万岁" descr:@"冯记哥哥爱罗健" thumImage:[UIImage imageNamed:@"AppIcon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
        
        [self alertWithError:error];
    }];
}
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}
//  分享成功 生成红包 
- (void)shareSuccess:(UMSocialPlatformType)platformType
{
    
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
