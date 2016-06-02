//
//  StudentCourseController.m
//  NetworkClassRoom
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StudentCourseController.h"
#import "Student.h"
#import "Course.h"
#import "CourseCell.h"

@interface StudentCourseController ()<UITableViewDataSource, UITableViewDelegate>
{
    Student *_student;
    NSMutableArray *_courseArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StudentCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestCourseDate];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.title = @"全部课程";
}

#pragma mark- request course date
- (void)requestCourseDate {
    NSData *studentData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_Student];
    _student = [NSKeyedUnarchiver unarchiveObjectWithData:studentData];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?student_id=%i", API_ROOTPATH, API_STUDENT_COURSE, _student.student_id];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               NSDictionary *jsonDict
               = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableLeaves
                                                   error:nil];
               if ([[jsonDict objectForKey:@"code"] isEqualToNumber:@200]) {
                   _courseArray = [NSMutableArray array];
                   
                   NSArray *dataArray = [jsonDict objectForKey:@"data"];
                   for (int i = 0; i < dataArray.count; i++) {
                       NSDictionary *dataDict = dataArray[i];
                       Course *course = [Course new];
                       course.course_id = [dataDict[@"course_id"] intValue];
                       course.course_name = dataDict[@"course_name"];
                       course.teacher_id = [dataDict[@"teacher_id"] intValue];
                       course.teacher_name = dataDict[@"teacher_name"];
                       course.renewdate = dataDict[@"renewdate"];
                       [_courseArray addObject:course];
                   }
                   
                   dispatch_sync(dispatch_get_main_queue(),^{
                       [_tableView reloadData];
                   });
                   
               }else {
                   dispatch_sync(dispatch_get_main_queue(), ^{
                       [AlertLabel showText:@"网络数据请求出错，请重试！"
                                         to:self.view
                             hideAfterDelay:kAlertViewInterval];
                   });
                   
               }
           }] resume];
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CourseCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:cellId];
    }
    
    Course *course = _courseArray[indexPath.row];
    [cell setCourseName:course.course_name];
    [cell setRenewDate:course.renewdate];
    [cell setCourseTeacherName:course.teacher_name];
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CourseCell cellHieght];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
