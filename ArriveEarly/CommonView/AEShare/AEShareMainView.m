//
//  AEShareMainView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/19.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEShareMainView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"


@interface AEShareMainView ()
@property (strong, nonatomic) ShareConfig *shareConfiginfo;

@property (assign, nonatomic) AEShareType shareType;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgView2;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;



@property (weak, nonatomic) IBOutlet UIButton *cancleButton;




//分享按钮的 背景view
@property (strong, nonatomic) UIView *shareItemBGView;

@property (strong, nonatomic) UIButton *wxFriends;
@property (strong, nonatomic) UIButton *wxChat;
@property (strong, nonatomic) UIButton *qqChat;
@property (strong, nonatomic) UIButton *qqFriends;




@end

@implementation AEShareMainView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.bgView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.50]];
    [self.bgView2 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.50]];
}

+ (instancetype)showShareViewWith:(AEShareType)type
{
    NSString * name = nil;
    if (type == AEShareTypePaySuccess) {
        name = @"AEShareViewType1";//个人中心 分享获取红包
    }
    else if (type == AEShareTypeOrderDetail || type == AEShareTypePersonal) {
        name = @"AEShareViewType1";
    }
    if (!name) {
        return nil;
    }
    AEShareMainView *view = nil;
    if (type == AEShareTypePersonal) {
        view = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil][0];
    }else
    {
        view = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil][1];
    }
    
    view.shareType = type;
    view.frame = [UIScreen mainScreen].bounds;
    [view getConfigWithType:type];
    

    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    return view;
}


- (IBAction)cancleShareButtonAction:(id)sender {
    [self hideSelf];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (IBAction)shareAction:(id)sender {
    UMSocialPlatformType platformType = 0;
    if (sender == self.wxFriends) {
        platformType = UMSocialPlatformType_WechatTimeLine;
    }else if (sender == self.wxChat) {
        platformType = UMSocialPlatformType_WechatSession;
    }else if (sender == self.qqChat) {
        platformType = UMSocialPlatformType_QQ;
    }else if (sender == self.qqFriends) {
        platformType = UMSocialPlatformType_Qzone;
    }
    [self shareTextToPlatformType:platformType];
    //@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]
}



- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    [ArriveEarlyManager loginSuccess:^{
        [self showPopupLoading];
        [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"addRedBag" url_ex] params:@{@"rbConfigId" : self.shareConfiginfo.shareRbConfigId} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            [self hidePopupLoading];
            if (error) {
                
                if (error.code == 7) {
                    [self showMsg:error.domain withBlock:^{
                        [self share:platformType];
                        //[self hideSelf];
                    }];
                }
                else
                {
                    [self showMsg:error.domain withBlock:^{
                        //[self hideSelf];
                        [self share:platformType];
                    }];
                    
                }
                return ;
            }
            [self share:platformType];
            //外面触发一个回调
            [self hideSelf];
        }];
    } fail:^{
        //
        [self showMsg:@"登录之后分享可以获得红包哦!" withBlock:^{
            [self share:platformType];
            [self hideSelf];
        }];
    }];
    
    
    
}

- (void)share:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"卖圈外卖" descr:self.shareConfiginfo.shareName thumImage:[UIImage imageNamed:@"AppIcon"]];
    //设置网页地址
    shareObject.webpageUrl = self.shareConfiginfo.shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
        return ;
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








#pragma mark - config
- (void)getConfigWithType:(AEShareType)type
{
    for (UIView *vi in self.subviews) {
        if (vi != self.bgView) {
            vi.hidden = YES;
        }
    }
    [self showPopupLoading];
    
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[@"queryShare" url_ex] params:@{@"shareType" : @(type)} onCommonBlockCompletion:^(id responseObject, NSError *error) {
        [self hidePopupLoading];
        if (error) {
            [self hideSelf];
            [self showPopupErrorMessage:error.domain];
            return ;
        }
        if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
            self.shareConfiginfo = [ShareConfig yy_modelWithDictionary:responseObject[@"responseData"]];
         NSString* tokenStr = [NSString  stringWithFormat:@"%@%@", @"/", [ArriveEarlyManager shared].userLogData.userToken ];
            
            self.shareConfiginfo.shareUrl =  [NSString stringWithFormat:@"%@%@", self.shareConfiginfo.shareUrl, tokenStr ];
            if ([self.shareConfiginfo.shareId isKindOfClass:[NSString class]] && [self.shareConfiginfo.shareUrl  isKindOfClass:[NSString class]]) {
                for (UIView *vi in self.subviews) {
                    if (vi != self.bgView) {
                        vi.hidden = NO;
                    }
                }
                [self createShareItem];
                //[self showShareContentView];
            }
            else
            {
                [self hideSelf];
            }
        }
        else
        {
            [self hideSelf];
        }
        
    }];
    
}

- (void)showShareContentView
{
    if (![QQApiInterface isQQInstalled])
    {
        self.qqFriends.hidden = YES;
        self.qqChat.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        self.wxChat.hidden = YES;
        self.wxFriends.hidden = YES;
    }
}

- (void)createShareItem
{
    int max = 0;
    if ([QQApiInterface isQQInstalled])
    {
        max = max+1;//不要QQ空间
    }
    if ([WXApi isWXAppInstalled]) {
        max = max+2;//微信 朋友圈
    }
    
    
    if (max == 0) {
        [self showPopupErrorMessage:@"您还没有安装微信/QQ，暂时不能分享获得红包。"];
    }
    
    
    CGFloat height = KHEIGHT_6(52.0);
    
    self.shareItemBGView = [[UIView alloc] init];
    if (self.shareType == AEShareTypePersonal) {
        self.shareItemBGView.frame = CGRectMake(0, 0, 4 * height + 10, height+2);
        self.shareItemBGView.center = CGPointMake(KScreenWidth/2, KHEIGHT_6(440.0)+height/2+1);
    }else
    {
        self.shareItemBGView.frame = CGRectMake(0, 0, KHEIGHT_6(660.0/2), height+2);
        self.shareItemBGView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2 + 107/2.0/1.5);
    }
    
    [self addSubview:self.shareItemBGView];
    CGFloat space = (self.shareItemBGView.frame.size.width  - max * self.shareItemBGView.frame.size.height)/(max+1);
    NSArray *arr = @[@"friends",@"chat",@"QQ",@"kongjian"];
    for (int i=0; i < max; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(space*(1+i) + i*height , 1, height, height);
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if ([WXApi isWXAppInstalled] && [QQApiInterface isQQInstalled]) {
            if (i == 0) {
                self.wxFriends = btn;
            }else if (i == 1) {
                self.wxChat = btn;
            }else if (i == 2) {
                self.qqChat = btn;
            }else if (i == 3) {
                self.qqFriends = btn;
            }
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        }
        else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            self.qqChat = btn;
            [btn setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        }else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            if (i == 0) {
                self.wxFriends = btn;
            }else if (i == 1) {
                self.wxChat = btn;
            }
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        }
        [self.shareItemBGView addSubview:btn];
    }
    
    
    
    
}

- (void)hideSelf
{
    [self removeFromSuperview];
}

@end
