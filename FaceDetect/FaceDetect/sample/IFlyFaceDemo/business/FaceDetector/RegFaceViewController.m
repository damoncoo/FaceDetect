//
//  RegFaceViewController.m
//  IFlyMSCDemo
//
//  Created by 张剑 on 15/5/5.
//
//

#import "RegFaceViewController.h"
#import "Definition.h"
#import "PopupView.h"
#import "AlertView.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "RegFaceImageViewController.h"


@interface RegFaceViewController ()


@property (nonatomic, strong)  UIButton *photoBtn;
@property (nonatomic, strong)  UIButton *changeCameraBtn;
@property (nonatomic, strong)  UIButton *flashBtn;



@end

@implementation RegFaceViewController

@synthesize captureManager;
@synthesize overlayLabel;

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
    //adjust the UI for iOS 7
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER ){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UIView *mainView = [[UIView alloc] initWithFrame:frame];
    mainView.backgroundColor = [UIColor whiteColor];
    self.view = mainView;
    
    //注册人脸
    self.title = @"注册人脸";
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    //初始化 CaptureSessionManager
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    [[self captureManager] setDelegate:self];
    
    CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
    [[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    //设置摄像方向，不可删除
    [[self captureManager] setInterfaceOrientation:self.interfaceOrientation];
    [[self captureManager] createQueue];
    
    //overlay
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_frame.png"]];
    overlayImageView.center=self.view.center;
    [[self view] addSubview:overlayImageView];
    
    //提示条
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, ButtonHeight)];
    [self setOverlayLabel:tempLabel];
    [overlayLabel setCenter:CGPointMake(overlayImageView.center.x, overlayImageView.center.y-overlayImageView.frame.size.height/2-ButtonHeight)];
    [overlayLabel setBackgroundColor:[UIColor clearColor]];
    UIFont* font=[UIFont systemFontOfSize:24.0f];
    [overlayLabel setFont:font];
    [overlayLabel setTextColor:[UIColor whiteColor]];
    [overlayLabel setText:@"请对准面部后点击快门"];
    [overlayLabel setTextAlignment:NSTextAlignmentCenter];
    [[self view] addSubview:overlayLabel];
    
    //photo
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    photoBtn.frame = CGRectMake((self.view.frame.size.width-Padding*4)/5, self.view.frame.size.height-iOS7TopMargin-ButtonHeight, (self.view.frame.size.width-Padding*4)/4, ButtonHeight);
    [photoBtn addTarget:self action:@selector(onBtnPhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.photoBtn=photoBtn;
    [[self view] addSubview:photoBtn];

    //changeCamera
    UIButton* changeCameraBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changeCameraBtn setTitle:@"摄像头" forState:UIControlStateNormal];
    changeCameraBtn.frame = CGRectMake((self.view.frame.size.width-Padding*4)*2/5, self.view.frame.size.height-iOS7TopMargin-ButtonHeight, (self.view.frame.size.width-Padding*4)/4, ButtonHeight);
    [self.view addSubview:changeCameraBtn];
    [changeCameraBtn addTarget:self action:@selector(onBtnChangeCamera:) forControlEvents:UIControlEventTouchUpInside];
    self.changeCameraBtn = changeCameraBtn;
    
    //flash
    UIButton* flashBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [flashBtn setTitle:@"闪光灯" forState:UIControlStateNormal];
    flashBtn.frame = CGRectMake((self.view.frame.size.width-Padding*4)*3/5, self.view.frame.size.height-iOS7TopMargin-ButtonHeight, (self.view.frame.size.width-Padding*4)/4, ButtonHeight);
    [self.view addSubview:flashBtn];
    [flashBtn addTarget:self action:@selector(onBtnFlash:) forControlEvents:UIControlEventTouchUpInside];
    self.flashBtn = flashBtn;
    
    //
    [[captureManager session] startRunning];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[self captureManager] addObserver];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[self captureManager] removeObserver];
}

- (BOOL)shouldAutorotate{
    // Disable autorotation of the interface when recording is in progress.
    return ![captureManager lockInterfaceRotation];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [[self captureManager] setInterfaceOrientation:toInterfaceOrientation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    [self.captureManager observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
#pragma mark - Actions


- (void)toggleMovieRecording:(id)sender{
    [[self captureManager] toggleMovieRecording];
}
- (void)onBtnChangeCamera:(id)sender{
    [[self captureManager] changeCamera];
}
- (void)onBtnPhoto:(id)sender{
    [[self captureManager] snapStillImage];
}
- (void)onBtnFlash:(id)sender{
    [[self captureManager] toggleFlashMode];
}
- (void)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer{
    [[self captureManager] focusAndExposeTap:gestureRecognizer];
}

#pragma mark - CaptureSessionManagerDelegate

-(void)cameraWillChange{
    self.photoBtn.enabled=NO;
    self.changeCameraBtn.enabled=NO;
    self.flashBtn.enabled=NO;
}

-(void)cameraDidChanged{
    self.photoBtn.enabled=YES;
    self.changeCameraBtn.enabled=YES;
    self.flashBtn.enabled=YES;
}

-(void)stillImageCaptured:(UIImage*)image{
    RegFaceImageViewController* regFaceimg=[[RegFaceImageViewController alloc] init];
    regFaceimg.face=image;
    [self.navigationController pushViewController:regFaceimg animated:YES];
}

-(void)observerContext:(CaptureSessionContextType)type Changed:(BOOL)boolValue{
    
    switch(type){
        case CaptureSessionContextTypeRecording:{
            if (boolValue){
                [[self changeCameraBtn] setEnabled:NO];
            }
            else{
                [[self changeCameraBtn] setEnabled:YES];
            }
        }
        case CaptureSessionContextTypeRunningAndDeviceAuthorized:{
            if (boolValue){
                self.photoBtn.enabled=YES;
                self.changeCameraBtn.enabled=YES;
                self.flashBtn.enabled=YES;
            }
            else{
                self.photoBtn.enabled=NO;
                self.changeCameraBtn.enabled=NO;
                self.flashBtn.enabled=NO;
            }
        }
        default:
            break;
    }

}

@end


