//
//  LoginViewController.m
//  NetworkClassRoom
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "StudentCourseController.h"
#import "StudentOperationController.h"
#import "StudentMeController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)loginAction:(UIButton *)sender {
    UITabBarController *tabbarControl = [[UITabBarController alloc] init];
    tabbarControl.viewControllers = @[[StudentCourseController new],
                                      [StudentOperationController new],
                                      [StudentMeController new]];
    
    UINavigationController *navControl
    = [[UINavigationController alloc] initWithRootViewController:tabbarControl];
    
    [self presentViewController:navControl animated:YES completion:nil];
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
