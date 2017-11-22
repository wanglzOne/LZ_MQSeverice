//
//  AccountViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTableViewCell.h"
#import "AccountImageTableViewCell.h"

#import "ChangeNameViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePhoneNumberViewController.h"


@interface AccountViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataArray;
    NSArray *contentArray;
}
@property (nonatomic, copy) LogoutSuccessBlock logoutBlock;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *changeVCNameArray;

@end

@implementation AccountViewController

+ (instancetype)changeFromeVC:(UIViewController *)fromeVC onCompleteSuccessBlock:(LogoutSuccessBlock)block
{
    AccountViewController *logvc = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    logvc.logoutBlock = block;
    [fromeVC.navigationController pushViewController:logvc animated:YES];
    return logvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(25, 25, CGRectGetWidth(footView.frame) - 50, KHEIGHT_6(44.0));
    [btn addTarget:self action:@selector(logOutButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGBA(0x492b00, 1) forState:UIControlStateNormal];
    [btn setBackgroundColor:CUS_Nav_bgColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 22;
    btn.clipsToBounds = YES;
    [footView addSubview:btn];
    self.tableView.tableFooterView = footView;
    
    self.cusNavView.titleLabel.text = @"账号信息";
    self.cusNavView.titleLabel.textColor = UIColorFromRGBA(0x333333, 1);
    [self updateData];
    [_tableView  registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [_tableView  registerNib:[UINib nibWithNibName:@"AccountImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imgCell"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return KHEIGHT_6(71);
    }
    return KHEIGHT_6(50);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//      tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        AccountImageTableViewCell *headcell = [tableView dequeueReusableCellWithIdentifier:@"imgCell" forIndexPath:indexPath];
        headcell.label_title.text = dataArray[indexPath.row];
        headcell.headUrl = contentArray[indexPath.row];
        headcell.superVC = self;
        cell = headcell;
    }else
    {
        AccountTableViewCell *accountcell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        accountcell.label_title.text = dataArray[indexPath.row];
        accountcell.label_content.text = contentArray[indexPath.row];
        cell = accountcell;
    }
 
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        return;
    }
    
    WEAK(weakSelf);
    NSString *name = self.changeVCNameArray[indexPath.row];
    
    [BaseSettingViewController  changefromeVC:self andChangeToVCName:name onComplete:^(UIViewController *targetVienController, id changeContent) {
        [weakSelf updateData];
        [weakSelf.tableView reloadData];
        //更新 dataarray  contentArray
        if ([targetVienController isKindOfClass:[ChangeNameViewController class]]) {
            
        }
        if ([targetVienController isKindOfClass:[ChangePhoneNumberViewController class]]) {
            
        }
    }];
}




- (IBAction)logOutButton:(id)sender {
    WEAK(weakSelf);
    [UIAlertController showInViewController:self withTitle:@"提示" message:@"确定退出登录" preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        [ArriveEarlyManager logOut];
        BLOCK_EXIST(weakSelf.logoutBlock);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)updateData
{
    NSString *name = [ArriveEarlyManager shared].userInfo.name;
    if (name.length == 0) {
        name = [ArriveEarlyManager shared].userInfo.userPhone;
    }
    NSString *phone = [ArriveEarlyManager shared].userInfo.userPhone;
    if (phone.length == 11) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    contentArray = @[[ArriveEarlyManager shared].userInfo.url ? [[ArriveEarlyManager shared].userInfo.url imageUrl] : @"",@"修改",@"",phone];
    NSString *mima = [ArriveEarlyManager shared].userLogData.password.length ? @"修改账户密码" : @"设置账户密码" ;
    mima = @"修改账户密码";
    dataArray = @[@"头像",name,mima,@"已绑定手机号"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)changeVCNameArray
{
    if (!_changeVCNameArray) {
        _changeVCNameArray = @[@"AccountViewController", @"ChangeNameViewController",@"ChangePasswordViewController", @"ChangePhoneNumberViewController"];
    }
    return _changeVCNameArray;
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
