//
//  AppDelegate.m
//  WrongBook
//
//  Created by 刘小飞 on 2018/11/22.
//  Copyright © 2018年 lianlianpay. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AddWrongViewController.h"
#import "MyViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    NSString *filePath = [path stringByAppendingPathComponent:@"account.plist"];
    NSDictionary *accountDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    if (!accountDict) {
        self.window.rootViewController = registerVC;
    } else {
        NSString *filePath1 = [path stringByAppendingPathComponent:@"login_status.plist"];
        NSDictionary *loginStatusDict = [[NSDictionary alloc] initWithContentsOfFile:filePath1];
        if ([loginStatusDict[@"login_status"] isEqualToString:@"1"]) {
            self.window.rootViewController = self.tabBarController;
        } else {
            self.window.rootViewController = loginVC;
        }
    }
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewController) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUp) name:@"SignUp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"LogoutSuccess" object:nil];
    return YES;
}

- (void)changeViewController {
    self.window.rootViewController = self.tabBarController;
}

- (void)logout {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = loginVC;
}

- (void)signUp {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    self.window.rootViewController = registerVC;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

- (UITabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        
        ViewController *mainVC = [ViewController new];
        mainVC.tabBarItem.title = @"错题库";
        mainVC.tabBarItem.image = [UIImage imageNamed:@"icon-tiku"];
        mainVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-tiku-unselect"];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        navController.navigationBar.backgroundColor = [UIColor whiteColor];
        
        AddWrongViewController *addWrongVC = [AddWrongViewController new];
        addWrongVC.tabBarItem.title = @"添加";
        addWrongVC.tabBarItem.image = [UIImage imageNamed:@"icon-add"];
        addWrongVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-add-unselect"];
        UINavigationController *addWrongNavController = [[UINavigationController alloc] initWithRootViewController:addWrongVC];
        addWrongNavController.navigationBar.backgroundColor = [UIColor whiteColor];
        
        MyViewController *myVC = [MyViewController new];
        myVC.tabBarItem.title = @"我";
        myVC.tabBarItem.image = [UIImage imageNamed:@"icon-wo"];
        myVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-wo-unselect"];
        UINavigationController *myNavController = [[UINavigationController alloc] initWithRootViewController:myVC];
        myNavController.navigationBar.backgroundColor = [UIColor whiteColor];
        
        _tabBarController.viewControllers = @[navController, addWrongNavController, myNavController];
        _tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    }
    return _tabBarController;
}


@end
