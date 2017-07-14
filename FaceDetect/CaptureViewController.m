
#import "CaptureViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GPUImage.h"
#import "NAFilter.h"
#import <iflyMSC/IFlyFaceSDK.h>
#import "IFlyFaceImage.h"
#import "IFlyFaceResultKeys.h"
#import "CalculatorTools.h"
#import "CanvasView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FaceModel.h"

#define TIMER_INTERVAL 0.05f
#define TAG_ALERTVIEW_CLOSE_CONTROLLER 10086

#define kFixHeight (IS_IPHONE4?0:44.f)

#define m_enterTextHeight (1.f/4.5f)

#define IS_IPHONE4 YES

/////////

#define kImageCountForSecound 8.f
#define kImageTotalDuration 3.f

#define DEVICE_SIZE [[UIScreen mainScreen] bounds].size
#define DEVICE_OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define DELTA_Y (DEVICE_OS_VERSION >= 7.0f? 20.0f : 0.0f)

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define VIDEO_FOLDER @"Videos"

#define MIN_VIDEO_DUR 3.0f
#define MAX_VIDEO_DUR 15.0f


/////////

#define MAXLENGTH 8 // 最大字数

@interface CaptureViewController () <UINavigationControllerDelegate,UITextFieldDelegate, GPUImageVideoCameraDelegate, UIImagePickerControllerDelegate>
{
   
}

@property (nonatomic, assign) BOOL debugMode;

@property (retain, nonatomic) UIView *maskView;

//@property (retain, nonatomic) CameraRecorder *recorder;
@property (retain, nonatomic) GPUImageVideoCamera *recorder;
@property (nonatomic , strong) GPUImageView *cameraScreen;
@property (nonatomic , strong) GPUImageFilterGroup *currentGroup;
@property (nonatomic, strong) GPUImageFilter *currentFilter;


@property (retain, nonatomic) UIButton *closeButton;
@property (retain, nonatomic) UIButton *switchButton;
@property (retain, nonatomic) UIButton *settingButton;
@property (retain, nonatomic) UIButton *recordButton;
@property (retain, nonatomic) UIButton *flashButton;

@property (strong, nonatomic) UIView *importVideoView;
@property (strong, nonatomic) UIView *importPhotosView;

@property (assign, nonatomic) BOOL initalized;
@property (assign, nonatomic) BOOL isProcessingData;

@property (retain, nonatomic) UIView *preview;
@property (retain, nonatomic) UIImageView *focusRectView;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, assign) BOOL isCapturingImages;

@property (nonatomic, assign) NSInteger totalImageCount;
@property (nonatomic, assign) CGFloat totalDuration;
@property (nonatomic, strong) UIImage *lastSuccessImage;


/**
 *  New too
 */

@property (nonatomic, strong) NSTimer *capturingImageTimer;

/**
 *  Vedio Capture
 */
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, assign) BOOL finishWriteMovie;
@property (nonatomic, strong) NSString *moveSavePath;
@property (nonatomic, strong) NSTimer *capturingTimer;
@property (nonatomic, assign) NSTimeInterval capturingTimeInteval;



@property (nonatomic, strong ) IFlyFaceDetector *faceDetector;
@property (nonatomic) UIInterfaceOrientation interfaceOrientation;
//@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic, strong ) CanvasView *viewCanvas;
@property (nonatomic, retain ) AVCaptureVideoPreviewLayer *previewLayer;
//@property (nonatomic, strong ) UIView *previewView;

@property (nonatomic , strong) GPUImageAddBlendFilter *blendFilter;
@property (nonatomic , strong) GPUImageUIElement *faceView;

@end

@implementation CaptureViewController

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    [self initRecorder];
}

- (void)initRecorder
{
    
    NSString *url = [[NSBundle mainBundle] pathForResource:@"LMEffectResource" ofType:@"bundle"];
    NSLog(@"url is %@",url);
    
    self.recorder = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                                      cameraPosition:AVCaptureDevicePositionFront];
    self.recorder.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.recorder.horizontallyMirrorFrontFacingCamera = YES;
    self.recorder.delegate = self;
    self.recorder.audioEncodingTarget = self.movieWriter;


    [self setUpDetecter];
    [self.view addSubview:self.cameraScreen];
    [self.view bringSubviewToFront:self.viewCanvas];
    
    
    self.blendFilter = [[GPUImageAddBlendFilter alloc] init];//汇合的filter
    
    //美颜的链条
    [self.recorder addTarget:self.currentFilter];
    [self.currentFilter addTarget:self.blendFilter];
    [self.currentFilter addTarget:self.cameraScreen];

    //动画的链条
    [self.faceView addTarget:self.blendFilter];
    
    //汇合的链条
    [self.blendFilter addTarget:self.movieWriter];

    [self.recorder startCameraCapture];
    [self.movieWriter startRecording];
    
