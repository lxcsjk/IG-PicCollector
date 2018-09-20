//
//  Util.m
//  Training
//
//  Created by LXC on 16/8/30.
//  Copyright © 2016年 LXC. All rights reserved.
//

#import "Util.h"
#import<CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>

@implementation Util

/* 字典转JSON字符串 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/* 字符串转字典 */
+ (NSMutableDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&err];
    if(err) {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/* 显示一个 MBProgressHUD 默认2秒*/
+ (void)mpdText:(NSString *)str showView:(MBProgressHUD *)hud{
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(str, @"HUD message title");
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, +10.f);
    [hud hideAnimated:YES afterDelay:1.f];
}

+ (void)mpdView:(NSString *)str showView:(MBProgressHUD *)hud{
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.label.text = NSLocalizedString(str, @"HUD done title");
    
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (NSString *)ret16bitString{
    char data[16];
    
    for (int x=0;x<16;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
}


+ (NSString *)timeStringFormat:(NSString *)timeString DateFormat1:(NSString *)dateType1 DateFormat2:(NSString *)dateType2{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateType1];
    NSDate *destDate= [dateFormatter dateFromString:timeString];
    [dateFormatter setDateFormat:dateType2];
    NSString *currentDateString = [dateFormatter stringFromDate:destDate];
    return currentDateString;
}

+ (NSString *)getDownPathUrl{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *downloadDir = [str stringByAppendingPathComponent:@"completedPic"];
    
    return downloadDir;
}

+ (NSString *)getRecPathUrl{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *downloadDir = [str stringByAppendingPathComponent:@"RecordCourse"];
    
    return downloadDir;
}

+ (NSString *)getTimestamp{
    NSDate *nowDate = [NSDate date];
    double timestamp = (double)[nowDate timeIntervalSince1970]*1000;
    long nowTimestamp = [[NSNumber numberWithDouble:timestamp] longValue];
    NSString *timestampStr = [NSString stringWithFormat:@"%ld",nowTimestamp];
    return timestampStr;
}
@end
