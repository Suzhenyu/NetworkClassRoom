//
//  TeacherMeViewController.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeacherMeViewController.h"
#import "Teacher.h"
#import "UserDataManager.h"
#import "LoginViewController.h"

@interface TeacherMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TeacherMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *teacherData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_Teacher];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    self.nameLabel.text = teacher.teacher_name;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.title = @"用户中心";
}
- (IBAction)leaveloginAction:(id)sender {

    //UIAlertControllerStyleAlert 警示框
    UIAlertController *alert1=[UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
    [alert1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UserDataManager shareManager] deleteUsernameAndPassword];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_Teacher];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self presentViewController:[LoginViewController new]
                           animated:YES
                         completion:nil];
    }]];
    [alert1 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }]];
        
    [self presentViewController:alert1 animated:YES completion:nil];
}

@end
