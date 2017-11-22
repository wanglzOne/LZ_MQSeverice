//
//  OrderNoteViewController.m
//  ArriveEarly
//
//  Created by  YiDaChuXing on 16/12/3.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "OrderNoteViewController.h"
#import "NoteButtton.h"
@interface OrderNoteViewController ()<UITextViewDelegate>
@property (nonatomic, copy) NoteStringBlock block;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *label_count;

@property (weak, nonatomic) IBOutlet NoteButtton *note1;
@property (weak, nonatomic) IBOutlet NoteButtton *note2;
@property (weak, nonatomic) IBOutlet NoteButtton *note3;
@property (weak, nonatomic) IBOutlet NoteButtton *note4;
@property (weak, nonatomic) IBOutlet NoteButtton *note5;
@property (weak, nonatomic) IBOutlet NoteButtton *note6;

@property (strong, nonatomic) NSArray *noteBtns;


@end

@implementation OrderNoteViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cusNavView.titleLabel.text = @"添加备注";
    [self.cusNavView createRightButtonWithTitle:@"完成" image:nil target:self action:@selector(completeButtto) forControlEvents:UIControlEventTouchUpInside];
    self.noteBtns = @[self.note1,self.note2,self.note3,self.note4,self.note5,self.note6];
    self.textView.text = self.noteString;
    self.textView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)setNoteStringBlock:(NoteStringBlock)block
{
    self.block = block;
}

- (IBAction)clickNoteButton:(id)sender {
    UIButton *noteBtn = sender;
    NSString *content = [NSString stringWithFormat:@"%@ %@ ",self.textView.text,[noteBtn titleForState:UIControlStateNormal]];
    if ([content stringByTrimming].length > 50) {
        [self.view showPopupErrorMessage:@"最多50个字"];
        return ;
    }
    self.textView.text = content;
    int length = (int)50-(int)content.length;
    if (length <0 ) {
        length = 0;
    }
    _label_count.text = [NSString stringWithFormat:@"%d/50",length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *content = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (content.length > 50) {
        if (content.length <= textView.text.length) {
            return YES;
        }
        [self.view showPopupErrorMessage:@"最多50个字"];
        return NO;
    }
    _label_count.text = [NSString stringWithFormat:@"%d/50",(int)50-(int)content.length];
    return YES;
    
}



- (void)completeButtto
{
    if (self.textView.text.length > 50) {
        [self.view showPopupErrorMessage:@"最多50个字"];
        return ;
    }
    self.block(self.textView.text);
    [self.navigationController popViewControllerAnimated:YES];
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
