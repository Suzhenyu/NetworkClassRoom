//
//  SelectChatViewController.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SelectChatViewController.h"
#import "Teacher.h"

@interface SelectChatViewController ()

@property (nonatomic, strong) UICollectionViewController *collectionViewControl;
@property (nonatomic, strong) NSMutableArray *chatArray;;

@end

@implementation SelectChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(NSMutableArray *)chatArray {
    if (!_chatArray) {
        _chatArray = [NSMutableArray array];
        
        Teacher *teacher1 = [[Teacher alloc] init];
        teacher1.teacher_id = 1;
        teacher1.teacher_name = @"孙丽珺";
        [_chatArray addObject:teacher1];
        Teacher *teacher2 = [[Teacher alloc] init];
        teacher2.teacher_id = 2;
        teacher2.teacher_name = @"陈琦";
        [_chatArray addObject:teacher2];
        Teacher *teacher3 = [[Teacher alloc] init];
        teacher3.teacher_id = 3;
        teacher3.teacher_name = @"李勤";
        [_chatArray addObject:teacher3];
    }
    
    return _chatArray;
}

@end
