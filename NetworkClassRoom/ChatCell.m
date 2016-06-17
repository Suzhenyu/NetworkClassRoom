//
//  ChatCell.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatCell.h"

static const int kText_Font_Size = 14;           //设置item中标签文字字号

static const float kHeadImageViewWidth = 30;
static const float kHeadImageViewHeight = kHeadImageViewWidth;
static const float kNameLabelWidth = kHeadImageViewWidth;
static const float kNameLabelHeight = 20;

@interface ChatCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation ChatCell

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
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHeadImageViewWidth, kHeadImageViewHeight)];
    [self.contentView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame), kNameLabelWidth, kNameLabelHeight)];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:kText_Font_Size];
    [self.contentView addSubview:_nameLabel];
}

- (void)setChatName:(NSString *)name {
    _nameLabel.text = name;
}

- (void)setChatImage:(UIImage *)image {
    _headImageView.image = image;
}

+ (CGSize)cellSize {
    return CGSizeMake(kHeadImageViewWidth, kHeadImageViewHeight + kNameLabelHeight);
}

@end
