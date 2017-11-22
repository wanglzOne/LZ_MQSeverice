//
//  PicturesChooseView.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/8.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "PicturesChooseView.h"

@interface PicturesChooseView ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIScrollView *contentScview;
@property (nonatomic, strong) UIButton *choosButtton;
@property (nonatomic, strong) NSMutableArray <UIButton*>*pictureButtonArray;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation PicturesChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pictureButtonArray = [[NSMutableArray alloc] init];
        self.contentScview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.contentScview];
        
        [self addButton];
        UIButton *btn = self.pictureButtonArray.lastObject;
        //UIButton *btn = self.pictureButtonArray.lastObject;
        if (self.frame.size.height < CGRectGetMaxY(btn.frame) + 8) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(btn.frame) + 8);
            self.contentScview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
    }
    return self;
}
- (void)setImageDatas:(NSMutableArray <UIImage *>*)datas
{
    if (!datas) {
        return;
    }
    if (self.pictureButtonArray.count > datas.count+1) {
        for (NSInteger i=self.pictureButtonArray.count-1; i > (datas.count+1); i--) {
            UIButton *btn = self.pictureButtonArray[i];
            [self.pictureButtonArray removeObject:btn];
            [btn removeFromSuperview];
        }
    }else if (self.pictureButtonArray.count < datas.count+1)
    {
        NSInteger count = self.pictureButtonArray.count;
        for (NSInteger i=0; i < datas.count+1 - count; i++) {
            [self addButton];
        }
    }
    NSInteger i = 0;
    for (UIImage *image in datas) {
        UIButton * btn = [self.pictureButtonArray objectAtIndex:i];
        btn.selected = YES;
        [btn setImage:image forState:UIControlStateSelected];
        i ++;
    }
    self.images = [[NSMutableArray alloc] initWithArray:datas];
}
#pragma mark - 拍照
- (void)picturesChooseAction:(UIButton *)btn
{
    self.choosButtton = btn;
    [UIAlertController showInViewController:self.superVC withTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相册",@"拍照"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == controller.cancelButtonIndex) {
            return ;
        }
        [self showPic:buttonIndex];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //上传图片
    //[self.imageView setImage:image];
    if (image) {
        [self.choosButtton setImage:image forState:UIControlStateSelected];
        self.choosButtton.selected = YES;
        [self.images addObject:image];
        if (self.choosButtton == self.pictureButtonArray.lastObject) {
            [self addButton];
        }
    }
//    [EncapsulationAFBaseNet changeUserInfo:@{@"url" : @"http://avatar.csdn.net/8/1/3/1_linfeng24.jpg"} onCommonBlockCompletion:^(id responseObject, NSError *error) {
//        if (error) {
//            [[UIApplication sharedApplication].keyWindow showPopupErrorMessage:@"修改用户信息失败..."];
//            return ;
//        }
//        
//        
//        [picker dismissViewControllerAnimated:YES completion:nil];
//    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        int count = self.pictureButtonArray.count % 4;
        if ([self.delegate respondsToSelector:@selector(picturesChooseView:uploadImage:forIndex:)]) {
            [self.delegate picturesChooseView:self uploadImage:image forIndex:self.images.count-1];
        }
        if (count == 1) {
            if ([self.delegate respondsToSelector:@selector(picturesChooseView:uploadUIForPicturesChooseViewHeight:)]) {
                [self.delegate picturesChooseView:self uploadUIForPicturesChooseViewHeight:CGRectGetHeight(self.frame)];
            }
        }
    }];

    
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





- (void)addButton
{
    if (self.images.count >  self.maxImage) {
        return;
    }
        //顺序不能变
    UIButton *btn = [self createButtton];
    btn.frame = [self getPictureButtonFrame];
    [self.contentScview addSubview:btn];
    [self.pictureButtonArray addObject:btn];
    if (self.frame.size.height < CGRectGetMaxY(btn.frame) + 8) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(btn.frame) + 8);
        self.contentScview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    

    
    
}
- (UIButton *)createButtton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"image_add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(picturesChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (CGRect)getPictureButtonFrame
{
    int n = 4;
    int count = (int)self.pictureButtonArray.count;
    int j = count/4;
    CGFloat width = (self.frame.size.width - (n + 1)*8)/n;
    return CGRectMake(8 * (count % 4 + 1) + (count % 4)*width , (j + 1)*8 + j*width, width, width);
}


- (NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
