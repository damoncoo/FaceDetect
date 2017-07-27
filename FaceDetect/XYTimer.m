//
//  XYTimer.m
//  FYWechatTools
//
//  Created by Darcy on 2017/1/24.
//
//

#import "XYTimer.h"
//#import <QuartzCore/QuartzCore.h>

@implementation XYTimer

+ (NSMutableArray *)allTimers {
    
    static NSMutableArray *mutableArray = nil;
    if (!mutableArray) {
        mutableArray = [NSMutableArray arrayWithCapacity:0];
    }
    return mutableArray;
}

+(void)removeTimer:(XYTimer *)xy {
    [xy.timer invalidate];
    xy.timer = nil;
    xy = nil;
}

+ (XYTimer *)scheduledTimer:(TimerBlock)timerBlock timerInteval:(NSTimeInterval)timerInteval {
    
    XYTimer *xyTimer = [[XYTimer alloc]init];
    xyTimer.index = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timerInteval target:xyTimer selector:@selector(timeBlockRetreive:) userInfo:nil repeats:YES];
    xyTimer.timerBlock = timerBlock;
    xyTimer.timer = timer;
    return xyTimer;
}

- (void)setStop:(BOOL)stop {
    _stop = stop;
}

- (void)dealloc {}

- (void)timeBlockRetreive:(NSTimer *)timer {
    if (self.stop) {
        [XYTimer removeTimer:self];
        return;
    }
    if (self.timerBlock) {
        self.timerBlock(self,self.index,&_stop);
    }
    self.index ++;
}

@end
