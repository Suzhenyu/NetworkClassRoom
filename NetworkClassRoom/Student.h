//
//  Student.h
//  NetworkClassRoom
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic, assign) int student_id;
@property (nonatomic, copy) NSString *student_name;
@property (nonatomic, copy) NSString *student_account;
@property (nonatomic, copy) NSString *student_password;
@property (nonatomic, assign) int major_id;
@property (nonatomic, copy) NSString *major_name;

@end
