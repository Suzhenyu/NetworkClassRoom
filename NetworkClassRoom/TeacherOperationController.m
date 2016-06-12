//
//  TeacherOperationController.m
//  
//
//  Created by apple on 16/6/12.
//
//

#import "TeacherOperationController.h"
#import <RongIMKit/RongIMKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "Teacher.h"

@interface TeacherOperationController ()<RCIMUserInfoDataSource>

@end

@implementation TeacherOperationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取token
    [self getToken];
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
//    UIBarButtonItem *rightItem
//    = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chat"]
//                                       style:UIBarButtonItemStylePlain
//                                      target:self
//                                      action:@selector(gotoSelectChatAction)];
//    self.tabBarController.navigationItem.rightBarButtonItem = rightItem;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBarController.title = @"作业区";
}

- (void)gotoSelectChatAction {
    
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    //新建一个聊天会话View Controller对象
    RCConversationViewController *chat = [[RCConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.targetId;
    //设置聊天会话界面要显示的标题
    chat.title = model.conversationTitle;
    
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

/**
 * 获取token并连接服务器
 */
- (void)getToken {
    NSURL *url = [NSURL URLWithString:@"https://api.cn.ronghub.com/user/getToken.json"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30.f;
    request.HTTPMethod = @"POST";
    
    NSString *appKey = RONGYUN_APPKEY;
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    NSString *appSec = RONGYUN_APPSER;
    NSString *signature = [self sha1:[NSString stringWithFormat:@"%@%@%@",appSec,nonce,timestamp]];
    //设置请求头
    [request setValue:signature forHTTPHeaderField:@"Signature"];
    [request setValue:appKey forHTTPHeaderField:@"App-Key"];
    [request setValue:nonce forHTTPHeaderField:@"Nonce"];
    [request setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    //设置请求体
    NSData *teacherData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_Teacher];
    Teacher *teacher = [NSKeyedUnarchiver unarchiveObjectWithData:teacherData];
    
    NSString *httpBody
    = [NSString stringWithFormat:@"userId=%@&name=%@&portraitUri=%@", [NSString stringWithFormat:@"t%i",teacher.teacher_id], teacher.teacher_name, nil];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableLeaves
                                                                           error:&error];
                    if (!error) {
                        if ([[dict objectForKey:@"code"] isEqualToNumber:@200]) {
                            [[RCIM sharedRCIM] connectWithToken:[dict objectForKey:@"token"]
                                                        success:^(NSString *userId) {
                                                            //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
                                                            [[RCIM sharedRCIM] setUserInfoDataSource:self];
                                                            NSLog(@"Login successfully with userId: %@.", userId);
                                                        }
                                                          error:^(RCConnectErrorCode status) {
                                                              NSLog(@"登陆的错误码为:%ld", (long)status);
                                                          }
                                                 tokenIncorrect:^{
                                                     //token过期或者不正确。
                                                     //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                                     //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                                     NSLog(@"token错误");
                                                 }];
                        }
                    }
                }] resume];
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
/**
 * 1.这个用户信息最好缓存道本地；
 * 2.为保存同步，最好是在服务端设一个迭代码
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    if ([@"t1" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"t1";
        user.name = @"孙丽珺";
        user.portraitUri = @"https://ss0.baidu.com/73t1bjeh1BF3odCf/it/u=1756054607,4047938258&fm=96&s=94D712D20AA1875519EB37BE0300C008";
        
        return completion(user);
    }else if([@"t2" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"2";
        user.name = @"陈琦";
        user.portraitUri = @"http://121.42.162.159/upload/123.png";
        return completion(user);
    }else if([@"t3" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"t3";
        user.name = @"李勤";
        user.portraitUri = @"http://121.42.162.159/upload/123.png";
        return completion(user);
    }else if([@"s1" isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"s1";
        user.name = @"宿振宇";
        user.portraitUri = @"http://121.42.162.159/upload/123.png";
        return completion(user);
    }
}

#pragma mark SHA1哈希计算
- (NSString*) sha1:(NSString *)hashString
{
    const char *cstr1 = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr1 length:hashString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
