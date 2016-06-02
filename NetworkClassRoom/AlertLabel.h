//
//  AlertLabel.h
//  NetworkClassRoom
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertLabel : NSObject

+ (void)showText:(NSString *)text to:(UIView *)view hideAfterDelay:(NSTimeInterval)time;

@end
