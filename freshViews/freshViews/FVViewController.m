//
//  FVViewController.m
//  freshViews
//
//  Created by collider on 2/22/13.
//  Copyright (c) 2013 collider. All rights reserved.
//

#import "FVViewController.h"

@interface FVViewController ()

@end

@implementation FVViewController
@synthesize externalDisplayHandler=_externalDisplayHandler;
//Testing
@synthesize customLayer=_customLayer;
@synthesize session=_session;
@synthesize imageView=_imageView;
@synthesize prevLayer=_prevLayer;
//Labels
@synthesize yawLabel=_yawLabel;
@synthesize rollLabel=_rollLabel;
@synthesize pitchLabel=_pitchLabel;

//Menu
@synthesize burgerButton,gearButton,eyeButton;
@synthesize filterNone,filterSepia,filterInvert,filterSuper,filterCrystal;
@synthesize filterLabel,infoLabel;
@synthesize testImages,bottomBar;

int filterNum=1;

#define degrees(x) (180 * x / M_PI)

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //For bluetooth...?
    /*UIView *mpVolumeViewParentView=[[UIView alloc]initWithFrame:CGRectMake(5, 50, 50, 40)];
    mpVolumeViewParentView.backgroundColor=[UIColor redColor];
    mpVolumeViewParentView.clipsToBounds=YES;
    
    MPVolumeView *sysVolSlider=[[MPVolumeView alloc]initWithFrame:CGRectMake(-290, 0, 320, 40)];
    [mpVolumeViewParentView addSubview:sysVolSlider];
    [sysVolSlider release];
    
    [self.view addSubview:mpVolumeViewParentView];
    [mpVolumeViewParentView release];*/
    
    /*UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
    [recognizer setDelegate:self];
    [recognizer setNumberOfTapsRequired:2];
    [recognizer setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:recognizer];*/
    
    //Menu hide/unhide
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
    [recognizer setDelegate:self];
    [recognizer setNumberOfTapsRequired:2];
    [recognizer setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:recognizer];
    
    //External video setup
    self.externalDisplayHandler=[[ExternalDisplayHandler alloc]init];
    self.externalDisplayHandler.delegate=self;
    [self.externalDisplayHandler.contentView addSubview:self.view];
    
    //Gyro
    motionManager=[[CMMotionManager alloc]init];
    motionManager.deviceMotionUpdateInterval=1/60;
    [motionManager startDeviceMotionUpdates];
    
    if([motionManager isGyroAvailable]){
        if(![motionManager isGyroActive]){
            [motionManager setGyroUpdateInterval:.1];
            [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData,NSError *error){
                
            }];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No gyro!" message:@"Need a gyro@" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alert show];
    }
    
    //Do this if after a filter has been selected
    //[self setupCapture];
    
    //T1 and T2 have sara_02.pd
    //T3 has sara_synth_1.pd
    //T4 has sara_synth_4b.pd
    //Channel 1 (BT: 08): Tanya
    //Channel 2 (BT: 09): Jenny
    //Channel 3 (BT: BE): Michelle
    //Channel 4 (BT: NEW): Kim 
    //Pd sound stuff
    dispatcher=[[PdDispatcher alloc]init];
    [PdBase setDelegate:dispatcher];
    //Type in pd patch name. IE: openFile:@"patch_name_here.pd"
    patch=[PdBase openFile:@"sara_synth_4b.pd" path:[[NSBundle mainBundle]resourcePath]];
    if(!patch){
        NSLog(@"Failed to open patch!");
    }
    


    //Labels
    /*
    self.rollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [self.rollLabel setText:@"Roll:"];
    [self.rollLabel setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.rollLabel];
    
    self.pitchLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 20)];
    [self.pitchLabel setText:@"Pitch:"];
    [self.pitchLabel setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.pitchLabel];
    
    self.yawLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 20)];
    [self.yawLabel setText:@"Yaw:"];
    [self.yawLabel setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.yawLabel];
     */
     
    time=[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(try) userInfo:nil repeats:YES];
    
}
-(IBAction)openFilterList:(id)sender{
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
}

-(IBAction)selectFilter:(id)sender{
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    [self setupCapture];
}

