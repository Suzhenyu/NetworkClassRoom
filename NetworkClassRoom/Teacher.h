//
//  Teacher.h
//  NetworkClassRoom
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject

@property (nonatomic, assign) int teacher_id;
@property (nonatomic, copy) NSString *teacher_name;
@property (nonatomic, copy) NSString *teacher_account;
@property (nonatomic, copy) NSString *teacher_password;

@end
