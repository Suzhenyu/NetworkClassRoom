//
//  CourseCell.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CourseCell.h"

static const float kSpacing = 8.f;
static const float kCourseNameLabel_Height = 30.f;
static const float kRenewDateLabel_Height = 20.f;
static const float kCourseTeacherLabel_Height = kRenewDateLabel_Height;

#define kSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CourseCell ()

@property (nonatomic, strong) UILabel *courseNameLabel;
@property (nonatomic, strong) UILabel *renewDateLabel;
@property (nonatomic, strong) UILabel *courseTeacherLabel;

@end

@implementation CourseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.courseNameLabel];
        [self addSubview:self.renewDateLabel];
        [self addSubview:self.courseTeacherLabel];
    }
    return self;
}

-(UILabel *)courseNameLabel {
    if (!_courseNameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(kSpacing,
                                 kSpacing,
                                 kSCREEN_WIDTH - kSpacing *2,
                                 kCourseNameLabel_Height);
        label.text = @"课程名";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18];
        
        _courseNameLabel = label;
    }
    
    return _courseNameLabel;
}

-(UILabel *)renewDateLabel {
    if (!_renewDateLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(kSpacing,
                                 CGRectGetMaxY(self.courseNameLabel.frame) + kSpacing,
                                 (kSCREEN_WIDTH - kSpacing * 2) / 2.0,
                                 kRenewDateLabel_Height);
        label.text = @"最新更新时间";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        
        _renewDateLabel = label;
    }
    
    return _renewDateLabel;
}

-(UILabel *)courseTeacherLabel {
    if (!_courseTeacherLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetMaxX(self.renewDateLabel.frame),
                                 CGRectGetMinY(self.renewDateLabel.frame),
                                 (kSCREEN_WIDTH - kSpacing * 2) / 2.0,
                                 kCourseTeacherLabel_Height);
        label.text = @"授课老师";
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14];
        
        _courseTeacherLabel = label;
    }
    
    return _courseTeacherLabel;
}

#pragma mark- public
- (void)setCourseName:(NSString *)name {
    self.courseNameLabel.text = name;
}
- (void)setRenewDate:(NSString *)date {
    self.renewDateLabel.text = date;
}
- (void)setCourseTeacherName:(NSString *)name {
    self.courseTeacherLabel.text = name;
}

- (void)setCourseNameFont:(UIFont *)font {
    self.courseNameLabel.font = font;
}
- (void)setRenewDateFont:(UIFont *)font {
    self.renewDateLabel.font = font;
}
- (void)setCourseTeacherNameFont:(UIFont *)font {
    self.courseTeacherLabel.font = font;
}

+ (float)cellHieght {
    return   kSpacing + kCourseNameLabel_Height + kSpacing + kRenewDateLabel_Height + kSpacing;
}

@end
