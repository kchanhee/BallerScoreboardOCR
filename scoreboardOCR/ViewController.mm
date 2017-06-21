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
    
    
    
    // Initialize the `G8Tesseract` object using the config files
    self.ts = [[G8Tesseract alloc] initWithLanguage:@"eng"
                                                  configDictionary:nil
                                                   configFileNames:nil
                                             cachesRelatedDataPath:@"tessdata"
                                                        engineMode:G8OCREngineModeTesseractOnly];

    self.ts.delegate = self;
    //    self.ts.charWhitelist = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    [self.ts setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharWhitelist];

    self.ts.maximumRecognitionTime = 2.0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.start setBounds:CGRectMake(0, 0, 300, 45)];
    [self.start setFrame:CGRectMake(30, 50, 100, 45)];
    [self.view addSubview:self.start];
    [self.view bringSubviewToFront:self.start];
    
}

-(void)actionStart:(UIButton *)sender {
    [self.videoCamera start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
