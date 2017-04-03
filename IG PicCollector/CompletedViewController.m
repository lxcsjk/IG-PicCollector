//
//  CompletedViewController.m
//  InsSaver
//
//  Created by LXC on 2017/4/3.
//  Copyright © 2017年 LXC. All rights reserved.
//

#import "CompletedViewController.h"
#import "Util.h"

@interface CompletedViewController ()
{
    NSString *fileName;
}
@end

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:91/255.0 green:147/255.0 blue:252/255.0 alpha:1.0];

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    
    fileName = [doc stringByAppendingPathComponent:@"completed_pic.sqlite"];
    
    DLog(@"sql文件路径 ： %@",fileName);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *isTableExist = [userDefaults objectForKey:@"isTableExist"];
    
    NSString *downloadCoursePath = [userDefaults objectForKey:@"completedPic"];
    
    if (!isTableExist) {
        [self createTable];
    }
    
    if (!downloadCoursePath) {
        [self createDir];
    }
    
    // Do any additional setup after loading the view.
}


-(NSString *)createDir{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 创建目录
    NSString *downloadDirectory = [Util getDownPathUrl];
    
    BOOL res=[fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        DLog(@"文件夹创建成功");
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:downloadDirectory forKey:@"completedPic"];
        [userDefaults synchronize];
        return downloadDirectory;
    }else{
        DLog(@"文件夹创建失败");
        return nil;
    }
}


-(void)createTable{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        //  创建表
        BOOL result = [db executeUpdate:@"CREATE TABLE 't_down_course' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'downPath' VARCHAR(255),'savePath' VARCHAR(255),'downloadStatus' CHAR(1))"];
        if (result){
            DLog(@"创建表成功");
            [userDefaults setValue:@"1" forKey:@"isTableExist"];
            [userDefaults synchronize];
        }
        [db close];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