-(IBAction)selectSepia:(id)sender{
    filterNum=1;
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    [self setupCapture];
}

-(IBAction)selectInvert:(id)sender{
    filterNum=2;
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    [self setupCapture];
}

-(IBAction)selectLine:(id)sender{
    filterNum=3;
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    [self setupCapture];
}

-(IBAction)selectPixel:(id)sender{
    filterNum=4;
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    [self setupCapture];
}

-(IBAction)showImage:(id)sender{
    if([[sender currentTitle] isEqualToString:@"burger"]){
        testImages.image=[UIImage imageNamed:@"burger.png"];
    }
}

-(IBAction)showGroupInformation:(id)sender{
    infoLabel.hidden=!infoLabel.hidden;
    filterLabel.hidden=!filterLabel.hidden;
    if(filterNone.hidden!=true){
        filterNone.hidden=!filterNone.hidden;
        filterSepia.hidden=!filterSepia.hidden;
        filterInvert.hidden=!filterInvert.hidden;
        filterSuper.hidden=!filterSuper.hidden;
        filterCrystal.hidden=!filterCrystal.hidden;
    }
    testImages.image=[UIImage imageNamed:@"gear.png"];
}

-(void)doubleTap{
    [self.session stopRunning];
    [self.session release];

    if(infoLabel.hidden!=true){
        infoLabel.hidden=!infoLabel.hidden;
    }
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    
}
/*-(void)doubleTap{
    if(filterNum==0){
        filterNum++;
    }else{
        filterNum=0;
    }
}*/
-(void)setupCapture{
    //Set up input
    AVCaptureDevice *device=[self frontCamera];
    AVCaptureDeviceInput *captureInput=[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //Set up output
    AVCaptureVideoDataOutput *captureOutput=[[AVCaptureVideoDataOutput alloc]init];
    captureOutput.alwaysDiscardsLateVideoFrames=YES;
    
    //Serial queue
    dispatch_queue_t queue;
    queue=dispatch_queue_create("cameraQueue", NULL);
    //Slower output
    //[captureOutput setSampleBufferDelegate:self queue:queue];
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    dispatch_release(queue);
    
    NSString *key=(NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value=[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *videoSettings=[NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    //Create capture session
    self.session=[[AVCaptureSession alloc]init] ;
    //Add input and output
    [self.session addInput:captureInput];
    [self.session addOutput:captureOutput];
    
    //Quality
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    //Set orientation (main view)
    self.customLayer=[CALayer layer];
    self.customLayer.frame=self.view.bounds;
    self.customLayer.transform=CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
    self.customLayer.contentsGravity=kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:self.customLayer];
    //Image view
    /*self.imageView=[[UIImageView alloc]init];
    self.imageView.frame=CGRectMake(0, 0, 100, 100);
    [self.view addSubview:self.imageView];
    //Preview layer
    self.prevLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prevLayer.frame=CGRectMake(100, 0, 100, 100);
    self.prevLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.prevLayer];*/
    //Start capture
    [self.session startRunning];

}
-(void)try{
    CMDeviceMotion *motion=motionManager.deviceMotion;
    CMAttitude *attitude=motion.attitude;

    float rollVal=degrees(attitude.roll);
    float pitchVal=degrees(attitude.pitch);
    float yawVal=degrees(attitude.yaw);
    float testVal=(rollVal+pitchVal+yawVal)/3;
    
    /*
    NSString *rollString=[NSString stringWithFormat:@"Roll: %0.2f",rollVal];
    [self.rollLabel setText:rollString];
    NSString *pitchString=[NSString stringWithFormat:@"Pitch: %0.2f",pitchVal];
    [self.pitchLabel setText:pitchString];
    NSString *yawString=[NSString stringWithFormat:@"Yaw: %0.2f",yawVal];
    [self.yawLabel setText:yawString];
*/
    [PdBase sendFloat:fabsf(testVal) toReceiver:@"midinote"];
    [PdBase sendFloat:fabsf(rollVal) toReceiver:@"roll"];
    [PdBase sendFloat:fabsf(pitchVal) toReceiver:@"pitch"];
    [PdBase sendFloat:fabsf(yawVal) toReceiver:@"yaw"];
    [PdBase sendBangToReceiver:@"trigger"];
}
- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    //Not on the main_queue
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    CVImageBufferRef imageBuffer=CMSampleBufferGetImageBuffer(sampleBuffer);
    //Lock image buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    //Info about the image
    uint8_t *baseAddress=(uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow=CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width=CVPixelBufferGetWidth(imageBuffer);
    size_t height=CVPixelBufferGetHeight(imageBuffer);
    
    //CGImageRef from CVImageBufferRef
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext=CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage=CGBitmapContextCreateImage(newContext);
    
    //Release some stuff
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    CIImage *beginImage=[CIImage imageWithCGImage:newImage];
    CIImage *filteredImage;
    CIContext *context=[CIContext contextWithOptions:nil];
    
    //Filters (Enable one at a time)
    
    /*
     
     
     
     

     //DotScreen filter (change width for size of dots)
     CIFilter *dotScreenFilter=[CIFilter filterWithName:@"CIDotScreen" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:200 Y:200], @"inputAngle", [NSNumber numberWithFloat:90], @"inputWidth", [NSNumber numberWithFloat:100],nil];
     filteredImage=[dotScreenFilter valueForKey:@"outputImage"];
     */
     
     /*
     //Sepia tone filter
     CIFilter *sepFilter=[CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
     filteredImage=[sepFilter valueForKey:@"outputImage"];
     
     //CICircleScreen
     CIFilter *circScreenFilter=[CIFilter filterWithName:@"CICircularScreen" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:200 Y:200], @"inputWidth",[NSNumber numberWithFloat:20], nil];
     filteredImage=[circScreenFilter valueForKey:@"outputImage"];
     
     //+++New filters+++
     //HueAdjust
     CIFilter *testFilter=[CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, beginImage, @"inputAngle", [NSNumber numberWithFloat:1.00], nil];
     filteredImage=[testFilter valueForKey:@"outputImage"];
    */ 
     //CIColorPosterize
     //CIFilter *posterizeFilter=[CIFilter filterWithName:@"CIColorPosterize" keysAndValues:kCIInputImageKey, beginImage, @"inputLevels", [NSNumber numberWithFloat:10.00], nil];
     //filteredImage=[posterizeFilter valueForKey:@"outputImage"];
    /*
    //Hatched Screen
    //CIFilter *testFilter=[CIFilter filterWithName:@"CIHatchedScreen" keysAndValues:kCIInputImageKey, beginImage,@"inputAngle",[NSNumber numberWithFloat:90], nil];
    //filteredImage=[testFilter valueForKey:@"outputImage"];
    */
    //*** Filters used in Menu ***
    //Sepia
    if(filterNum==1){
        CIFilter *sepFilter=[CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
    }
    //Color inverter filter
    if(filterNum==2){
        CIFilter *colInvertFilter=[CIFilter filterWithName:@"CIColorInvert" keysAndValues:kCIInputImageKey,     beginImage, nil];
        filteredImage=[colInvertFilter valueForKey:@"outputImage"];
    }
    //Lines on the screen
    if(filterNum==3){
        CIFilter *lineFilter=[CIFilter filterWithName:@"CILineScreen" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:200 Y:200], @"inputAngle", [NSNumber numberWithFloat:90], @"inputWidth", [NSNumber numberWithFloat:100], nil];
        filteredImage=[lineFilter valueForKey:@"outputImage"];
    }
    //Pixel filter
    if(filterNum==4){
        CIFilter *pixFilter=[CIFilter filterWithName:@"CIPixellate" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:100 Y:100], @"inputScale", [NSNumber numberWithFloat:6.0],nil];
        filteredImage=[pixFilter valueForKey:@"outputImage"];
    }
    
    
    
    CGImageRef cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
    //newImage=[UIImage imageWithCGImage:cgimg];
    
    [self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject:(id)cgimg waitUntilDone:YES];
    
    UIImage *image=[UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    
    //Release CGImageRef
    CGImageRelease(cgimg);
    CGImageRelease(newImage);
    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    
    //Unlock Image buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    [pool drain];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    self.imageView=nil;
    self.customLayer=nil;
    self.prevLayer=nil;
}
-(void)dealloc{
    [self.session release];
    [super dealloc];
}
@end
