//
//  NormalWebPageViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/14.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "NormalWebPageViewController.h"

@interface NormalWebPageViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation NormalWebPageViewController
+ (instancetype)changefromeVC:(UIViewController *)superVC andTitle:(NSString *)title andLoadUrl:(NSString *)url
{
    NormalWebPageViewController *vc = [[NormalWebPageViewController alloc] initWithNibName:@"NormalWebPageViewController" bundle:nil];
    vc.url = url;
    vc.cusTitle = title;
    [superVC.navigationController pushViewController:vc animated:YES];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cusNavView.titleLabel.text = self.cusTitle;
    if (!_url) {
        _url = @"http://www.myquan.com.cn/mq/webs/aggreement";
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
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
