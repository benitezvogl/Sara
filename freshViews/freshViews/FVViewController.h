//
//  FVViewController.h
//  freshViews
//
//  Created by collider on 2/22/13.
//  Copyright (c) 2013 collider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import "PdDispatcher.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMotion/CoreMotion.h>
#import "ExternalDisplayHandler.h"

@interface FVViewController : UIViewController <ExternalDisplayHandlerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate>{
    ExternalDisplayHandler *externalDisplayHandler;
    PdDispatcher *dispatcher;
    void *patch;
    NSTimer *time;
    CMMotionManager *motionManager;
    NSOperationQueue *operationQueue;
    //Views
    CALayer *_customLayer;
    AVCaptureSession *_session;
    UIImageView *_imageView;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    //Menu
    UIButton *burgerButton;
    UIButton *gearButton;
    UIButton *eyeButton;
    
    UIButton *filterNone;
    UIButton *filterSepia;
    UIButton *filterInvert;
    UIButton *filterSuper;
    UIButton *filterCrystal;
    UILabel *filterLabel;
    UILabel *infoLabel;
    
    UIImageView *testImages;
    UIImageView *bottomBar;
}

@property(nonatomic,retain)IBOutlet UIButton *testButton;

@property(nonatomic,retain)IBOutlet UILabel *yawLabel;
@property(nonatomic,retain)IBOutlet UILabel *rollLabel;
@property(nonatomic,retain)IBOutlet UILabel *pitchLabel;

@property(nonatomic,retain)ExternalDisplayHandler *externalDisplayHandler;

@property(nonatomic,retain)IBOutlet UIImageView *cameraView;
@property(nonatomic,retain)IBOutlet UIImageView *testView;
//Views
@property(nonatomic,retain)CALayer *customLayer;
@property(nonatomic,retain)AVCaptureSession *session;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)AVCaptureVideoPreviewLayer *prevLayer;

//Menu stuff
@property(nonatomic,retain)IBOutlet UIButton *burgerButton;
@property(nonatomic,retain)IBOutlet UIButton *gearButton;
@property(nonatomic,retain)IBOutlet UIButton *eyeButton;

@property(nonatomic,retain)IBOutlet UIButton *filterNone;
@property(nonatomic,retain)IBOutlet UIButton *filterSepia;
@property(nonatomic,retain)IBOutlet UIButton *filterInvert;
@property(nonatomic,retain)IBOutlet UIButton *filterSuper;
@property(nonatomic,retain)IBOutlet UIButton *filterCrystal;

@property(nonatomic,retain)IBOutlet UILabel *filterLabel;
@property(nonatomic,retain)IBOutlet UILabel *infoLabel;

@property(nonatomic,retain)IBOutlet UIImageView *testImages;
@property(nonatomic,retain)IBOutlet UIImageView *bottomBar;

//Menu functions
-(IBAction)openFilterList:(id)sender;
-(IBAction)selectFilter:(id)sender;

-(IBAction)selectSepia:(id)sender;
-(IBAction)selectInvert:(id)sender;
-(IBAction)selectLine:(id)sender;
-(IBAction)selectPixel:(id)sender;

-(IBAction)showImage:(id)sender;

-(IBAction)showGroupInformation:(id)sender;
-(void)setupCapture;

@end
