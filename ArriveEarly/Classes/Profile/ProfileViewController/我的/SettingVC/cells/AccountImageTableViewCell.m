//
//  AccountImageTableViewCell.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/11/7.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AccountImageTableViewCell.h"
#import <UIButton+WebCache.h>
#import <UIAlertController+Blocks/UIAlertController+Blocks.h>

@implementation AccountImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageButtton.layer.cornerRadius = 25.0;
    self.headImageButtton.layer.masksToBounds = YES;
}

- (void)setHeadUrl:(NSString *)headUrl
{
    _headUrl = headUrl;
    [self.headImageButtton sd_setBackgroundImageWithURL:[NSURL URLWithString:headUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"metx"]];
}
- (IBAction)headImageButtonAction:(id)sender {
//    [self pickerImage];
    WEAK(weakSelf);
    [UIAlertController showInViewController:self.superVC withTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        [weakSelf showPic:buttonIndex];
    }];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //上传图片
    //[self.imageView setImage:image];
    [picker.view showPopupLoading];
    [EncapsulationAFBaseNet uploadImages:@[image] onCommonBlockCompletion:^(id responseObject, NSError *error) {
        if (error) {
            [picker.view hidePopupLoading];

            [picker.view showPopupErrorMessage:error.domain];
            return ;
        }
        NSDictionary *response = responseObject;
        NSString * imgurl = response[@"data"];
        if (![imgurl isKindOfClass:[NSString class]]) {
            [picker.view showPopupErrorMessage:@"上传图片发生错误"];
            return ;
        }
        WEAK(weakSelf);
        [EncapsulationAFBaseNet changeUserInfo:@{@"url" : imgurl} onCommonBlockCompletion:^(id responseObject, NSError *error) {
            if (error) {
                [[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"修改用户信息失败..."];
                return ;
            }
            
            [weakSelf.headImageButtton sd_setBackgroundImageWithURL:[NSURL URLWithString:[imgurl imageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"metx"]];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }];
    
    
    //头像上传成功之后
    //更新用户信息
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)showPic:(NSInteger)buttonIndex
{
    UIImagePickerController  *pic=[[UIImagePickerController alloc] init];
    pic.allowsEditing=YES;
    pic.delegate = self;
    if (buttonIndex==2) {
        //相册
        pic.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.superVC presentViewController:pic animated:YES completion:nil];
    }else if (buttonIndex==3)
    {
        //拍照
        pic.sourceType=UIImagePickerControllerSourceTypeCamera;
        pic.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.superVC presentViewController:pic animated:YES completion:nil];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
