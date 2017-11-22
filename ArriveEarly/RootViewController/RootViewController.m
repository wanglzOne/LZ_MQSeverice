//
//  RootViewController.m
//  早点到APP
//
//  Created by m on 16/9/19.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "RootViewController.h"

#import "AEHomeViewController.h"
#import "OrderViewController.h"
#import "AEDiscoverViewController.h"
#import "MineViewController.h"


@interface RootViewController ()
{
    UIButton *_currentButton ;
    NSArray * btns;
}
@property(nonatomic,strong)UIView *customTabBarView ;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
   
}

- (UIViewController *)changeToClass:(Class)cls
{
    UIViewController *ordeVC = self.viewControllers[self.selectedIndex];
    
    if (![ordeVC isKindOfClass:cls]) {
        NSInteger selectedIndex=0;
        for (UIViewController *vcc in self.viewControllers) {
            if ([vcc isKindOfClass:cls]) {
                selectedIndex = [self.viewControllers indexOfObject:vcc];
                break;
            }
        }
        self.selectedIndex = selectedIndex;
        [self changeVC:btns[selectedIndex]];
    }
    return self.viewControllers[self.selectedIndex];
}


#pragma mark --------初始化页面------------
-(void)initInterface
{
    self.tabBar.hidden = YES ;
    _customTabBarView = [[UIView alloc]initWithFrame:self.tabBar.frame];
    _customTabBarView.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    //分割线
    NSMutableArray *btnss = [[NSMutableArray alloc] init];
    UILabel * labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 1)];
    labelLine.backgroundColor = UIColorFromRGBA(0xaeaeab, 1);
    UILabel * labelLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, kScreenSize.width, 1)];
    labelLine.backgroundColor = UIColorFromRGBA(0xefefef, 1);
    [self.customTabBarView addSubview:labelLine];
    [self.customTabBarView addSubview:labelLine2];
    NSArray *ary = @[@"首页",@"发现",@"订单",@"我的"];
    // 循环控制器切换按钮
    for (int i = 0 ; i < 4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom] ;
        button.frame = CGRectMake((i * (kScreenSize.width / 4 )), 0, (kScreenSize.width / 4), 35);
        
        NSString * normalImageName = [NSString stringWithFormat:@"bottom-%d@2x.png",i];
        NSString * selectImageName = [NSString stringWithFormat:@"bottomon-%d@2x.png",i];
        [button setImage:kImageWithName(normalImageName) forState:UIControlStateNormal];
        [button setImage:kImageWithName(selectImageName) forState:UIControlStateDisabled];

        button.tag = 2600 + i ;
        if (i == 0)
        {
            button.enabled = NO ;
            _currentButton.enabled = YES ;
            _currentButton = button ;
        }
        [button addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
        [_customTabBarView addSubview:button];
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake((i * (kScreenSize.width / 4 )), 32, (kScreenSize.width / 4), 14);
        lab.text = ary[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:11];
        lab.textColor = UIColorFromRGBA(0x999999, 1);
        [_customTabBarView addSubview:lab];
        [btnss addObject:button];
    }
    btns = btnss;
    [self.view addSubview:_customTabBarView] ;
    //初始化控制器
    [self initWithControllers] ;
}

-(void)changeVC:(UIButton *)sender
{
    sender.enabled = NO ;
    _currentButton.enabled = YES ;
    _currentButton = sender ;
    self.selectedIndex = sender.tag - 2600 ;
}

-(void)initWithControllers
{
    AEHomeViewController *main = [[AEHomeViewController alloc]initWithNibName:@"AEHomeViewController" bundle:nil];
    
    AEDiscoverViewController *find = [[AEDiscoverViewController alloc]initWithNibName:@"AEDiscoverViewController" bundle:nil];

    //UINavigationController *findnav = [[UINavigationController alloc] initWithRootViewController:find];
    
    
    
    OrderViewController *order = [[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
    
    MineViewController *mine = [[MineViewController alloc]initWithNibName:@"MineViewController" bundle:nil];
    self.viewControllers = @[main,find,order,mine] ;
//    self.selectedIndex = 0 ;
}

-(void)CustomTabBarButtonDidClick:(NSInteger)index
{
    self.selectedIndex = index ;
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
