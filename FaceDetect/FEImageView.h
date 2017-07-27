//
//  FEImageView.h
//  FeiliEmotion
//
//  Created by Darcy on 2017/7/26.
//  Copyright © 2017年 Nathan Ou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface FEImageView : UIImageView

@property (nonatomic ,assign)NSArray *images;

@property (nonatomic, assign) NSInteger totalImageCount;

@property (nonatomic, assign) CGFloat totalDuration;

@property (nonatomic ,assign) BOOL isAnimating;

@property (nonatomic, assign) NSTimeInterval accumulator;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign, readonly) NSUInteger currentFrameIndex;

- (void)startAnimation;

- (void)stopAnimation;


@property (nonatomic ,assign) id ownerRect;

@end
