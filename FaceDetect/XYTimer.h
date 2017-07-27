//
//  XYTimer.h
//  FYWechatTools
//
//  Created by Darcy on 2017/1/24.
//
//

#import <Foundation/Foundation.h>

@class XYTimer;

typedef void (^TimerBlock)(XYTimer *timer,NSInteger index,BOOL *stop);

@interface XYTimer : NSObject

+(XYTimer *)scheduledTimer:(TimerBlock)timerBlock timerInteval:(NSTimeInterval)timerInteval;

@property (nonatomic ,copy) TimerBlock timerBlock;
@property (nonatomic ,retain) NSTimer *timer;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,assign) BOOL stop;

@end
