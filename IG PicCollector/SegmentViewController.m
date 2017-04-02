//
//  SegmentSampleViewController.m
//  XHSegmentControllerSample
//
//  Created by xihe on 16/4/19.
//  Copyright © 2016年 xihe. All rights reserved.
//

#import "SegmentViewController.h"
#import "UntreatedViewController.h"
#import "CompletedViewController.h"

@interface SegmentViewController ()

@end


@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UntreatedViewController *vc1 = [[UntreatedViewController alloc] init];
    vc1.title = @"Untreated";
    
    CompletedViewController *vc2 = [[CompletedViewController alloc] init];
    vc2.title = @"Completed";
    
    self.viewControllers = @[vc1, vc2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
