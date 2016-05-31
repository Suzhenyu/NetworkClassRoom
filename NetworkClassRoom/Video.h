//
//  Video.h
//  NetworkClassRoom
//
//  Created by apple on 16/6/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, assign) int video_id;
@property (nonatomic, copy) NSString *video_name;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, assign) int course_id;
@property (nonatomic, copy) NSString *addtime;

@end
