//
//  FEImageBind.m
//  FeiliEmotion
//
//  Created by Darcy on 2017/7/28.
//  Copyright © 2017年 Nathan Ou. All rights reserved.
//

#import "FEImageBind.h"
#import <iflyMSC/IFlyFaceSDK.h>
#import "IFlyFaceImage.h"

@interface FEImageBind ()
@property (nonatomic, strong ) IFlyFaceDetector *faceDetector;

@end

@implementation FEImageBind

- (IFlyFaceDetector *)faceDetector {
    if (!_faceDetector) {
        _faceDetector = [IFlyFaceDetector sharedInstance];
        [_faceDetector setParameter:@"1" forKey:@"detect"];
        [_faceDetector setParameter:@"1" forKey:@"align"];
    }
    return _faceDetector;
}

//- (NSMutableArray <UIImage *> *)BindImage:(NSArray *)images faceModel:(FEMouldFaceModel *)faceModel {
//    
//    
//    
//    
//    return nil;
//}
//
//
//- (void)mergeImage:(UIImage *)image faceModel:(FEMouldFaceModel *)faceModel {
//    
//
//    
//}

- (void)drawPointWithPoints:(NSArray *)arrPersons {
    
    
//    if (arrPersons.count) {
//        for (FaceModel *face in arrPersons) {
//            //眼睛
//            CGPoint eyeLeft = [self convertFicialModelToGpoint:face.landmark.left_eye_center];
//            CGPoint eyeRight = [self convertFicialModelToGpoint:face.landmark.right_eye_center];
//            CGPoint eyeCenter = CGPointMake((eyeLeft.x/2 + eyeRight.x/2), (eyeLeft.y/2 + eyeRight.y/2));
//            CGFloat eyeDistance = distanceBetweenPoints(eyeLeft, eyeRight);
//            CGFloat angle = angleBetweenPoints(eyeLeft, eyeRight);
//            CGAffineTransform rotationTransform  = CGAffineTransformMakeRotation(-angle);
//            
//            if (!self.arrayRects) {
//                self.arrayRects = [NSMutableArray arrayWithCapacity:0];
//            }
//            FEFaceRect *faceRect = self.arrayRects.firstObject;
//            if (!faceRect) {
//                faceRect = [[FEFaceRect alloc]init];
//                [self.arrayRects addObject:faceRect];
//            }
//            
//            for (FEFacePartModel *part in self.faceModel.parts) {
//                CGFloat scale = part.scale.floatValue;
//                CGFloat ration = part.width.floatValue/part.height.floatValue;
//                CGFloat width = 0;
//                CGPoint center = CGPointZero;
//                NSInteger offset = part.offset.integerValue;
//                
//                FEImageView *imageView = nil;
//                if ([part.name isEqualToString:@"hat"]||[part.name isEqualToString:@"上额头"]) {
//                    //轮廓
//                    FacialPartModel *facial = [[FacialPartModel alloc]init];
//                    facial.y = face.position.top;
//                    facial.x = face.position.left;
//                    CGPoint topRight =  [self convertFicialModelToGpoint:facial];
//                    facial.y = face.position.bottom;
//                    CGPoint topLeft =  [self convertFicialModelToGpoint:facial];
//                    CGPoint hatCenter =  CGPointMake((topLeft.x/2 + topRight.x/2), (topLeft.y/2 + topRight.y/2));
//                    //            CGPoint hatCenter =  CGPointMake( (topLeft.y/2 + topRight.y/2),(topLeft.x/2 + topRight.x/2));
//                    CGFloat hatWidth =  distanceBetweenPoints(topLeft, topRight);
//                    
//                    width = hatWidth;
//                    center = hatCenter;
//                    imageView = faceRect.hatImageView;
//                }
//                else if ([part.name isEqualToString:@"eyebrow"]) {
//                    //眉毛
//                    CGPoint eyebrowLeft = [self convertFicialModelToGpoint:face.landmark.left_eyebrow_middle];
//                    CGPoint eyebrowRight = [self convertFicialModelToGpoint:face.landmark.right_eyebrow_middle];
//                    CGPoint eyebrowCenter = CGPointMake((eyebrowLeft.x/2 + eyebrowRight.x/2), (eyebrowLeft.y/2 + eyebrowRight.y/2));
//                    CGFloat eyebrowDistance = distanceBetweenPoints(eyebrowLeft, eyebrowRight);
//                    width = eyebrowDistance;
//                    center = eyebrowCenter;
//                    imageView = faceRect.eyebrowImageView;
//                }
//                else if ([part.name isEqualToString:@"eye"]) {
//                    width = eyeDistance;
//                    center = eyeCenter;
//                    imageView = faceRect.eyesImageView;
//                }
//                else if ([part.name isEqualToString:@"nose"] || [part.name isEqualToString:@"鼻子"]) {
//                    //鼻子
//                    CGPoint noseLeft = [self convertFicialModelToGpoint:face.landmark.nose_left];
//                    CGPoint noseRight = [self convertFicialModelToGpoint:face.landmark.nose_right];
//                    CGPoint noseCenter = CGPointMake((noseLeft.x/2 + noseRight.x/2), (noseLeft.y/2 + noseRight.y/2));
//                    CGFloat noseDistance = distanceBetweenPoints(noseLeft, noseRight);
//                    width = noseDistance;
//                    center = noseCenter;
//                    imageView = faceRect.noseImageView;
//                }
//                else if ([part.name isEqualToString:@"mouth"]) {
//                    //嘴
//                    CGPoint mouthLeft = [self convertFicialModelToGpoint:face.landmark.mouth_left_corner];
//                    CGPoint mouthRight = [self convertFicialModelToGpoint:face.landmark.mouth_right_corner];
//                    CGPoint mouthCenter = CGPointMake((mouthLeft.x/2 + mouthRight.x/2), (mouthLeft.y/2 + mouthRight.y/2));
//                    CGFloat mouthDistance =  distanceBetweenPoints(mouthLeft, mouthRight);
//                    width = mouthDistance;
//                    center = mouthCenter;
//                    imageView = faceRect.mouthImageView;
//                }
//                
//                if (!imageView.superview) {
//                    [self addSubview:imageView];
//                }
//                
//                center = CGPointMake(center.x, center.y - width * (offset/3.0));//根据偏移设中心位置
//                
//                imageView.transform = CGAffineTransformIdentity;
//                imageView.frame = CGRectMake(center.x - width * scale/2, center.y - width * scale/ (2 * ration), width * scale ,width * scale/ration);
//                imageView.transform = rotationTransform;
//                
//                imageView.images = [part images];
//                imageView.totalDuration = self.totalDuration;
//                
//                if (part == self.faceModel.parts.lastObject) {
//                    if (!faceRect.isAnimating) {
//                        imageView.totalDuration = self.totalDuration;
//                        [faceRect startAnimation];
//                    }
//                }
//            }
//            break;
//        }
//    }
    
    //    [[UIColor greenColor] set];
    //    CGContextSetLineWidth(context, 6);
    //    CGContextStrokePath(context);
}


