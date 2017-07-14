//
//  Person.h
//  FaceDetect
//
//  Created by Darcy on 2017/7/14.
//  Copyright © 2017年 Darcy. All rights reserved.
//

#import "JSONModel.h"

@interface FacialPartModel : JSONModel

@property (nonatomic) NSNumber *x;
@property (nonatomic) NSNumber *y;

@end

@interface PositionModel : JSONModel

@property (nonatomic)NSNumber *bottom;
@property (nonatomic)NSNumber *top;
@property (nonatomic)NSNumber *left;
@property (nonatomic)NSNumber *right;

@end


@interface LeftEyeLeftCorner : FacialPartModel

@end


@interface LeftEyeRightCorner : FacialPartModel

@end

@interface NoseLeft : FacialPartModel

@end

@interface RightEyeRightCorner : FacialPartModel

@end

@interface LefteEyeRightCorner : FacialPartModel

@end

@interface NoseBottom : FacialPartModel

@end

@interface MouthLeftCorner : FacialPartModel

@end


@interface MouthMiddle : FacialPartModel

@end

@interface RightEyebrowRightCorner : FacialPartModel

@end

@interface MouthLowerLipBottom : FacialPartModel

@end

@interface RightEyeCenter : FacialPartModel

@end

@interface LeftEyeCenter : FacialPartModel

@end

@interface RightEyebrowLeftCorner : FacialPartModel
@end


@interface NoseTop : FacialPartModel
@end

@interface LeftEyebrowLeftCorner : FacialPartModel
@end


@interface RightEyeLeftCorner : FacialPartModel

@end

@interface NoseRight : FacialPartModel
@end


@interface RightEyebrowMiddle : FacialPartModel
@end


@interface LeftEyebrowMiddle : FacialPartModel
@end


@interface LeftEyebrowRightCorner : FacialPartModel
@end

@interface MouthUpperLipTop : FacialPartModel
@end


@interface MouthRightCorner : FacialPartModel
@end


@protocol LeftEyeLeftCorner;
@protocol LeftEyeRightCorner;
@protocol NoseLeft;
@protocol RightEyeRightCorner;
@protocol LefteEyeRightCorner;
@protocol NoseBottom;
@protocol MouthLeftCorner;
@protocol MouthMiddle;
@protocol RightEyebrowRightCorner;
@protocol MouthLowerLipBottom;
@protocol RightEyeCenter;
@protocol LeftEyeCenter;
@protocol RightEyebrowLeftCorner;
@protocol NoseTop;
@protocol LeftEyebrowLeftCorner;
@protocol RightEyeLeftCorner;
@protocol NoseRight;
@protocol RightEyebrowMiddle;
@protocol LeftEyebrowMiddle;
@protocol LeftEyebrowRightCorner;
@protocol MouthUpperLipTop;
@protocol MouthRightCorner;


@interface LandmarkModel : JSONModel

@property (nonatomic ,strong)LeftEyeLeftCorner <LeftEyeLeftCorner> *left_eye_left_corner;
@property (nonatomic ,strong)LeftEyeRightCorner <LeftEyeRightCorner> *left_eye_right_corner;
@property (nonatomic ,strong)NoseLeft <NoseLeft> *nose_left;
@property (nonatomic ,strong)RightEyeRightCorner <RightEyeRightCorner> *right_eye_right_corner;
@property (nonatomic ,strong)NoseBottom <NoseBottom> *nose_bottom;
@property (nonatomic ,strong)MouthLeftCorner <MouthLeftCorner> *mouth_left_corner;
@property (nonatomic ,strong)MouthMiddle <MouthMiddle> *mouth_middle;
@property (nonatomic ,strong)RightEyebrowRightCorner <RightEyebrowRightCorner> *right_eyebrow_right_corner;
@property (nonatomic ,strong)MouthLowerLipBottom <MouthLowerLipBottom> *mouth_lower_lip_bottom;
@property (nonatomic ,strong)RightEyeCenter <RightEyeCenter> *right_eye_center;
@property (nonatomic ,strong)LeftEyeCenter <LeftEyeCenter> *left_eye_center;
@property (nonatomic ,strong)RightEyebrowLeftCorner <RightEyebrowLeftCorner> *right_eyebrow_left_corner;
@property (nonatomic ,strong)NoseTop <NoseTop> *nose_top;
@property (nonatomic ,strong)LeftEyebrowLeftCorner <LeftEyebrowLeftCorner> *left_eyebrow_left_corner;
@property (nonatomic ,strong)RightEyeLeftCorner <RightEyeLeftCorner> *right_eye_left_corner;
@property (nonatomic ,strong)NoseRight <NoseRight> *nose_right;
@property (nonatomic ,strong)RightEyebrowMiddle <RightEyebrowMiddle> *right_eyebrow_middle;
@property (nonatomic ,strong)LeftEyebrowMiddle <LeftEyebrowMiddle> *left_eyebrow_middle;
@property (nonatomic ,strong)LeftEyebrowRightCorner <LeftEyebrowRightCorner> *left_eyebrow_right_corner;
@property (nonatomic ,strong)MouthUpperLipTop <MouthUpperLipTop> *mouth_upper_lip_top;
@property (nonatomic ,strong)MouthRightCorner <MouthRightCorner> *mouth_right_corner;


@end


@interface FaceModel : JSONModel

@property (nonatomic)LandmarkModel *landmark;
@property (nonatomic)PositionModel *position;


@end




