//
//  IFlyFaceManager.m
//  FeiliEmotion
//
//  Created by Darcy on 2017/7/13.
//  Copyright © 2017年 Nathan Ou. All rights reserved.
//

#define USER_APPID           @"5965d5e9"

#import "IFlyFaceManager.h"
#import <iflyMSC/IFlyFaceSDK.h>

@implementation IFlyFaceManager

+(void)setUpIFly {
    
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
}


@end
