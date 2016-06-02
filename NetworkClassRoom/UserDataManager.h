//
//  ImportantDataManager.h
//  Keychain_Demo
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy, readonly) NSString *status;                //0为学生，1为教师

+ (UserDataManager *)shareManager;

/**
 * status 代表身份，『0』为学生，『1』为老师
 */
- (void)saveUsername:(NSString *)username andPassword:(NSString *)password andStatus:(NSString *)status;
/**
 * 返回值是一个字典
 * 通过属性username作为key取得的值是『用户名』
 * 通过属性password作为key取得的值是『密码』
 */
- (NSDictionary *)loadUsernameAndPassword;
- (void)deleteUsernameAndPassword;

@end
