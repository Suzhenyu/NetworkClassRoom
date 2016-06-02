//
//  CourseCell.h
//  NetworkClassRoom
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell

- (void)setCourseName:(NSString *)name;
- (void)setRenewDate:(NSString *)date;
- (void)setCourseTeacherName:(NSString *)name;

- (void)setCourseNameFont:(UIFont *)font;
- (void)setRenewDateFont:(UIFont *)font;
- (void)setCourseTeacherNameFont:(UIFont *)font;

+ (float)cellHieght;

@end
