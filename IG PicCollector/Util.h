//
//  Util.h
//  Training
//
//  Created by LXC on 16/8/30.
//  Copyright © 2016年 LXC. All rights reserved.
//
#import "Config.h"
#import <Foundation/Foundation.h>

@interface Util : NSObject

@property (nonatomic, copy) void (^backValue)(NSDictionary *strValue);

/* 字典转JSON字符串 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/* JSON字符串转字典 */
+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/* 显示一个 MBProgressHUD 默认2秒*/
+ (void)mpdText:(NSString *)str showView:(MBProgressHUD *)hud;

+ (void)mpdView:(NSString *)str showView:(MBProgressHUD *)hud;

+ (NSString *)timeStringFormat:(NSString *)timeString DateFormat1:(NSString *)dateType1 DateFormat2:(NSString *)dateType2;

+ (NSString *)getTimestamp;

+ (NSString *)getDownPathUrl;

+ (NSString *)getRecPathUrl;


@end