//    return;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.movieWriter finishRecording];
//        
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.moveSavePath))
//        {
//            [library writeVideoAtPathToSavedPhotosAlbum:[self.movieWriter valueForKey:@"movieURL"] completionBlock:^(NSURL *assetURL, NSError *error)
//             {
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     
//                     if (error) {
//                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
//                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                         [alert show];
//                     } else {
//                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
//                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                         [alert show];
//                     }
//                 });
//             }];
//        }
//        else {
//            NSLog(@"error mssg)");
//        }
//
//        
//    });
}

#pragma mark - 输出视图
- (GPUImageView *)cameraScreen {
    if (!_cameraScreen) {
        GPUImageView *cameraScreen = [[GPUImageView alloc] initWithFrame:CGRectMake(0, kFixHeight, DEVICE_SIZE.width, DEVICE_SIZE.width)];
//        cameraScreen.backgroundColor = [UIColor redColor];
        cameraScreen.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        _cameraScreen = cameraScreen;
        
        [self.currentGroup addTarget:cameraScreen];
    }
    return _cameraScreen;
}

- (GPUImageFilterGroup *)currentGroup
{
    if (!_currentGroup) {
        NAFilter *filter = [[NAFilter alloc] init];
        
        GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
        [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: filter]];
        [(GPUImageFilterGroup *) group setTerminalFilter:filter];
        
        _currentGroup = group;
    }
    return _currentGroup;
}

- (GPUImageFilter *)currentFilter
{
    if (!_currentFilter) {
        _currentFilter = [[NAFilter alloc] init];
    }
    return _currentFilter;
}

- (GPUImageMovieWriter *)movieWriter
{
    if (!_movieWriter) {
        NSURL *movieURL = [NSURL fileURLWithPath:self.moveSavePath];
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.f, 640.f)];
        unlink([self.moveSavePath UTF8String]);
        _movieWriter.encodingLiveVideo = YES;
        _movieWriter.hasAudioTrack = NO;
        [self.currentGroup addTarget:_movieWriter];
    }
    return _movieWriter;
}

- (NSString *)moveSavePath
{
    if (!_moveSavePath) {
//        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *movieSavePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"Movie"]];
        unlink([movieSavePath UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        _moveSavePath = movieSavePath;
    }
    return _moveSavePath;
}

#pragma mark - Set Up

- (void)setUpDetecter {
    
    self.faceDetector = [IFlyFaceDetector sharedInstance];
    if (self.faceDetector) {
        [self.faceDetector setParameter:@"1" forKey:@"detect"];
        [self.faceDetector setParameter:@"1" forKey:@"align"];
    }
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:self.cameraScreen.bounds] ;
    self.viewCanvas.center = self.cameraScreen.layer.position;
    self.viewCanvas.backgroundColor = [UIColor clearColor] ;
    [self.view addSubview:self.viewCanvas];
    self.faceView = [[GPUImageUIElement alloc]initWithView:self.viewCanvas];
}

#pragma mark - Delegate 

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    IFlyFaceImage *faceImage = [self faceImageFromSampleBuffer:sampleBuffer];
    [self onOutputFaceImage:faceImage];
    faceImage = nil;
}
- (void)doingCapturingImage:(UIImage *)image duration:(CGFloat)duration {
    
}

#pragma mark - Buffer 

// Create a IFlyFaceImage from sample buffer data

- (IFlyFaceImage *)faceImageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    
    //获取灰度图像数据
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    uint8_t *lumaBuffer  = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,0);
    size_t width  = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context=CGBitmapContextCreate(lumaBuffer, width, height, 8, bytesPerRow, grayColorSpace,0);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    IFlyFaceDirectionType faceOrientation = [self faceImageOrientation];
    IFlyFaceImage* faceImage = [[IFlyFaceImage alloc] init];
    if(!faceImage){
        return nil;
    }
    
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    
    faceImage.data = (__bridge_transfer NSData*)CGDataProviderCopyData(provider);
    faceImage.width = width;
    faceImage.height = height;
    faceImage.direction = faceOrientation;
    
    NSLog(@"width is %zu",width);
    NSLog(@"height is %zu",height);

    CGImageRelease(cgImage);
    CGContextRelease(context);
    CGColorSpaceRelease(grayColorSpace);
    
    return faceImage;
    
}

