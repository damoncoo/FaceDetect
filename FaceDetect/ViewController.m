//
//  ViewController.m
//  FaceDetect
//
//  Created by Darcy on 2017/7/13.
//  Copyright © 2017年 Darcy. All rights reserved.
//

#import "ViewController.h"
#import "CaptureViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCaptureController];
}

- (void)showCaptureController {
    CaptureViewController *capture = [[CaptureViewController alloc]init];
    [self presentViewController:capture animated:YES completion:^{
        
    }];
}


@end
