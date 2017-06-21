//
//  ViewController.h
//  scoreboardOCR
//
//  Created by Chan on 6/13/17.
//  Copyright © 2017 Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <opencv2/videoio/cap_ios.h>

using namespace cv;
@interface ViewController : UIViewController <CvVideoCameraDelegate, G8TesseractDelegate>
@property (strong) CvVideoCamera *camera;

@end

