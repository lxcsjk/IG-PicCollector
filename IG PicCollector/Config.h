//
//  Config.h
//  Training
//
//  Created by LXC on 16/8/29.
//  Copyright © 2016年 LXC. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define KWS(weakSelf) __weak typeof (&*self) weakSelf=self;

#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RATES SCREENWIDTH/375

#import "AppDelegate.h"
#import "Masonry.h"
#import "MBProgressHUD+Add.h"
#import "Util.h"

#define NUMBERS @"0123456789"




@interface Config : NSObject


@end
