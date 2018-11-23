//
//  MyViewController.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@property (nonatomic, strong) UIButton *signUpBtn;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.signUpBtn];
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

- (UIButton *)signUpBtn {
    if (!_signUpBtn) {
        _signUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _signUpBtn.frame = CGRectMake(15, 195, [UIScreen mainScreen].bounds.size.width - 30, 40);
        [_signUpBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_signUpBtn addTarget:self action:@selector(signUpBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpBtn;
}

- (void)signUpBtnPressed:(id)sender {
    //获取路径对象
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePath = [path stringByAppendingPathComponent:@"login_status.plist"];
    NSDictionary *loginStatusDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    [loginStatusDict setValue:@"0" forKey:@"login_status"];
    BOOL result = [loginStatusDict writeToFile:filePath atomically:YES];
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutSuccess" object:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"退出失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
