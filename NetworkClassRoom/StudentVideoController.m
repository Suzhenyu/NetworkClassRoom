//
//  StudentVideoController.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StudentVideoController.h"
#import "Video.h"
#import <MediaPlayer/MediaPlayer.h>

@interface StudentVideoController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_videoArray;
    int _index;
}

//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StudentVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    [self requestVideoData];
}

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
    
    NSString *urlStr=video.video_url;
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