-(IFlyFaceDirectionType)faceImageOrientation{
    
    IFlyFaceDirectionType faceOrientation = IFlyFaceDirectionTypeLeft;
    BOOL isFrontCamera = self.recorder.frontFacingCameraPresent;
    switch (self.interfaceOrientation) {
        case UIDeviceOrientationPortrait:{//
            faceOrientation = IFlyFaceDirectionTypeLeft;
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:{
            faceOrientation = IFlyFaceDirectionTypeRight;
        }
            break;
        case UIDeviceOrientationLandscapeRight:{
            faceOrientation = isFrontCamera?IFlyFaceDirectionTypeUp:IFlyFaceDirectionTypeDown;
        }
            break;
        default:{//
            faceOrientation = isFrontCamera ? IFlyFaceDirectionTypeDown:IFlyFaceDirectionTypeUp;
        }
            
            break;
    }
    
    return faceOrientation;
}


//- (void)updateAccelertionData:(CMAcceleration)acceleration {
//    UIInterfaceOrientation orientationNew;
//    
//    if (acceleration.x >= 0.75) {
//        orientationNew = UIInterfaceOrientationLandscapeLeft;
//    }
//    else if (acceleration.x <= -0.75) {
//        orientationNew = UIInterfaceOrientationLandscapeRight;
//    }
//    else if (acceleration.y <= -0.75) {
//        orientationNew = UIInterfaceOrientationPortrait;
//    }
//    else if (acceleration.y >= 0.75) {
//        orientationNew = UIInterfaceOrientationPortraitUpsideDown;
//    }
//    else {
//        // Consider same as last time
//        return;
//    }
//    
//    if (orientationNew == self.interfaceOrientation)
//        return;
//    
//    self.interfaceOrientation = orientationNew;
//}

- (NSString*)praseDetect:(NSDictionary* )positionDic OrignImage:(IFlyFaceImage*)faceImg{
    
    if(!positionDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera = self.recorder.frontFacingCameraPresent;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.cameraScreen.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.cameraScreen.frame.size.height / faceImg.width;
    CGFloat bottom = [[positionDic objectForKey:KCIFlyFaceResultBottom] floatValue];
    CGFloat top = [[positionDic objectForKey:KCIFlyFaceResultTop] floatValue];
    CGFloat left = [[positionDic objectForKey:KCIFlyFaceResultLeft] floatValue];
    CGFloat right = [[positionDic objectForKey:KCIFlyFaceResultRight] floatValue];
    
    
    float cx = (left+right)/2;
    float cy = (top + bottom)/2;
    float w = right - left;
    float h = bottom - top;
    
    float ncx = cy ;
    float ncy = cx ;
    
    CGRect rectFace = CGRectMake(ncx-w/2 ,ncy-w/2 , w, h);
    
    if(!isFrontCamera){
        rectFace = rSwap(rectFace);
        rectFace = rRotate90(rectFace, faceImg.height, faceImg.width);
    }
    rectFace = rScale(rectFace, widthScaleBy, heightScaleBy);
    return NSStringFromCGRect(rectFace);
    
}

-(NSMutableArray*)praseAlign:(NSDictionary* )landmarkDic OrignImage:(IFlyFaceImage*)faceImg{
    if(!landmarkDic){
        return nil;
    }
    
    // 判断摄像头方向
    BOOL isFrontCamera = self.recorder.frontFacingCameraPresent;
    
    // scale coordinates so they fit in the preview box, which may be scaled
    CGFloat widthScaleBy = self.cameraScreen.frame.size.width / faceImg.height;
    CGFloat heightScaleBy = self.cameraScreen.frame.size.height / faceImg.width;
    
    NSMutableArray *arrStrPoints = [NSMutableArray array] ;
    NSEnumerator* keys = [landmarkDic keyEnumerator];
    for(id key in keys){
        id attr = [landmarkDic objectForKey:key];
        if(attr && [attr isKindOfClass:[NSDictionary class]]){
            
            id attr = [landmarkDic objectForKey:key];
            CGFloat x = [[attr objectForKey:KCIFlyFaceResultPointX] floatValue];
            CGFloat y = [[attr objectForKey:KCIFlyFaceResultPointY] floatValue];
            
            CGPoint p = CGPointMake(y,x);
            if(!isFrontCamera){
                p = pSwap(p);
                p = pRotate90(p, faceImg.height, faceImg.width);
            }
            
            p = pScale(p, widthScaleBy, heightScaleBy);
            [arrStrPoints addObject:NSStringFromCGPoint(p)];
            
        }
    }
    return arrStrPoints;
    
}


-(void)praseTrackResult:(NSString*)result OrignImage:(IFlyFaceImage*)faceImg {
    
    if(!result){
        return;
    }
    
    @try {
        NSError* error;
        NSData* resultData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* faceDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&error];
        resultData = nil;
        if(!faceDic){
            return;
        }
        
//        if ([faceDic[@"face"] count]) {
//            NSLog(@"result changed:%@",result);
//            
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"已检测到人脸" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//                    
//                } ) ;
//            });
//        }
        
        NSString *faceRet = [faceDic objectForKey:KCIFlyFaceResultRet];
        NSArray *faceArray = [faceDic objectForKey:KCIFlyFaceResultFace];
        faceDic = nil;
        
        int ret = 0;
        if(faceRet){
            ret = [faceRet intValue];
        }
        //没有检测到人脸或发生错误
        if (ret || !faceArray || [faceArray count] < 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideFace];
            } ) ;
            return;
        }
        
        NSError *errorModel = nil;
        NSMutableArray *persons = [FaceModel arrayOfModelsFromDictionaries:faceArray error:&errorModel];
        NSLog(@"person ====%@",persons);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showFaceLandmarksAndFaceRectWithPersonsArray:persons];
        } ) ;

        
        //检测到人脸
        NSMutableArray *arrPersons = [NSMutableArray array] ;
        for(id faceInArr in faceArray){
            if(faceInArr && [faceInArr isKindOfClass:[NSDictionary class]]){
                NSDictionary* positionDic = [faceInArr objectForKey:KCIFlyFaceResultPosition];
                NSString* rectString = [self praseDetect:positionDic OrignImage: faceImg];
                positionDic = nil;
                
                NSDictionary* landmarkDic = [faceInArr objectForKey:KCIFlyFaceResultLandmark];
                NSMutableArray* strPoints = [self praseAlign:landmarkDic OrignImage:faceImg];
                landmarkDic = nil;
                
                NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary] ;
                if(rectString){
                    [dicPerson setObject:rectString forKey:RECT_KEY];
                }
                if(strPoints){
                    [dicPerson setObject:strPoints forKey:POINTS_KEY];
                }
                
                strPoints = nil;
                [dicPerson setObject:@"0" forKey:RECT_ORI];
                [arrPersons addObject:dicPerson] ;
                dicPerson = nil;
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self showFaceLandmarksAndFaceRectWithPersonsArray:arrPersons];
                } ) ;
            }
        }
        faceArray = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"prase exception:%@",exception.name);
    }
    @finally {

    }
}


- (void) hideFace {
    if (!self.viewCanvas.hidden) {
        self.viewCanvas.hidden = YES ;
        [self.viewCanvas hideView];
    }
}

#pragma mark - CaptureManagerDelegate

-(void)onOutputFaceImage:(IFlyFaceImage*)faceImg {
    
    NSString* strResult = [self.faceDetector trackFrame:faceImg.data withWidth:faceImg.width height:faceImg.height direction:(int)faceImg.direction];
    
    //此处清理图片数据，以防止因为不必要的图片数据的反复传递造成的内存卷积占用。
    faceImg.data = nil;
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(praseTrackResult:OrignImage:)];
    if (!sig) return;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(praseTrackResult:OrignImage:)];
    [invocation setArgument:&strResult atIndex:2];
    [invocation setArgument:&faceImg atIndex:3];
    [invocation retainArguments];
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil  waitUntilDone:NO];
    faceImg = nil;
}

- (void)showFaceLandmarksAndFaceRectWithPersonsArray:(NSMutableArray *)arrPersons{
    if (self.viewCanvas.hidden) {
        self.viewCanvas.hidden = NO ;
    }
    self.viewCanvas.arrPersons = arrPersons ;
    [self.viewCanvas setNeedsDisplay] ;
}

@end
