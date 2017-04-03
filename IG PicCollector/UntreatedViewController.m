//
//  UntreatedViewController.m
//  InsSaver
//
//  Created by LXC on 2017/4/3.
//  Copyright © 2017年 LXC. All rights reserved.
//

#import "UntreatedViewController.h"
#import "Config.h"
#import "Util.h"

@interface UntreatedViewController ()<UITextFieldDelegate>

@property (nonatomic,weak)UITextField *urlField;

@property (nonatomic,weak)UIImageView *urlImgView;

@end

@implementation UntreatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    
    [self untreatedUI];
}

-(void)untreatedUI{
    UITextField *textField = [[UITextField alloc]init];
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"   Your picture link";
    textField.font = [UIFont systemFontOfSize:15];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyDone;
    textField.layer.cornerRadius = 6;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [view addSubview:textField];
    textField.leftView = view;
    textField.leftViewMode = UITextFieldViewModeAlways;
    _urlField = textField;
    
    [self.view addSubview:_urlField];
    KWS(ws);
    [_urlField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(30);
        make.left.mas_equalTo(ws.view).offset(18);
        make.right.mas_equalTo(ws.view).offset(-18);
        make.height.mas_equalTo(36);
    }];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"placeholderImage"];
    _urlImgView = imgView;
    [self.view addSubview:_urlImgView];
    [_urlImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_urlField.mas_bottom).offset(60);
        make.left.mas_equalTo(ws.view).offset(18);
        make.right.mas_equalTo(ws.view).offset(-18);
        make.height.mas_equalTo(300*RATES);
    }];
    
    UIButton *pasteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pasteBtn setTitle:@"Paste" forState:UIControlStateNormal];
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [pasteBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [pasteBtn setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    pasteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [pasteBtn addTarget:self action:@selector(pasteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    pasteBtn.layer.cornerRadius = 17;
    [self.view addSubview:pasteBtn];
    [pasteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_urlField.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset((SCREENWIDTH - 80)/2);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
}

-(void)pasteBtnClick{
    NSString *pasteStr = [[UIPasteboard generalPasteboard] string];
    _urlField.text = pasteStr;
    [self downloadImg:pasteStr];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    [textfield resignFirstResponder];
    [self downloadImg:textfield.text];
    return YES;
}

-(void)downloadImg:(NSString *)pasteStr{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        [self processUrl:pasteStr withCompletionBlock:^(NSData *picData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [hud hideAnimated:YES];
                
                if (error){
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                   message:@"There was an error downloading the image. Check the URL for errors."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:2];
                    [UIView setAnimationDelay:0];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    _urlImgView.image = [UIImage imageWithData:picData];
                    [UIView commitAnimations];
                    
                    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:picData], nil, nil, nil);

                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [Util mpdText:@"Success" showView:hud];
                }
            });
        }];
    });
}

-(void)processUrl:(NSString *)url withCompletionBlock:(void (^)(NSData *, NSError *))completionBlock{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error || !data){
            NSError *error = [NSError errorWithDomain:@"DownloadFailed"
                                                 code:-1
                                             userInfo:@{ NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Invalid url",nil)}];
            completionBlock(nil,error);
            return;
        }
        
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DLog(@"HTML  -------- > %@",html);
        NSScanner *scanner = [NSScanner scannerWithString:html];
        NSString *token = nil;
        
        NSString *ignoreString = @"<meta property=\"og:image\" content=\"";
        [scanner scanUpToString:ignoreString intoString:nil];
        
        [scanner scanUpToString:@"\" />" intoString:&token];
        
        NSString *imageUrl = [token stringByReplacingOccurrencesOfString:ignoreString withString:@""];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSLog(@"imageUrl: %@",imageUrl);
        
        if (!imageUrl){
            NSError *error = [NSError errorWithDomain:@"DownloadFailed"
                                                 code:-1
                                             userInfo:@{ NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Null image url",nil)}];
            completionBlock(nil,error);
            return;
        }
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        if (imageData){
            completionBlock(imageData,nil);
        }else{
            NSError *error = [NSError errorWithDomain:@"DownloadFailed"
                                                 code:-1
                                             userInfo:@{ NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Null image data",nil)}];
            completionBlock(nil,error);
        }
        
    }] resume];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
