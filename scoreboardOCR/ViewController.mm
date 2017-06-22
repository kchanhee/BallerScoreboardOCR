//
//  ViewController.m
//  scoreboardOCR
//
//  Created by Chan on 6/13/17.
//  Copyright © 2017 Chan. All rights reserved.
//

#import "ViewController.h"
//#import "Tesseract.h"

@interface ViewController ()
{
    CvVideoCamera *videoCamera;
}

@property (strong) G8Tesseract *ts;
@property (strong) UIView *team1Score;
@property (strong) UIView *team2Score;
@property (nonatomic, retain) CvVideoCamera *videoCamera;
@property (strong, nonatomic) UIButton *start;
@property (assign) BOOL isOn;
@property (strong) NSTimer *timer;
@property (strong) UIImageView *preview1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.view];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.videoCamera.defaultFPS = 60;
    self.videoCamera.grayscaleMode = YES;
    
    self.videoCamera.delegate = self;
    [self.videoCamera unlockFocus];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.start = [[UIButton alloc] init];
    [self.start setTitle:@"Start" forState:UIControlStateNormal];
    [self.start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.start setBackgroundColor:[UIColor blackColor]];
    [self.start addTarget:self action:@selector(actionStart:) forControlEvents:UIControlEventTouchUpInside];
    
    self.team1Score = [[UIView alloc] init];
    self.preview1 = [[UIImageView alloc] init];
    
    // Initialize the `G8Tesseract` object using the config files
    self.ts = [[G8Tesseract alloc] initWithLanguage:@"eng+Digital-7"];

    self.ts.delegate = self;
    //    self.ts.charWhitelist = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    [self.ts setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharWhitelist];

    self.ts.maximumRecognitionTime = 2.0;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.start setBounds:CGRectMake(0, 0, 100, 45)];
    [self.start setFrame:CGRectMake(30, 50, 100, 45)];
    
    [self.team1Score setBounds:CGRectMake(0, 0, 200, 75)];
    [self.team1Score setFrame:CGRectMake(0, 0, 200, 75)];
    self.team1Score.center = self.view.center;
    
    [self.preview1 setBounds:CGRectMake(0, 0, 195, 70)];
    [self.preview1 setFrame:CGRectMake(10, 150, 195, 70)];
    [self.preview1 setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.start];
    [self.view addSubview:self.team1Score];
    [self.view addSubview:self.preview1];
    
    [self.team1Score setBackgroundColor:[UIColor clearColor]];
    self.team1Score.layer.borderColor = [UIColor greenColor].CGColor;
    self.team1Score.layer.borderWidth = 2.0;
    
    [self.view bringSubviewToFront:self.start];
    
}

-(void)actionStart:(UIButton *)sender {
    if (self.isOn) {
        [self.start setTitle:@"Start" forState:UIControlStateNormal];
        [self.videoCamera stop];
        [self.timer invalidate];

    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(doOCR) userInfo:nil repeats:YES];
        [self.start setTitle:@"Stop" forState:UIControlStateNormal];
        [self.videoCamera start];
    }
    [self.view bringSubviewToFront:self.start];
    [self.view bringSubviewToFront:self.team1Score];
    [self.view bringSubviewToFront:self.preview1];
    self.isOn = !self.isOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)doOCR {
    self.preview1.image = [self captureView:self.team1Score];
}

- (UIImage* )captureView:(UIView *)yourView {
    //first we will make an UIImage from your view
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //now we will position the image, X/Y away from top left corner to get the portion we want
    UIGraphicsBeginImageContext(yourView.frame.size);
    [sourceImage drawAtPoint:CGPointMake(-yourView.frame.origin.x, -yourView.frame.origin.y)];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(croppedImage,nil, nil, nil);
    return croppedImage;
}

@end
