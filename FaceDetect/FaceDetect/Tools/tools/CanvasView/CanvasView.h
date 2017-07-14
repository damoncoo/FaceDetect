//
//  CanvasView.h
//  Created by sluin on 15/7/1.
//  Copyright (c) 2015年 SunLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasView : UIView

#define POINTS_KEY @"POINTS_KEY"
#define RECT_KEY   @"RECT_KEY"
#define RECT_ORI   @"RECT_ORI"

@property (nonatomic , strong) NSArray *arrPersons ;

@property (nonatomic ,strong) UIImageView *earsImageView;

@property (nonatomic ,strong) UIImageView *noseImageView;

@property (nonatomic ,strong) UIImageView *beardImageView;

@property (nonatomic ,assign) BOOL isFrontCamera;

- (void)hideView;

@end
