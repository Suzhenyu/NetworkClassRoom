//
//  ChatCell.m
//  Rongyun_Demo1
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

static const int kText_Font_Size = 14;           //设置item中标签文字字号

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUIControls];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addUIControls];
    }
    return self;
}

-(void)addUIControls {
    _lbChannel = [[UILabel alloc] initWithFrame:self.bounds];
    _lbChannel.backgroundColor = [UIColor whiteColor];
    _lbChannel.textColor = [UIColor blackColor];
    _lbChannel.textAlignment = NSTextAlignmentCenter;
    _lbChannel.font = [UIFont systemFontOfSize:kText_Font_Size];
    
    [self.contentView addSubview:_lbChannel];
}

@end
