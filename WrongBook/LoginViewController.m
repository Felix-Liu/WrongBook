//
//  LoginViewController.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/23.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "LoginViewController.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
#define TAB_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 83.0f : 49.0f)
#define STATUS_BAR_HEIGHT (SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define NAVIGATION_BAR_HEIGHT 44.0f
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *accountLbl;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UILabel *passwordLbl;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *signUpBtn;
@property (nonatomic, strong) UIButton *signUpBtn1;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.accountLbl];
    [self.view addSubview:self.accountTF];
    [self.view addSubview:self.passwordLbl];
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.signUpBtn];
    [self.view addSubview:self.signUpBtn1];
    self.view.backgroundColor = [UIColor whiteColor];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UILabel *)accountLbl {
    if (!_accountLbl) {
        _accountLbl = [[UILabel alloc] init];
        _accountLbl.frame = CGRectMake(15, 15 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width - 30, 30);
        _accountLbl.text = @"学号：";
        _accountLbl.textColor = [UIColor blackColor];
        _accountLbl.textAlignment = NSTextAlignmentCenter;
        _accountLbl.font = [UIFont systemFontOfSize:15];
    }
    return _accountLbl;
}

- (UITextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [[UITextField alloc] init];
        _accountTF.frame = CGRectMake(15, 60 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width - 30, 30);
        _accountTF.textColor = [UIColor blackColor];
        _accountTF.returnKeyType = UIReturnKeyDone;
        _accountTF.borderStyle = UITextBorderStyleRoundedRect;
        _accountTF.textAlignment = NSTextAlignmentCenter;
        _accountTF.font = [UIFont systemFontOfSize:15];
        _accountTF.delegate = self;
    }
    return _accountTF;
}

- (UILabel *)passwordLbl {
    if (!_passwordLbl) {
        _passwordLbl = [[UILabel alloc] init];
        _passwordLbl.frame = CGRectMake(15, 105 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width - 30, 30);
        _passwordLbl.text = @"密码：";
        _passwordLbl.textColor = [UIColor blackColor];
        _passwordLbl.textAlignment = NSTextAlignmentCenter;
        _passwordLbl.font = [UIFont systemFontOfSize:15];
    }
    return _passwordLbl;
}

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.frame = CGRectMake(15, 150 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width - 30, 30);
        _passwordTF.textColor = [UIColor blackColor];
        _passwordTF.textAlignment = NSTextAlignmentCenter;
        _passwordTF.font = [UIFont systemFontOfSize:15];
        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTF.returnKeyType = UIReturnKeyDone;
        _passwordTF.secureTextEntry = YES;
        _passwordTF.delegate = self;
    }
    return _passwordTF;
}

- (UIButton *)signUpBtn {
    if (!_signUpBtn) {
        _signUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _signUpBtn.frame = CGRectMake(15, 195 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width - 30, 40);
        [_signUpBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpBtn;
}

- (UIButton *)signUpBtn1 {
    if (!_signUpBtn1) {
        _signUpBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
        _signUpBtn1.frame = CGRectMake(15, 240 + NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width - 30, 40);
        [_signUpBtn1 setTitle:@"注册" forState:UIControlStateNormal];
        [_signUpBtn1 addTarget:self action:@selector(signUpBtn1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpBtn1;
}

- (void)signUpBtn1Pressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignUp" object:nil];
}

- (void)signUpBtnPressed:(id)sender {
    [self.view endEditing:YES];
    if (self.accountTF.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入学号" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.passwordTF.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if ([self isRight]) {
        [self recordLoginStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"登录失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)isRight {
    BOOL right = NO;
    //获取路径对象
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePath = [path stringByAppendingPathComponent:@"account.plist"];
    NSDictionary *accountDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    if ([accountDict[@"account_name"] isEqualToString:self.accountTF.text] && [accountDict[@"account_password"] isEqualToString:self.passwordTF.text]) {
        right = YES;
    }
    return right;
}

- (void)recordLoginStatus {
    //获取路径对象
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePath = [path stringByAppendingPathComponent:@"login_status.plist"];
    
    NSDictionary *loginStatusDict = @{ @"login_status": @"1" };
    [loginStatusDict writeToFile:filePath atomically:YES];
}

@end
