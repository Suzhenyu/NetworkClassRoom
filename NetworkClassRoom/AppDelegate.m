//
//  AppDelegate.m
//  NetworkClassRoom
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "UserDataManager.h"
#import "LoginViewController.h"
#import "StudentCourseController.h"
#import "StudentOperationController.h"
#import "StudentMeController.h"
#import "TeacherCourseController.h"
#import "TeacherOperationController.h"
#import "TeacherMeViewController.h"

#import "UserDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [[UserDataManager shareManager] deleteUsernameAndPassword];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setSelfWindowRootViewController];
    
    return YES;
}

- (void)setSelfWindowRootViewController {
    //这里需要判断一下，如果用户未登录，则跳到登录页面；如果已登录，就跳转到对应的身份的首页去
    NSDictionary *userDataDict = [[UserDataManager shareManager] loadUsernameAndPassword];
    if (!userDataDict) {
        self.window.rootViewController = [LoginViewController new];
    }else {
        NSString *status = [userDataDict objectForKey:[UserDataManager shareManager].status];
        if ([status isEqualToString:@"0"]) {        //代表学生
            StudentCourseController *courseControl = [StudentCourseController new];
            courseControl.tabBarItem.title = @"课程";
            StudentOperationController *operationControl = [StudentOperationController new];
            operationControl.tabBarItem.title = @"作业";
            StudentMeController *meControl = [StudentMeController new];
            meControl.tabBarItem.title = @"我的";
            
            UITabBarController *tabbarControl = [[UITabBarController alloc] init];
            tabbarControl.viewControllers = @[courseControl, operationControl, meControl];
            
            UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:tabbarControl];
            self.window.rootViewController = navControl;
        }else if ([status isEqualToString:@"1"]) {  //代表教师
            TeacherCourseController *courseControl = [TeacherCourseController new];
            courseControl.tabBarItem.title = @"课程";
            TeacherOperationController *operationControl = [TeacherOperationController new];
            operationControl.tabBarItem.title = @"作业";
            TeacherMeViewController *meControl = [TeacherMeViewController new];
            meControl.tabBarItem.title = @"我的";
            
            UITabBarController *tabbarControl = [[UITabBarController alloc] init];
            tabbarControl.viewControllers = @[courseControl, operationControl, meControl];
            
            UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:tabbarControl];
            self.window.rootViewController = navControl;
        }else {                                     //莫名错误
            self.window.rootViewController = [LoginViewController new];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
