//
//  AlertLabel.m
//  NetworkClassRoom
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AlertLabel.h"
#import "MBProgressHUD.h"

@implementation AlertLabel

+ (void)showText:(NSString *)text to:(UIView *)view hideAfterDelay:(NSTimeInterval)time {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud hide:YES afterDelay:time];
    
}

@end
