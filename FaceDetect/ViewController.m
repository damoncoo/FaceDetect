//
//  ViewController.m
//  FaceDetect
//
//  Created by Darcy on 2017/7/13.
//  Copyright © 2017年 Darcy. All rights reserved.
//

#import "ViewController.h"
#import "CaptureViewController.h"
#import "XYTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCaptureController];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(60, 400, 200, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    __block CGFloat angle = 0;
    __block CGFloat centerY = 450;
    __block CGFloat centerX = 150;
    __block CGFloat width = 200;
    __block CGFloat height = 100;
    
    XYTimer *timer = [XYTimer scheduledTimer:^(XYTimer *timer, NSInteger index, BOOL *stop) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            angle += 0.01;
            width += 0.01;
            height += 0.01;
            
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(centerX - width/2, centerY - height/2, width, height);

            CGAffineTransform rotationTransform  = CGAffineTransformMakeRotation(angle);
            view.transform = rotationTransform;
            
            if (angle == 1) {
                view.transform = CGAffineTransformIdentity;
            }
            else {
                view.transform = rotationTransform;
            }
        });
        
    } timerInteval:0.1];
    [timer.timer fire];
    
}

- (void)showCaptureController {
    CaptureViewController *capture = [[CaptureViewController alloc]init];
    [self presentViewController:capture animated:YES completion:^{
        
    }];
}


@end
