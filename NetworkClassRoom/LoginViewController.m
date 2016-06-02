//
//  LoginViewController.m
//  NetworkClassRoom
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"

#import "UserDataManager.h"

#import "Student.h"
#import "Teacher.h"

#import "StudentCourseController.h"
#import "StudentOperationController.h"
#import "StudentMeController.h"
#import "TeacherCourseController.h"
#import "TeacherOperationController.h"
#import "TeacherMeViewController.h"

const NSTimeInterval kAlertViewInterval = 1.0f;
NSString * const kUserDefaults_Student = @"UserDefaults_Student";
NSString * const kUserDefaults_Teacher = @"UserDefaults_Teacher";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusControl;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)loginAction:(UIButton *)sender {
    NSString *account = self.tfAccount.text;
    NSString *password = self.tfPassword.text;
    NSInteger status = self.statusControl.selectedSegmentIndex;
    if (account == nil || [account isEqualToString:@""]) {
        [self showAlert:@"请输入帐号"];
        
    }else if (password == nil || [password isEqualToString:@""]) {
        [self showAlert:@"请输入密码"];
    }else {
        if (status == 0) {      //学生
            
            NSString *urlString
            = [NSString stringWithFormat:@"http://121.42.162.159/login_student.php?account=%@&password=%@",account,password];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:url
                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       NSDictionary *dataDict
                       = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableLeaves
                                                           error:nil];
                       if ([[dataDict objectForKey:@"code"] isEqualToNumber:@200]) {
                           [[UserDataManager shareManager] saveUsername:account
                                                            andPassword:password
                                                              andStatus:@"0"];
                           NSDictionary *dict = [dataDict objectForKey:@"data"];
                           Student *student = [[Student alloc] init];
                           student.student_id = [[dict objectForKey:@"student_id"] intValue];
                           student.student_name = [dict objectForKey:@"student_name"];
                           student.major_id = [[dict objectForKey:@"major_id"] intValue];
                           student.major_name = [dict objectForKey:@"major_name"];
                           
                           NSData *studentData = [NSKeyedArchiver archivedDataWithRootObject:student];
                           [[NSUserDefaults standardUserDefaults] setObject:studentData
                                                                     forKey:kUserDefaults_Student];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               StudentCourseController *courseControl = [StudentCourseController new];
                               courseControl.tabBarItem.title = @"课程";
                               StudentOperationController *operationControl = [StudentOperationController new];
                               operationControl.tabBarItem.title = @"作业";
                               StudentMeController *meControl = [StudentMeController new];
                               meControl.tabBarItem.title = @"我的";
                               
                               UITabBarController *tabbarControl = [[UITabBarController alloc] init];
                               tabbarControl.viewControllers = @[courseControl, operationControl, meControl];
                               
                               UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:tabbarControl];
                               
                               [self presentViewController:navControl animated:YES completion:nil];
                           });
                       }else {
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               [self showAlert:@"帐号或密码不正确，请重试！"];
                           });
                           
                       }
                   }] resume];
            
        }else {                 //教师
            NSString *urlString
            = [NSString stringWithFormat:@"http://121.42.162.159/login_teacher.php?account=%@&password=%@", account, password];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:url
                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        NSDictionary *dataDict
                        = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableLeaves
                                                            error:nil];
                        if ([[dataDict objectForKey:@"code"] isEqualToNumber:@200]) {
                            [[UserDataManager shareManager] saveUsername:account
                                                             andPassword:password
                                                               andStatus:@"1"];
                            
                            NSDictionary *dict = [dataDict objectForKey:@"data"];
                            Teacher *teacher = [[Teacher alloc] init];
                            teacher.teacher_id = [[dict objectForKey:@"teacher_id"] intValue];
                            teacher.teacher_name = [dict objectForKey:@"teacher_name"];
                            
                            NSData *teacherData = [NSKeyedArchiver archivedDataWithRootObject:teacher];
                            [[NSUserDefaults standardUserDefaults] setObject:teacherData
                                                                      forKey:kUserDefaults_Teacher];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                TeacherCourseController *courseControl = [TeacherCourseController new];
                                courseControl.tabBarItem.title = @"课程";
                                TeacherOperationController *operationControl = [TeacherOperationController new];
                                operationControl.tabBarItem.title = @"作业";
                                TeacherMeViewController *meControl = [TeacherMeViewController new];
                                meControl.tabBarItem.title = @"我的";
                                
                                UITabBarController *tabbarControl = [[UITabBarController alloc] init];
                                tabbarControl.viewControllers = @[courseControl, operationControl, meControl];
                                
                                UINavigationController *navControl
                                = [[UINavigationController alloc] initWithRootViewController:tabbarControl];
                                
                                [self presentViewController:navControl animated:YES completion:nil];
                            });
                        }else {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self showAlert:@"帐号或密码不正确，请重试！"];
                            });
                        }
                    }] resume];
        }
    }
}

- (void)showAlert:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:kAlertViewInterval];
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
