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

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (void)calculateAngle {
    CGPoint p1 = CGPointMake(0, 0);
    CGPoint p2 = CGPointMake(-10,10);
    CGFloat f = [self pointPairToBearingDegrees:p2 secondPoint:p1];
    NSLog(@"f is %f",f);
}

- (void)groupSync
{
    dispatch_queue_t disqueue =  dispatch_queue_create("com.shidaiyinuo.NetWorkStudy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t disgroup = dispatch_group_create();
    dispatch_group_async(disgroup, disqueue, ^{
        NSLog(@"任务一完成");
    });
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(8);
        NSLog(@"任务二完成");
    });
    dispatch_group_notify(disgroup, disqueue, ^{
        NSLog(@"dispatch_group_notify 执行");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_group_wait(disgroup, dispatch_time(DISPATCH_TIME_NOW, 105 * NSEC_PER_SEC));
//        NSLog(@"dispatch_group_wait 结束");
    });

    dispatch_group_wait(disgroup, dispatch_time(DISPATCH_TIME_NOW, 105 * NSEC_PER_SEC));
    
    NSLog(@"函数到头了");
}


- (void)groupSync2
{
    dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        sleep(11);
        NSLog(@"任务一完成");
    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        sleep(6);
        NSLog(@"任务二完成");
    });
    dispatch_group_async(dispatchGroup, globalQueue, ^{
        sleep(10);
        NSLog(@"任务三完成");
    });
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"notify：任务都完成了");
    });
}

- (void)groupSync3
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(5);
        NSLog(@"任务一完成");
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_leave(group);
        sleep(8);
        NSLog(@"任务二完成");
//        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务完成");
    });
}

- (void)groupSync4
{
    dispatch_queue_t dispatchQueue = dispatch_queue_create("ted.queue.next1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        dispatch_async(globalQueue, ^{
            sleep(5);
            NSLog(@"任务一完成");
        });
    });
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        dispatch_async(globalQueue, ^{
            sleep(8);
            NSLog(@"任务二完成");
        });
    });
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"notify：任务都完成了");
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];    
//    [self calculateAngle];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self groupSync4];
//        
//    });    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCaptureController];
    
//    UIView *view = self.rotationView;
//    
//    __block CGFloat angle = 0;
//    __block CGFloat centerY = 450;
//    __block CGFloat centerX = 150;
//    __block CGFloat width = 200;
//    __block CGFloat height = 100;
//    
//    XYTimer *timer = [XYTimer scheduledTimer:^(XYTimer *timer, NSInteger index, BOOL *stop) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            angle += M_PI_4;
//
////            angle += 0.01;
////            width += 0.01;
////            height += 0.01;
//            
//            view.transform = CGAffineTransformIdentity;
//            view.frame = CGRectMake(centerX - width/2, centerY - height/2, width, height);
//
//            CGAffineTransform rotationTransform  = CGAffineTransformMakeRotation(angle);
//            view.transform = rotationTransform;
//            
////            if (angle == 1) {
////                view.transform = CGAffineTransformIdentity;
////            }
////            else {
////                view.transform = rotationTransform;
////            }
//            
//            NSString *frameOfView = NSStringFromCGRect(view.frame);
//            self.frameLabel.text = frameOfView;
//        });
//        
//    } timerInteval:5.1];
//    [timer.timer fire];
    
}

- (void)showCaptureController {
    CaptureViewController *capture = [[CaptureViewController alloc]init];
    [self presentViewController:capture animated:YES completion:^{
        
    }];
}


@end
