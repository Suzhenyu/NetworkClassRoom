//
//  Teacher.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.teacher_id forKey:@"teacher_id"];
    [aCoder encodeObject:self.teacher_name forKey:@"teacher_name"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.teacher_id = [aDecoder decodeIntForKey:@"teacher_id"];
        self.teacher_name = [aDecoder decodeObjectForKey:@"teacher_name"];
    }
    return self;
}

@end
