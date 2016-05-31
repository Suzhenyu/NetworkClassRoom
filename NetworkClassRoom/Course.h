//
//  Course.h
//  NetworkClassRoom
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic, assign) int course_id;
@property (nonatomic, copy) NSString *course_name;
@property (nonatomic, assign) int teacher_id;
@property (nonatomic, copy) NSString *teacher_name;
@property (nonatomic, copy) NSString *renewdate;

@end
