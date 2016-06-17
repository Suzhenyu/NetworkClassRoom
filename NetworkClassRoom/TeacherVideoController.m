//
//  TeacherVideoController.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeacherVideoController.h"
#import "Video.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"

@interface TeacherVideoController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *_videoArray;
    int _index;
    UIImagePickerController *_imagePickerController;
    NSString *_videoName;
}
//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TeacherVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    [self requestVideoData];
    
    self.uploadButton.layer.cornerRadius = 10;
    [self.uploadButton addTarget:self
                          action:@selector(uploadAction)
                forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.footView;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
}

/**
 *  视频上传部分
 */
- (void)uploadAction {
    
    //UIAlertControllerStyleAlert 警示框
    UIAlertController *alert1
    = [UIAlertController alertControllerWithTitle:@"请输入视频名称"
                                          message:nil
                                   preferredStyle:UIAlertControllerStyleAlert];
    [alert1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"视频名称";
    }];
    [alert1 addAction:[UIAlertAction actionWithTitle:@"确定"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * _Nonnull action) {
                                                 _videoName = [[alert1.textFields objectAtIndex:0] text];
                                                 
                                                 UIAlertController *alert
                                                 = [UIAlertController alertControllerWithTitle:@"从哪里上传？"
                                                                                       message:nil
                                                                                preferredStyle:UIAlertControllerStyleActionSheet];
                                                 
                                                 [alert addAction:[UIAlertAction actionWithTitle:@"摄像头"
                                                                                           style:UIAlertActionStyleDefault
                                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                             _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                                             _imagePickerController.videoMaximumDuration = 60;
                                                                                                      _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
                                                                                             _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
                                                                                             
                                                                                             //设置摄像头模式（拍照，录制视频）为录像模式
                                                                                             _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                                                                                             [self presentViewController:_imagePickerController animated:YES completion:nil];
                                                                                             
                                                                                         }]];
                                                 [alert addAction:[UIAlertAction actionWithTitle:@"相册"
                                                                                           style:UIAlertActionStyleDefault
                                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                             _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                                                                             _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
                                                                                             
                                                                                             [self presentViewController:_imagePickerController animated:YES completion:nil];
                                                                                             
                                                                                         }]];
                                                 [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                                           style:UIAlertActionStyleDestructive
                                                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                                         }]];
                                                 
                                                 [self presentViewController:alert animated:YES completion:nil];

    }]];
    [alert1 addAction:[UIAlertAction actionWithTitle:@"取消"
                                               style:UIAlertActionStyleCancel
                                             handler:nil]];
    
    [self presentViewController:alert1 animated:YES completion:nil];
    
}

#pragma mark UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *url = info[UIImagePickerControllerMediaURL];
        //保存视频至相册（异步线程）
        NSString *urlStr = [url path];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        });
        //上传视频
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        [self uploadVideoWithData:videoData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

/**
 *  上传视频
 */
- (void)uploadVideoWithData:(NSData *)data {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = @"http://121.42.162.159/api_upload.php";
    
    NSDictionary *param = @{@"video_name":_videoName,
                            @"course_id":[NSString stringWithFormat:@"%i",self.course_id]};
    
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data
                                    name:@"attach"
                                fileName:_videoName
                                mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功");
        NSArray *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                       options:NSJSONReadingMutableLeaves
                                                         error:nil];
        NSLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败,%@.",error);
    }];
}

/**
 *  视频播放部分
 */
- (void)dealloc {
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrlWithIndex:(int)index {
    
    Video *video = _videoArray[index];
    
    NSString *urlStr
    = [video.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        NSURL *url=[self getNetworkUrlWithIndex:_index];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [self addNotification];
    }
    return _moviePlayerViewController;
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",(long)self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",(long)self.moviePlayerViewController.moviePlayer.playbackState);
}

#pragma mark- reuqest video data
- (void)requestVideoData {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?course_id=%i", API_ROOTPATH, API_VIDEOS, self.course_id];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSDictionary *jsonDict
                = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableLeaves
                                                    error:nil];
                if ([[jsonDict objectForKey:@"code"] isEqualToNumber:@200]) {
                    _videoArray = [NSMutableArray array];
                    
                    NSArray *dataArray = [jsonDict objectForKey:@"data"];
                    for (int i = 0; i < dataArray.count; i++) {
                        NSDictionary *dataDict = dataArray[i];
                        
                        Video *video = [Video new];
                        video.video_id = [dataDict[@"video_id"] intValue];
                        video.video_name = dataDict[@"video_name"];
                        video.video_url = dataDict[@"video_url"];
                        video.course_id = [dataDict[@"course_id"] intValue];
                        video.addtime = dataDict[@"addtime"];
                        [_videoArray addObject:video];
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
    return _videoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    
    Video *video = [_videoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = video.video_name;
    
    return cell;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    Video *video = [_videoArray objectAtIndex:indexPath.row];
    
    self.moviePlayerViewController=nil;//保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    _index = (int)indexPath.row;
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}


@end
