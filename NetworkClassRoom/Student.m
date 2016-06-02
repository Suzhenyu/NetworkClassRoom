//
//  Student.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.student_id forKey:@"student_id"];
    [aCoder encodeObject:self.student_name forKey:@"student_name"];
    [aCoder encodeInt:self.major_id forKey:@"major_id"];
    [aCoder encodeObject:self.major_name forKey:@"major_name"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.student_id = [aDecoder decodeIntForKey:@"student_id"];
        self.student_name = [aDecoder decodeObjectForKey:@"student_name"];
        self.major_id = [aDecoder decodeIntForKey:@"major_id"];
        self.major_name = [aDecoder decodeObjectForKey:@"major_name"];
    }
    return self;
}

@end
