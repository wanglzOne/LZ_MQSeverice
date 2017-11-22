//
//  AEMessageViewController.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/10/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEMessageViewController.h"

@interface AEMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *messageTableView;

@end

@implementation AEMessageViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
//    [self.navigationController setNavigationBarHidden:YES];
}
#pragma mark ---代理数据源方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = @"VIP会员上线了呀!";
    return cell;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
