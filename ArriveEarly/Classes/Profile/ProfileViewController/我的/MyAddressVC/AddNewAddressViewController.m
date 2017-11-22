//
//  AddNewAddressViewController.m
//  早点到APP
//
//  Created by m on 16/9/20.
//  Copyright © 2016年 easytaxi. All rights reserved.
//

#import "AddNewAddressViewController.h"

#import "ChooseAddressforMapViewController.h"

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface AddNewAddressViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *name_tf;
@property (weak, nonatomic) IBOutlet UIButton *mr_button;
@property (weak, nonatomic) IBOutlet UIButton *ms_button;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *address_tf;
@property (weak, nonatomic) IBOutlet UITextField *hoseNumber_tf;


@property (strong , nonatomic) BMKPoiInfo *poiInfo;

@end

@implementation AddNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    
    if (self.showType == AddNewAddressShowType_Add) {
        self.addressInfo = [Adress_Info new];
        self.cusNavView.titleLabel.text = @"新增地址";
    }else{
        self.cusNavView.titleLabel.text = @"编辑地址";
    }
    
    //初始化 页面 都使用 Adress_Info 对象进行   修改也修改这个对象的属性 以及页面
    
    [self updateData];
    
    
    
}
/*!
 * @abstract Invoked when the picker is closed.
 * @discussion The picker will be dismissed automatically after a contact or property is picked.
 */
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*!
 * @abstract Singular delegate methods.
 * @discussion These delegate methods will be invoked when the user selects a single contact or property.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    //DLog(@"%@",contactProperty.contact);
    if (contactProperty.contact && [contactProperty.contact.phoneNumbers isKindOfClass:[NSArray class]]) {
        
        for (CNLabeledValue *value in contactProperty.contact.phoneNumbers) {
            CNPhoneNumber *phone = (CNPhoneNumber *)[CNLabeledValue localizedStringForLabel:value.value];
            if ([phone isKindOfClass:[CNPhoneNumber class]]) {
                if (phone.stringValue.length) {
                    self.phoneNumber.text = phone.stringValue;
                }
            }
        }
        if (![self.name_tf.text containsString:contactProperty.contact.familyName]) {
            self.name_tf.text = contactProperty.contact.familyName;
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
//取消选择
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openIphoneAddressBook:(UIButton *)sender {
    //CNContactPickerViewController
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
        CNContactPickerViewController *pic = [[CNContactPickerViewController alloc] init];
        pic.delegate = self;
        pic.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:true];
        pic.predicateForSelectionOfContact = [NSPredicate predicateWithValue:false];
        [self presentViewController:pic animated:YES completion:nil];
    }
    else
    {
        ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
        nav.peoplePickerDelegate = self;
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        nav.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:true];
        [self presentViewController:nav animated:YES completion:nil];
    }
    

}
- (IBAction)sexAction:(UIButton *)sender {
    //[self.view endEditing:YES];
    if (self.mr_button == sender) {
        self.mr_button.selected = YES;
        self.addressInfo.sex = 0;
    }else
    {
        self.mr_button.selected = NO;
        self.addressInfo.sex = 1;
    }
    self.ms_button.selected = !self.mr_button.selected;
}

- (IBAction)chooseAddressVC:(id)sender {
    [self.view endEditing:YES];
    [self pushChooseAddressVC];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.address_tf) {
        //[self pushChooseAddressVC];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _name_tf) {
        self.addressInfo.contactName = textField.text;
    }
    if (textField == _phoneNumber) {
        self.addressInfo.contactPhone = textField.text;
    }
    if (textField == _address_tf) {
        self.addressInfo.address = textField.text;
    }
    if (textField == _hoseNumber_tf) {
        self.addressInfo.addressDetail = textField.text;
    }
}

- (void)updateData
{
    if (!self.addressInfo.contactName.length) {
        self.name_tf.text = @"";//[ArriveEarlyManager shared].userInfo.userName
    }else
        self.name_tf.text = self.addressInfo.contactName;
    self.mr_button.selected = self.addressInfo.isMr;
    self.ms_button.selected = !self.addressInfo.isMr;
    if (!self.addressInfo.contactPhone.length) {
        self.phoneNumber.text = [ArriveEarlyManager shared].userInfo.userPhone;
    }else
        self.phoneNumber.text = self.addressInfo.contactPhone;
    self.address_tf.text = self.addressInfo.address;
    self.hoseNumber_tf.text = self.addressInfo.addressDetail;
}

//保存操作
- (IBAction)saveAction:(UIButton *)sender {
    //self.addressInfo 做处理
    ArriveEarlyManager *arrM = [ArriveEarlyManager shared];
    if (!arrM.userLogData.userId || !arrM.userLogData.userToken) {
        [self.view showPopupErrorMessage:@"请登录..."];
    }
    if (!self.phoneNumber.text.length || !self.hoseNumber_tf.text.length ||!self.address_tf.text.length ||!self.name_tf.text.length) {
        [self.view showPopupErrorMessage:@"请填写数据完整"];
        return;
    }
    
    //_address_tf.text
    int sex = (self.mr_button.selected) ? 0 : 1;
    int id_address = [self.addressInfo.id_address intValue];
    NSDictionary *params = @{@"contactPhone":self.phoneNumber.text,
                             @"orderIndex":@(999),
                             @"userId":arrM.userLogData.userId,
                             @"addressDetail" : _hoseNumber_tf.text,
                             @"address":_address_tf.text,
                             @"longtitude":[NSNumber numberWithDouble:_poiInfo.pt.longitude],
                             @"latitude":[NSNumber numberWithDouble:_poiInfo.pt.latitude],
                             @"remark":@"备注",
                             @"sex":@(sex),
                             @"contactName":_name_tf.text,
                             @"id" : @(id_address)};
    NSString *path = @"addUserAddress";
    
    if (self.showType == AddNewAddressShowType_Edite) {
        path = @"updateUserAddress";
    }
    WEAK(weakSelf);
    kShowProgress(self);
    [EncapsulationAFBaseNet dictRequestAndTokenPost:[path url_ex] params:params onCommonBlockCompletion:^(id responseObject, NSError *error) {
        kHiddenProgress(weakSelf);
        
        if (error) {
            [weakSelf.view showPopupErrorMessage:error.domain];
            return ;
        }
        //NSDictionary *dict = responseObject;
        [weakSelf.view showMsg:@"操作成功！" withBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    
}


- (void)pushChooseAddressVC
{
    WEAK(weakSelf);
    ChooseAddressforMapViewController *addressvc = [ChooseAddressforMapViewController chooseAddressFormVC:self onCompleteBlock:^(id param) {
        if ([param isKindOfClass:[BMKPoiInfo class]]) {
            BMKPoiInfo *info = param;
            weakSelf.poiInfo = info;
            NSString *name = [NSString stringWithFormat:@"%@ -- %@",info.address,info.name];
            weakSelf.address_tf.text = name;
            weakSelf.addressInfo.address = name;
        }
    }];
    [addressvc beginSlidingChoiceUdateArress];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

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
