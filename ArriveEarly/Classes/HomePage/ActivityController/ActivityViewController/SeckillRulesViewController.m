//
//  SeckillRulesViewController.m
//  ArriveEarly
//
//  Created by 王立志 on 2017/2/17.
//  Copyright © 2017年 YiDaTianCheng. All rights reserved.
//

#import "SeckillRulesViewController.h"

@interface SeckillRulesViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SeckillRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.cusNavView.titleLabel.text = @"秒杀规则";
    NSString *url = @"http://www.myquan.com.cn/mq/webs/rbrule";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
