//
//  MineViewController.m
//  早点到APP
//
//  Created by m on 16/9/19.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "MineViewController.h"
#import "settingTableViewCell.h"
#import "TelTableViewCell.h"
#import "TimeTableViewCell.h"
#import "AccountViewController.h"//设置
#import "MyRedPacketViewController.h"//我的红包
#import "MyAddressViewController.h"//我的地址
#import "OnlineCustomerViewController.h"//在线客户
#import "HelpAndFeedbackViewController.h"//帮助反馈
#import "LoginViewController.h"
#import <UIAlertController+Blocks.h>
#import "AboutUSViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MyMessageViewController.h"
#import "AEMyCollectionViewController.h"
#import "AEShareMainView.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UINib *nib;
}

@property (weak, nonatomic) IBOutlet UIButton *headerImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UIImageView *personal_bg;

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UILabel *label_id;

@property(nonatomic,strong)UITableView *settingTableView;


@property(nonatomic,strong) NSDictionary *dataDict;
@property(nonatomic,strong) NSDictionary *imageDataDict;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initInterface];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    WEAK(weakSelf);
    [ArriveEarlyManager loginSuccess:^{
        //刷新页面信息
        [weakSelf refreshUIforLogInSuccess];
    } fail:^{
        [weakSelf refreshUIforLogOutSuccess];
    }];
}
-(void)initData
{
    self.dataDict = @{@(0) : @[@"我的红包",@"我的地址",@"我的收藏",@"分享有礼",@"关于我们"],
                      @(1) : @[@"意见反馈",@"我的消息"],
                      //                      @(2) : @[@"在线客服"],
                      @(2) : @[[NSString stringWithFormat:@"客服电话：%@",KProductPhoneNumber]]};
    self.imageDataDict = @{@(0) : @[@"tb1",@"tb2",@"collect",@"share-btn",@"abputus"],
                           @(1) : @[@"tb3",@"tb4"],
                           //                      @(2) : @[@"tb5"],
                           @(2) : @[@"tb5"]};
}
-(void)initInterface
{
    
    //    self.headerImgBtn.layer.contents = (id)[[UIImage imageNamed:@"metx"] CGImage];
    
    //tableview
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, KScreenWidth, KScreenHeight-199) style:UITableViewStylePlain];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.bounces = NO;
    self.settingTableView.showsVerticalScrollIndicator = NO;
    _settingTableView.rowHeight = KHEIGHT_6(50.0);
    
    [self.settingTableView registerNib:[UINib nibWithNibName:@"settingTableViewCell" bundle:nil] forCellReuseIdentifier:@"settingTableViewCell"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"TelTableViewCell" bundle:nil] forCellReuseIdentifier:@"TelTableViewCell"];
    [self.settingTableView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeTableViewCell"];
    self.settingTableView.rowHeight = KHEIGHT_6(55.0);
    [self.view addSubview:self.settingTableView];
    
    
    //头像
    self.headerImgBtn.layer.cornerRadius = 40;
    self.headerImgBtn.layer.masksToBounds = YES;
    [self.headerImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[ArriveEarlyManager shared].userInfo.url imageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"metx"]];
    self.personal_bg.image = [UIImage imageNamed:@"personal_bg"];
}
//设置按钮跳转
- (IBAction)settingAction:(UIButton *)sender {
    
    [ArriveEarlyManager loginSuccess:^{
        [AccountViewController changeFromeVC:self onCompleteSuccessBlock:^{
            [self refreshUIforLogOutSuccess];
        }];
    } fail:^{
        [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
            [self refreshUIforLogInSuccess];
        }];
    }];
    
    
    
}
#pragma mark ---------UITableViewDelegateDataSource-----------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataDict.allKeys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataDict[@(section)];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHEIGHT_6(10.0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = nil;
    NSArray *content = self.dataDict[@(indexPath.section)];
    NSArray *imgs = self.imageDataDict[@(indexPath.section)];
    if (indexPath.section < 2) {
        static NSString *identifier = @"settingTableViewCell";
        settingTableViewCell *setcell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        setcell.contentLabel.text = content[indexPath.row];
        setcell.imgView.image = [UIImage imageNamed:imgs[indexPath.row]];
        cell = setcell;
    }
    else {
        static NSString *identifier = @"TelTableViewCell";
        TelTableViewCell *telcell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        telcell.label_phone.text = content[indexPath.row];
        telcell.label_phone.textColor = UIColorFromRGBA(0xFFD500, 1);
        cell = telcell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [ArriveEarlyManager loginSuccess:^{
                    //我的优惠券
                    MyRedPacketViewController *vc = [[MyRedPacketViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                } fail:^{
                    [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
                        [self refreshUIforLogInSuccess];
                    }];
                }];
                
            }
            else if (indexPath.row == 1)
            {
                //我的地址
                [ArriveEarlyManager loginSuccess:^{
                    MyAddressViewController *vc = [[MyAddressViewController alloc]init];
                    vc.showType = AddressShowTypeManagement;
                    [self.navigationController pushViewController:vc animated:YES];
                } fail:^{
                    [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
                        [self refreshUIforLogInSuccess];
                    }];
                }];
                
            }
            else if (indexPath.row == 2)
            {
                DLog(@"我的收藏");
                [ArriveEarlyManager loginSuccess:^{
                    AEMyCollectionViewController *vc = [[AEMyCollectionViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                } fail:^{
                    [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
                        [self refreshUIforLogInSuccess];
                    }];
                }];
                
            }
            else if (indexPath.row == 3)
            {
                DLog(@"分享有礼");
                [AEShareMainView showShareViewWith:AEShareTypePersonal];
            }else if (indexPath.row == 4)
            {
                DLog(@"关于我们");
                AboutUSViewController *vc = [[AboutUSViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                //意见反馈
                HelpAndFeedbackViewController *vc = [[HelpAndFeedbackViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if (indexPath.row == 1)
            {
                //我的消息
                [ArriveEarlyManager loginSuccess:^{
                    MyMessageViewController *vc = [[MyMessageViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                } fail:^{
                    [LoginViewController changeFromeVC:self onCompleteSuccessBlock:^{
                        [self refreshUIforLogInSuccess];
                    }];
                }];
                
            }
        }
            break;
            //        case 2:{
            //            //在线客服
            //            OnlineCustomerViewController *vc = [[OnlineCustomerViewController alloc]init];
            //            [self.navigationController pushViewController:vc animated:YES];
            //        }
            //            break;
            
        default:
            break;
    }
    //拨打电话
    if(indexPath.section == 2){
        
       [UIAlertController showActionSheetInViewController:self withTitle:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"客服工作时间（8:00-22:30）" otherButtonTitles:@[KProductPhoneNumber] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
           
       } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
           
            if (buttonIndex == controller.firstOtherButtonIndex) {
                //点击拨打电话
               [UIAlertController showInViewController:self withTitle:@"提示" message:KProductPhoneNumber preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"呼叫"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                   if (buttonIndex == controller.cancelButtonIndex) {
                       return ;
                   }
                   NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",KProductPhoneNumber];
                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
               }];

           }
           
       }];

        
        
    }
}

#pragma mark - 加载页面信息
- (void)refreshUIforLogInSuccess
{
    DLog(@"登录成功更新页面数据");
    [self.logInButton setTitle:@"" forState:UIControlStateNormal];
    [self.headerImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[[ArriveEarlyManager shared].userInfo.url imageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"metx"]];
    
    if ([ArriveEarlyManager shared].userInfo.name.length == 0) {
        // 产生随机码
        int num = (arc4random() % 1000000);
        NSLog(@"number is %.6ld",(long)num);
        self.label_name.text = [NSString stringWithFormat:@"用户%.6ld",(long)num];
    }else{
        
        self.label_name.text = [ArriveEarlyManager shared].userInfo.name;
    }
    
    self.label_id.text = [ArriveEarlyManager shared].userInfo.userPhone;
}

- (void)refreshUIforLogOutSuccess
{
    [self.logInButton setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.headerImgBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"metx"]];
    self.label_name.text = @"";
    self.label_id.text = @"";
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