#pragma mark - 

- (NSString *)trackFrame:(UIImage *)originImage {

    NSData *data = UIImagePNGRepresentation(originImage);
    
    IFlyFaceDirectionType faceOrientation = IFlyFaceDirectionTypeLeft;
    IFlyFaceImage* faceImage = [[IFlyFaceImage alloc] init];
    faceImage.direction = faceOrientation;
    faceImage.width = originImage.size.width;
    faceImage.height = originImage.size.height;
    faceImage.data = data;
    
    if(!faceImage){
        return nil;
    }
    NSString* strResult = [self.faceDetector trackFrame:faceImage.data withWidth:faceImage.width height:faceImage.height direction:(int)faceImage.direction];
    
//    if(!result){
//        faceImg = nil;
//        return;
//    }
//    @try {
//        NSError* error;
//        NSData* resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary* faceDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
//        resultData = nil;
//        if(!faceDic){
//            return;
//        }
//        
//        NSString *faceRet = [faceDic objectForKey:KCIFlyFaceResultRet];
//        NSArray *faceArray = [faceDic objectForKey:KCIFlyFaceResultFace];
//        faceDic = nil;
//        
//        int ret = 0;
//        if(faceRet){
//            ret = [faceRet intValue];
//        }
//        //没有检测到人脸或发生错误
//        if (ret || !faceArray || [faceArray count] < 1) {
//            
//            WEAKSELF
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (weakSelf && weakSelf.delegate) {
//                    if ([weakSelf.delegate respondsToSelector:@selector(didFailToDetectFace)]) {
//                        [weakSelf.delegate didFailToDetectFace];
//                    }
//                }
//            } ) ;
//            return;
//        }
//        
//        NSError *errorModel = nil;
//        NSMutableArray *persons = [FaceModel arrayOfModelsFromDictionaries:faceArray error:&errorModel];
//        NSLog(@"person ====%@",persons);
//        
//        WEAKSELF
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSucceedToDetectFace:)]) {
//                [weakSelf.delegate didSucceedToDetectFace:persons];
//            }
//            
//        } ) ;
//        
//        faceArray = nil;
//    }
//    @catch (NSException *exception) {
//        NSLog(@"prase exception:%@",exception.name);
//    }
//    @finally {
//        faceImg = nil;
//    }

    return nil;
}





@end
