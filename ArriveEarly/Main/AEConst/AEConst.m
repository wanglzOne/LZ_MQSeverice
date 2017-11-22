//
//  AEConst.m
//  ArriveEarly
//
//  Created by chenxianwu on 16/9/18.
//  Copyright © 2016年 YiDaTianCheng. All rights reserved.
//

#import "AEConst.h"

/****  baseurl  ****/

//@"http://www.girlboy.cn:7723"//外网服务器
NSString* const KConvention = @"MQ";
NSString* const KEY_Umeng = @"582587f4734be41ecb000130";
NSString* const KBaseU = @"mq/api/";
NSString* const KBaseMQ = @"mq";
NSString* const KProductPhoneNumber = @"400-888-0572";

#ifdef DEBUG

//NSString* const KBaseIP = @"http://10.143.132.36:80/";

//NSString* const KBaseIP = @"http://10.143.132.154:8080/";

//NSString* const KBaseIP = @"http://10.143.132.177:8080/";
//NSString* const KBaseIP = @"http://192.168.0.106:8080/";

//NSString* const KBaseIP = @"http://www.girlboy.cn:7723/";

NSString* const KBaseIP = @"http://www.myquan.com.cn/";



#else

//NSString* const KBaseIP = @"http://www.girlboy.cn:7723/";

NSString* const KBaseIP = @"http://www.myquan.com.cn/";


//NSString* const KBaseIP = @"http://218.88.22.229:7723/"

//NSString* const KBaseIP = @"http://10.143.132.36:80/";
//NSString* const KBaseIP = @"http://10.143.132.154:8080/";

#endif

NSString* const KChangeAddressNotificationKey = @"ChangeAddressNotificationKey";
NSString* const KLogOutSucess = @"KLogOutSucess";


/********    key   *********///rgh52L6LSvigGprx6vymdX7fAvOh8qkz
NSString* const kBaiduMapKey = @"jpRDMfsPNrIProGkXGaOIB3CZQzBBNdA";

NSString* const kZhiFuBaoKey = @"2016111102733036";
NSString* const kWCHATAPPID = @"wx8482dcf69d4ffc0c";


NSString* const RSAPublicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA22ZB5hNAS7a8MmEQVvzMRBNIDkmTj3c5jNawUie4xKracAqHfOKLtj+ApHngA9gArbwCEsHRROetDFlAomFqpuqi6uWrSTIVP0zZ1QmOEn03sd998Ioi1Uyx9HP/UHg1nx+URLkQrKMYFY0aiTp9Ij89T+adI0pni/xYuwGiY4stw97mIj5lHlS8Iz0cWp01kLNu1MWMVeiXEJYDeaYGHG7q2hhpkJ79jtn5fUI80y0esxdj91XScfB/DTI6tqYBJizX7u/6b82MPMwBRrbXeIBNLcjR4A8EdTbxMY8WSOBqykHjju1TxKmRaDJUGldbuwyzJGHxcIepXb+hLb877QIDAQAB";


//NSString* const RSAPrivateKey = @"MIICXAIBAAKBgQDxMeKP4ZOo5MqyKS0yQrMz+NLYekhUdmI4a+Q9jGiGDPv7+6w1sVE6d5xkdt31DX6C/NfPe956797np602VjIW7Y9LgVJ20rxpvTGsDcIwfAJYCNyQ08rBRQ9Gg29lgAuX7nD/pr5/2IIAlwjvmGO5nf6kxr7WiU4CIKBZSF9eNQIDAQABAoGACkwk7hulYDqUZNLZOSIb4IYpClD+MYz0WJBSqEYMWFzJjVKLYad2Xlao+KkShNnUoucEl7kkIH+JNr6z6HP5o2e72zg/UOR7DsF+GJTtlTy4weDBDCoNTiMnuKFkJZh1pcMQ5MKW4i0jO4fpX6FW4nj9qF6n0xnEqQaRKCh56KkCQQD+OrTnciSSadJRJFXEAOxGbpeeTKBPt/85G9LD9CUh62H3RMLQFUanWXFKpUu7hC2eVjtVI+/MxudyERrGv3+HAkEA8t/wEplmlN4ZHDEDTQid2G/Uxcnc1erZbVA/IPFfDd0Is8X2nlVYTEtzA3owg+Te5079RPAyKijK+El1nofLYwJBAJj5pF9cPItpZ6dxsLXnREVBSLR1MUWm1sl7Z4CHyUw2wdUzJ/Jjywbp+BTNj9t+tqB/DOa3YBUdXqkxh6YuFsMCQAXv12x893b4HuEDibMeXM1nnmnfT1ijTwFPDtv9SneKSaYrVqX0LB5hUcRp/jmbJJ++3I4M2Q0SxjNfiFKBu0UCQBdLndlNg21NDdz6QjGrTH/stjPU5W9JMXU9JMJrOTPy9ztn+bm90DCXWXYwwwVO/XsNOOKfiMldhN9e3HZnGn8=";



//NSString *RSAEncryptorStr = [RSAEncryptor encryptString:@"1234567890" publicKey:RSAPublicKey];
//NSString *strKey  = [RSAEncryptor decryptString:RSAEncryptorStr publicKey:@"siyue"];






const NSInteger HomeTopScrollPictureHeight = 255;
const NSInteger ButtonTitleHeight = 15;
const NSInteger ButtonMargion = 13;
const NSInteger HomeSecondeViewHeight = 180;
const NSInteger HomeThirdViewHeight = 180;
const NSInteger NumberOfPages = 3;
const NSInteger CurrentPage = 0;
const NSInteger EstimatedHeight = 100;
const NSInteger HomeTopSearchBtnWith = 200;
const NSInteger HomeTopSearchBtnHeight = 35;
const NSInteger homeTopSearchCornerRadius = 15;
const NSInteger HomeTopSearchBtnMargion = 15;
const NSInteger Margion = 15;
const NSInteger  MaxMargion = 25;
const NSInteger Number = 4.0 ;
const NSInteger searchClockMargion = 80;
const NSInteger clockWidth = 35;
const NSInteger searchBtnWidth = 30;
