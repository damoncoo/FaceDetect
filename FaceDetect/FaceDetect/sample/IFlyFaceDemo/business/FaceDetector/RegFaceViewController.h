//
//  RegFaceViewController.h
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/5/5.
//
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "iflyMSC/IFlyMSC.h"

@interface RegFaceViewController : UIViewController<CaptureSessionManagerDelegate>

/**
 *  用于自定义拍照
 */
@property (nonatomic, retain) CaptureSessionManager* captureManager;

/**
 *  tips
 */
@property (nonatomic, retain) UILabel* overlayLabel;

/**
 *  显示图片的师徒控制器
 */
@property(nonatomic,assign)id ctrlShowFace;

@end
