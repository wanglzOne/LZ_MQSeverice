//
//  AboutUSViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/9.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"关于我们";
    
    [(UIImageView *)self.view setImage:[UIImage imageNamed:@"abontusBGImage.jpg"]];
    
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
