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
#import <RongIMKit/RongIMKit.h>

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
    
    [[RCIM sharedRCIM] initWithAppKey:RONGYUN_APPKEY];
    
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

@end
