//
//  StudentMeController.m
//  NetworkClassRoom
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StudentMeController.h"
#import "Student.h"
#import "UserDataManager.h"
#import "LoginViewController.h"

@interface StudentMeController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation StudentMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *studentData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_Student];
    Student *student = [NSKeyedUnarchiver unarchiveObjectWithData:studentData];
    self.nameLabel.text = student.student_name;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.title = @"用户中心";
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}
- (IBAction)leaveloginAction:(id)sender {
    
    //UIAlertControllerStyleAlert 警示框
    UIAlertController *alert1=[UIAlertController alertControllerWithTitle:@"退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert1 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UserDataManager shareManager] deleteUsernameAndPassword];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_Student];
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
