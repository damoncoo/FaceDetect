//
//  CanvasView.m
//  Created by sluin on 15/7/1.
//  Copyright (c) 2015年 SunLin. All rights reserved.
//

#import "CanvasView.h"
#import "FaceModel.h"
#import "CalculatorTools.h"
#include <math.h>
#import <CoreGraphics/CoreGraphics.h>

#define radiansToDegrees(x) (180.0 * x / M_PI)

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return rads;
//    return radiansToDegrees(rads);
    //degs = degrees(atan((top - bottom)/(right - left)))
}

@implementation CanvasView {
    CGContextRef context ;
}

- (NSArray *)earImages {
    static  NSMutableArray *erduos = nil;
    if (erduos) {
        return erduos;
    }
    erduos = [NSMutableArray arrayWithCapacity:0];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LMEffectResource" ofType:@"bundle"];
    NSString *biziPath = [bundlePath stringByAppendingPathComponent:@"effect/900224_1/erduo"];
    for (NSInteger i = 0 ; i < 11; i ++) {
        //erduo_000
        NSString *imagePath = [biziPath stringByAppendingPathComponent:[NSString stringWithFormat:@"erduo_0%02ld.png",(long)i]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
        UIImage *eraImage = [UIImage imageWithData:data];
        [erduos addObject:eraImage];
    }
    return erduos;
}

- (NSArray *)beardImages {
    static  NSMutableArray *huzi = nil;
    if (huzi) {
        return huzi;
    }
    huzi = [NSMutableArray arrayWithCapacity:0];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LMEffectResource" ofType:@"bundle"];
    NSString *biziPath = [bundlePath stringByAppendingPathComponent:@"effect/900224_1/huzi"];
    for (NSInteger i = 0 ; i < 11; i ++) {
        //erduo_000
        NSString *imagePath = [biziPath stringByAppendingPathComponent:[NSString stringWithFormat:@"huzi_0%02ld.png",(long)i]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
        UIImage *biziImage = [UIImage imageWithData:data];
        [huzi addObject:biziImage];
    }
    return huzi;
}

- (NSArray *)noseImages {
    static  NSMutableArray *bizi = nil;
    if (bizi) {
        return bizi;
    }
    bizi = [NSMutableArray arrayWithCapacity:0];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"LMEffectResource" ofType:@"bundle"];
    NSString *biziPath = [bundlePath stringByAppendingPathComponent:@"effect/900224_1/bizi"];
    for (NSInteger i = 0 ; i < 11; i ++) {
        //erduo_000
        NSString *imagePath = [biziPath stringByAppendingPathComponent:[NSString stringWithFormat:@"bizi_0%02ld.png",(long)i]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
        UIImage *biziImage = [UIImage imageWithData:data];
        [bizi addObject:biziImage];
    }
    return bizi;
}

- (UIImageView *)earsImageView {
    if (!_earsImageView) {
        _earsImageView = [[UIImageView alloc]init];
        _earsImageView.frame = CGRectMake(0, 0, 178 * 1.3, 94 * 1.3);
        _earsImageView.image = [self earImages].firstObject;
        _earsImageView.animationImages = [self earImages];
    }
    return _earsImageView;
}

- (UIImageView *)beardImageView {
    if (!_beardImageView) {
        _beardImageView = [[UIImageView alloc]init];
        _beardImageView.frame = CGRectMake(0, 0, 285 * 0.7, 76 * 0.7);
        _beardImageView.animationImages = [self beardImages];
    }
    return _beardImageView;
}

- (UIImageView *)noseImageView {
    if (!_noseImageView) {
        _noseImageView = [[UIImageView alloc]init];
        _noseImageView.frame = CGRectMake(0, 0, 52, 37);
        _noseImageView.animationImages = [self noseImages];
    }
    return _noseImageView;
}

- (void)addFacialViews
{
    [self addSubview:self.earsImageView];
    [self addSubview:self.beardImageView];
    [self addSubview:self.noseImageView];
    
    [self.earsImageView startAnimating];
    [self.beardImageView startAnimating];
    [self.noseImageView startAnimating];
}

- (void)drawRect:(CGRect)rect {
    [self drawPointWithPoints:self.arrPersons] ;
}

- (void)drawPointWithPoints:(NSArray *)arrPersons{
    
    if (arrPersons.count) {
        for (FaceModel *face in arrPersons) {
            [self addFacialViews];
            
            UIImageView *ear = self.earsImageView;
            UIImageView *bizi = self.noseImageView;
            UIImageView *huzi = self.beardImageView;
            
            CGPoint eyeLeft = [self convertFicialModelToGpoint:face.landmark.left_eye_center];
            CGPoint eyeRight = [self convertFicialModelToGpoint:face.landmark.right_eye_center];
            
            CGFloat eyeDistance = fabs(eyeRight.x - eyeLeft.x);

            _earsImageView.frame = CGRectMake(_earsImageView.frame.origin.x, _earsImageView.frame .origin.y, 4 * eyeDistance, 4 * eyeDistance * 94 /178 * 1.3);
            _beardImageView.frame = CGRectMake(_beardImageView.frame.origin.x, _beardImageView.frame.origin.y,  3 *eyeDistance ,3 * eyeDistance * 76/285 );
            _noseImageView.frame = CGRectMake(_noseImageView.frame.origin.x, _noseImageView.frame.origin.y, 0.5 * eyeDistance * 1, 0.5 * eyeDistance * 37/52 );
            
            CGFloat angle = angleBetweenPoints(eyeLeft, eyeRight);
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformMakeRotation(-angle);
            
            NSLog(@"radius == %f",angle);
            
            CGPoint eyeCenter = CGPointMake((eyeLeft.x/2 + eyeRight.x/2), (eyeLeft.y/2 + eyeRight.y/2) - eyeDistance);
            ear.center = eyeCenter;
            ear.transform = rotationTransform;

            CGPoint biziTop = [self convertFicialModelToGpoint:face.landmark.nose_top];
            CGPoint biziBottom = [self convertFicialModelToGpoint:face.landmark.nose_bottom];
            CGPoint biziCenter = CGPointMake((biziTop.x/2 + biziBottom.x/2), (biziTop.y/2 + biziBottom.y/2));
            bizi.center = biziCenter;
            bizi.transform = rotationTransform;
            
//            CGPoint noseLeft = [self convertFicialModelToGpoint:face.landmark.nose_left];
//            CGPoint noseRight = [self convertFicialModelToGpoint:face.landmark.nose_right];
//            CGPoint noseCenter = CGPointMake((noseLeft.x/2 + noseRight.x/2), (noseLeft.y/2 + noseRight.y/2));
            CGPoint noseBottom = [self convertFicialModelToGpoint:face.landmark.nose_bottom];
            huzi.center = noseBottom;
            huzi.transform = rotationTransform;
            
            break;
        }
    }
    
//    if (context) {
//        CGContextClearRect(context, self.bounds) ;
//    }
//    context = UIGraphicsGetCurrentContext();
//    
//    
//    [[UIColor greenColor] set];
//    CGContextSetLineWidth(context, 2);
//    CGContextStrokePath(context);
}

- (void)hideView
{
    [self.earsImageView stopAnimating];
    [self.beardImageView stopAnimating];
    [self.noseImageView stopAnimating];
}

- (CGPoint)convertFicialModelToGpoint:(FacialPartModel *)model {
    
    BOOL isFrontCamera = self.isFrontCamera = YES;
    CGFloat widthScaleBy = 2/3.0;
    CGFloat heightScaleBy = 1/2.0;
    CGFloat x = [model.x floatValue];
    CGFloat y = [model.y floatValue];
    CGPoint p = CGPointMake(y,x);
    if(!isFrontCamera){
        p = pSwap(p);
        p = pRotate90(p, 480, 640);
    }
    p = pScale(p, widthScaleBy, heightScaleBy);
    return p;
}


@end
