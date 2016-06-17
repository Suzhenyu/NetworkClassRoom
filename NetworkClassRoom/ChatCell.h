//
//  ChatCell.h
//  NetworkClassRoom
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UICollectionViewCell

+ (CGSize)cellSize;
- (void)setChatName:(NSString *)name;
- (void)setChatImage:(UIImage *)image;

@end
