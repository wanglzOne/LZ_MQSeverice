//
//  LoginViewController.m
//  ArriveEarly
//
//  Created by m on 2016/11/4.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseScrollView.h"
#import "TestLoginView.h"
#import "PassWordLoginView.h"

#import "RegistViewController.h"

@interface LoginViewController ()<BaseScrollViewDelegate, LoginViewControllerDelegate>

@property (nonatomic, copy) LoginSuccessBlock successBlock;
@property (weak, nonatomic) IBOutlet UIButton *rigistButton;

@property (weak, nonatomic) IBOutlet UIView *containView;//底部视图
@property (nonatomic, strong) BaseScrollView *footView;
@property (nonatomic, strong) TestLoginView *testLoginView;
@property (nonatomic, strong) PassWordLoginView *passWordLoginView;

@property (nonatomic, strong) NSMutableArray *subViewsAry;
@property (nonatomic, strong) NSMutableArray *subViewTitleAry;

@end

@implementation LoginViewController

+ (instancetype)changeFromeVC:(UIViewController *)fromeVC onCompleteSuccessBlock:(LoginSuccessBlock)block
{
    LoginViewController *logvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    logvc.successBlock = block;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logvc];
    [fromeVC presentViewController:nav animated:YES completion:nil];
    return logvc;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isDismiss) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.passWordLoginView clearData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* bgimage = (UIImageView *)self.view;
    bgimage.image = [UIImage imageNamed:@"loginBGImage"];
    [self initInterFace];
    
    [self initBaseScrollViewSelectPageNum:0];
}
-(void)initData{
    self.subViewTitleAry = [[NSMutableArray alloc]initWithObjects:@"密码登录", @"短信快捷登录", nil];
    self.testLoginView = [TestLoginView initCustomView];
    self.testLoginView.frame = CGRectMake(0, 0, KScreenWidth - 2*KHEIGHT_6(50), 300);
    self.testLoginView.superViewController  =self;
    self.testLoginView.delegate = self;
    self.passWordLoginView = [PassWordLoginView initCustomView];
    self.passWordLoginView.superViewController  = self;
    self.passWordLoginView.delegate = self;
    
    self.passWordLoginView.frame = CGRectMake(0, 0, KScreenWidth - 2*KHEIGHT_6(50), 300);
    self.subViewsAry = [[NSMutableArray alloc]initWithObjects:self.testLoginView,self.passWordLoginView, nil];
    
    self.passWordLoginView.backgroundColor = [UIColor clearColor];
    self.testLoginView.backgroundColor = [UIColor clearColor];

}
-(void)initInterFace{
    self.footView = [[BaseScrollView alloc] initWithFrame:CGRectMake(KHEIGHT_6(50), KHEIGHT_6(50.0), KScreenWidth - 2*KHEIGHT_6(50), KScreenHeight - 160 )];
    self.footView.delegate = self;
    [self initData];
    [self.footView setSubViewOfScrollerView:_subViewsAry];
    [self.footView setViewsTitle:_subViewTitleAry];
    [self.containView addSubview:self.footView];
    [self.footView setHeaderColor:[UIColor clearColor]];
    self.footView.backgroundColor = [UIColor clearColor];
}
#pragma mark --- BaseScrollViewDelegate
- (void)initBaseScrollViewSelectPageNum:(NSInteger)pageNum
{
    if (pageNum == 0) {
        self.rigistButton.hidden = YES;
    }else
    {
        self.rigistButton.hidden = NO;
    }
}
#pragma mark - login delegate
- (void)loginCommitParameter:(NSDictionary *)parameters forTargetView:(UIView *)targetView
{
    WEAK(weakSelf);
    if (targetView == self.testLoginView) {
        //密码登陆
        kShowProgress(self)
        [ArriveEarlyManager loginRequestWith:parameters onComplete:^(id data, NSError *error) {
            kHiddenProgress(weakSelf);
            if (error) {
                [weakSelf.view showPopupErrorMessage:error.domain];
                return ;
            }
            BLOCK_EXIST(weakSelf.successBlock);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if (targetView == self.passWordLoginView)
    {
        //短信验证码登陆
        kShowProgress(self)
        [ArriveEarlyManager loginRequestWith:parameters onComplete:^(id data, NSError *error) {
            kHiddenProgress(weakSelf);
            if (error) {
                [weakSelf.view showPopupErrorMessage:error.domain];
                return ;
            }
            BLOCK_EXIST(weakSelf.successBlock);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}


- (IBAction)backAct:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registBtutonClick:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    registVC.dismissVC = self;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
