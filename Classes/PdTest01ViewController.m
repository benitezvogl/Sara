#import "PdTest01ViewController.h"
#import "FVData.h"

@implementation PdTest01ViewController

//Testing
@synthesize customLayer=_customLayer;
@synthesize session=_session;
@synthesize imageView=_imageView;
@synthesize prevLayer=_prevLayer;
//Labels
@synthesize yawLabel=_yawLabel;
@synthesize rollLabel=_rollLabel;
@synthesize pitchLabel=_pitchLabel;
@synthesize rLabel=_rLabel;
@synthesize gLabel=_gLabel;
@synthesize bLabel=_bLabel;
@synthesize circles;
@synthesize externalDisplayHandler=_externalDisplayHandler;


#define degrees(x) (180 * x / M_PI)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        
        NSLog(@"First Load");
        
        FVData *obj=[FVData getInstance];
        
        recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
        [recognizer setDelegate:self];
        [recognizer setNumberOfTapsRequired:2];
        [recognizer setNumberOfTouchesRequired:2];
        [self.view addGestureRecognizer:recognizer];
        
        //Set orientation (main view)
        self.customLayer=[CALayer layer];
        self.customLayer.frame=self.view.bounds;
        self.customLayer.contentsGravity=kCAGravityResizeAspectFill;
        
        [self.view.layer addSublayer:self.customLayer];
        
        NSLog(@"Camera Loaded");
        
        //[self.audioController print];
        
        motionManager=[[CMMotionManager alloc]init];
        motionManager.deviceMotionUpdateInterval=1/60;
        
        //if(obj.ShowValues){
            
            self.rollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
            [self.rollLabel setText:@"Roll:"];
            [self.rollLabel setBackgroundColor:[UIColor grayColor]];
            [self.view addSubview:self.rollLabel];
            
            self.pitchLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 20)];
            [self.pitchLabel setText:@"Pitch:"];
            [self.pitchLabel setBackgroundColor:[UIColor grayColor]];
            [self.view addSubview:self.pitchLabel];
            
            self.yawLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 200, 20)];
            [self.yawLabel setText:@"Yaw:"];
            [self.yawLabel setBackgroundColor:[UIColor grayColor]];
            [self.view addSubview:self.yawLabel];
            
            self.colorLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 60, 200, 20)];
            [self.colorLabel setText:@"Color:"];
            [self.colorLabel setBackgroundColor:[UIColor whiteColor]];
            
            self.rLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 200, 20)];
            [self.rLabel setText:@"Red:"];
            [self.rLabel setBackgroundColor:[UIColor redColor]];
            
            self.gLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 20)];
            [self.gLabel setText:@"Green:"];
            [self.gLabel setBackgroundColor:[UIColor greenColor]];
            
            self.bLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, 200, 20)];
            [self.bLabel setText:@"Blue:"];
            [self.bLabel setBackgroundColor:[UIColor blueColor]];
            
            
            //if(obj.ShowColor){
                [self.view addSubview:self.colorLabel];
                [self.view addSubview:self.rLabel];
                [self.view addSubview:self.gLabel];
                [self.view addSubview:self.bLabel];
            //}
        //}
        
        self.rollLabel.alpha = 0;
        self.yawLabel.alpha = 0;
        self.pitchLabel.alpha = 0;
        self.colorLabel.alpha = 0;
        self.rLabel.alpha = 0;
        self.gLabel.alpha = 0;
        self.bLabel.alpha = 0;
        
        time = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(try) userInfo:nil repeats:YES];
        
        circles = [[MyCanvas alloc] initWithFrame:self.view.bounds];
        //if(obj.dot){
            [self.view addSubview:circles];
            circles.opaque = NO;
            [circles setNeedsDisplay];
        circles.alpha = 0;
        //}
        
        //External video setup
        self.externalDisplayHandler=[[ExternalDisplayHandler alloc]init];
        self.externalDisplayHandler.delegate=self;
            
        obj=nil;
        [obj release];
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"Start Everything");
    //..if(![self.session isRunning])
     //   [self.session startRunning];
    
    if(ExternalDisplayHandler.monitorExists){
        NSLog(@"TV is attached");
        [self.externalDisplayHandler.contentView addSubview:self.view];
    }
    else{
        //[self.view addSubview:self.view];
        NSLog(@"TV is not attached");
    }
    
    
    [self setupCapture];
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
    
    FVData *obj=[FVData getInstance];
    if([obj.pd isEqualToString:@"Gyro"] || [obj.pd isEqualToString:@""] || obj.pd.length == 0)
    {
        patch = [PdBase openFile:@"Patch1_PRY.pd" path:[[NSBundle mainBundle] resourcePath]];
    }
    else if([obj.pd isEqualToString:@"Color"])
    {
        patch = [PdBase openFile:@"Patch1_RGB.pd" path:[[NSBundle mainBundle] resourcePath]];
    }
    else if([obj.pd isEqualToString:@"Synth Gyro"])
    {
        patch = [PdBase openFile:@"PRY_Synth.pd" path:[[NSBundle mainBundle] resourcePath]];
    }
    else if([obj.pd isEqualToString:@"Synth Color"])
    {
        patch = [PdBase openFile:@"RGB_Synth.pd" path:[[NSBundle mainBundle] resourcePath]];
    }
    else if([obj.pd isEqualToString:@"Arpeggo Synth Gyro and Color"])
    {
        patch = [PdBase openFile:@"arpeggio_synth_YRP_Color.pd" path:[[NSBundle mainBundle] resourcePath]];
    }
    else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        patch = [PdBase openFile:obj.pd path:path];
    }
    
    if(obj.ShowValues){
        self.rollLabel.alpha = 1;
        self.yawLabel.alpha = 1;
        self.pitchLabel.alpha = 1;
        self.colorLabel.alpha = 1;
        self.rLabel.alpha = 1;
        self.gLabel.alpha = 1;
        self.bLabel.alpha = 1;
    }else{
        self.rollLabel.alpha = 0;
        self.yawLabel.alpha = 0;
        self.pitchLabel.alpha = 0;
        self.colorLabel.alpha = 0;
        self.rLabel.alpha = 0;
        self.gLabel.alpha = 0;
        self.bLabel.alpha = 0;
    }
    NSLog(@"Pd Loaded");

    if(obj.dot){
        circles.alpha = 1;
        [circles setNeedsDisplay];
    }else {
        circles.alpha = 0;
    }
    
    if(!obj.showAlert){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Double Tap with Two Fingers to Exit" message:nil delegate:   self cancelButtonTitle:@"OK" otherButtonTitles:@"Don't Remind Me", nil];
        [alert setTag:100];
        [alert show];
    }else{
    if(!obj.showAlertHeadphones){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please plugin your headphones" message:nil delegate:   self cancelButtonTitle:@"OK" otherButtonTitles:@"Don't Remind Me", nil];
        [alert setTag:200];
        [alert show];
    }
    }
    
    obj=nil;
    [obj release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    FVData *obj=[FVData getInstance];
    if (buttonIndex == [alertView firstOtherButtonIndex] && alertView.tag == 100) {
        FVData *obj=[FVData getInstance];
        [obj NeverShowAlert:YES];
        obj=nil;
        [obj release];
    }
    if(alertView.tag == 100){
        if(!obj.showAlertHeadphones){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please plugin your headphones" message:nil delegate:   self cancelButtonTitle:@"OK" otherButtonTitles:@"Don't Remind Me", nil];
            [alert setTag:200];
            [alert show];
        }
    }
    if (buttonIndex == [alertView firstOtherButtonIndex] && alertView.tag == 200) {
        FVData *obj=[FVData getInstance];
        [obj NeverShowAlertHeadphones:YES];
        obj=nil;
        [obj release];
    }
    obj=nil;
    [obj release];
}

-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"Stop Everything");
    [motionManager stopDeviceMotionUpdates];
    //[self.session stopRunning];
    if(patch){
        [PdBase closeFile:patch];
        patch = nil;
    }
    [self.session stopRunning];
    self.session = nil;
}

-(void)doubleTap{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)try{
    FVData *obj=[FVData getInstance];
    
    CMDeviceMotion *motion=motionManager.deviceMotion;
    CMAttitude *attitude=motion.attitude;
    
    float rollVal=degrees(attitude.roll);
    float pitchVal=degrees(attitude.pitch);
    float yawVal=degrees(attitude.yaw);
    //float testVal=(rollVal+pitchVal+yawVal)/3;
    
    //NSLog(@"%f, %f, %f", rollVal, pitchVal, yawVal);
    
    //[PdBase sendFloat:fabsf(testVal) toReceiver:@"midinote"];
    [PdBase sendFloat:fabsf(rollVal) toReceiver:@"roll"];
    [PdBase sendFloat:fabsf(pitchVal) toReceiver:@"pitch"];
    [PdBase sendFloat:fabsf(yawVal) toReceiver:@"yaw"];
    [PdBase sendFloat:fabsf(red) toReceiver:@"red"];
    [PdBase sendFloat:fabsf(blue) toReceiver:@"blue"];
    [PdBase sendFloat:fabsf(green) toReceiver:@"green"];
    [PdBase sendFloat:fabsf(avg) toReceiver:@"color"];
    [PdBase sendBangToReceiver:@"trigger"];
    
    if(obj.ShowValues){
        NSString *colString=[NSString stringWithFormat:@"color: %0.2f",avg];
        [self.colorLabel setText:colString];
        NSString *rString=[NSString stringWithFormat:@"red: %0.2f",red];
        [self.rLabel setText:rString];
        NSString *bString=[NSString stringWithFormat:@"blue: %0.2f",blue];
        [self.bLabel setText:bString];
        NSString *gString=[NSString stringWithFormat:@"green: %0.2f",green];
        [self.gLabel setText:gString];
        NSString *rollString=[NSString stringWithFormat:@"roll: %0.2f",rollVal];
        [self.rollLabel setText:rollString];
        NSString *pitchString=[NSString stringWithFormat:@"pitch: %0.2f",pitchVal];
        [self.pitchLabel setText:pitchString];
        NSString *yawString=[NSString stringWithFormat:@"yaw: %0.2f",yawVal];
        [self.yawLabel setText:yawString];
    }
    
    //UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if ((obj.orientation == 1 && [obj.useCamera isEqualToString:@"Front Camera"]) ||
        (obj.orientation == 0 && [obj.useCamera isEqualToString:@"Back Camera"]) ||
        (obj.orientation == 0 && obj.useCamera.length == 0)
        )
    {
        self.customLayer.transform=CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 1);
    }
    if ((obj.orientation == 0 && [obj.useCamera isEqualToString:@"Front Camera"]) ||
        (obj.orientation == 1 && [obj.useCamera isEqualToString:@"Back Camera"])||
        (obj.orientation == 1 && obj.useCamera.length == 0)
        )
    {
       //flip video
        self.customLayer.transform=CATransform3DRotate(CATransform3DIdentity, M_PI/1.0f, 0, 0, 1);
    }
    
    if([obj.useCamera isEqualToString:@"Front Camera"]){
        self.customLayer.transform = CATransform3DMakeScale(1, -1, 1);
    }
    
    motion = nil;
    [motion release];
    attitude = nil;
    [attitude release];
    obj=nil;
    [obj release];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
   // @autoreleasepool {
        
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
    CIImage *filteredImage=nil;
    CIFilter *sepFilter;
    CIContext *context=[CIContext contextWithOptions:nil];

    FVData *obj=[FVData getInstance];
    CGImageRef cgimg = [context createCGImage:beginImage fromRect:[beginImage extent]];
    
    
    //cgimg=[context createCGImage:beginImage fromRect:[beginImage extent]];
    if(obj.posterize){
        sepFilter=[CIFilter filterWithName:@"CIColorPosterize" keysAndValues:
                   kCIInputImageKey, beginImage,
                   @"inputLevels", [NSNumber numberWithFloat:6.0], nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
        beginImage = [CIImage imageWithCGImage:cgimg];
    }
    if(obj.sepia){
        sepFilter=[CIFilter filterWithName:@"CISepiaTone" keysAndValues:
                   kCIInputImageKey, beginImage,
                   @"inputIntensity", [NSNumber numberWithFloat:1.0], nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
        beginImage = [CIImage imageWithCGImage:cgimg];
    }
    //Color inverter filter
    if(obj.invert){
        sepFilter=[CIFilter filterWithName:@"CIColorInvert" keysAndValues:
                   kCIInputImageKey, beginImage, nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
        beginImage = [CIImage imageWithCGImage:cgimg];
    }
    //Lines on the screen
    if(obj.line){
        sepFilter=[CIFilter filterWithName:@"CILineScreen" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:200 Y:200], @"inputAngle", [NSNumber numberWithFloat:90], @"inputWidth", [NSNumber numberWithFloat:100], nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
        beginImage = [CIImage imageWithCGImage:cgimg];
    }
    //Pixel filter
    
    //NSLog(@"pixl %i", obj.pixl);
    if(obj.pixl==1){
        sepFilter=[CIFilter filterWithName:@"CIPixellate" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:100 Y:100], @"inputScale", [NSNumber numberWithInt:obj.pixlSize] ,nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
        beginImage = [CIImage imageWithCGImage:cgimg];
    }
    //NSLog(@"dot %i", obj.dot);
    if(obj.dot==1){
        //DotScreen filter (change width for size of dots)
        /*
         CIFilter *dotScreenFilter=[CIFilter filterWithName:@"CIDotScreen" keysAndValues:kCIInputImageKey, beginImage, @"inputCenter", [CIVector vectorWithX:200 Y:200], @"inputAngle", [NSNumber numberWithFloat:obj.pixlSize/2], @"inputWidth", [NSNumber numberWithFloat:obj.pixlSize],nil];
         filteredImage=[dotScreenFilter valueForKey:@"outputImage"];
         cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
         beginImage = [CIImage imageWithCGImage:cgimg];
         */
        
        //UIImage *image=[[UIImage alloc] initWithCGImage:newImage];
        //CIVector *vector = [CIVector vectorWithX:self.view.bounds.size.width /2.0f Y:self.view.bounds.size.height /2.0f];
        sepFilter=[CIFilter filterWithName:@"CIPixellate" keysAndValues:
                   kCIInputImageKey, beginImage,
                   //@"inputCenter", vector,
                   @"inputScale", [NSNumber numberWithFloat:obj.pixlSize/2] ,nil];
        filteredImage=[sepFilter valueForKey:@"outputImage"];
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:filteredImage fromRect:[filteredImage extent]];
        beginImage = [CIImage imageWithCGImage:cgimg];
        //NSLog(@"%f,%f", beginImage.extent.size.width, beginImage.extent.size.height);
        //[circles setNeedsDisplay];
        
    }
    
    
    if (filteredImage!=nil) {
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:beginImage fromRect:[beginImage extent]];
        
    }else{
        CGImageRelease(cgimg);
        cgimg=[context createCGImage:beginImage fromRect:[beginImage extent]];
    }
    
    [self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject:(id)cgimg waitUntilDone:YES];
    
    UIColor *col = [[self avgColor:cgimg] retain];
    //NSLog(@"col: %@", col );
    
    CGColorRef colorRef = [col CGColor];
    
    int _countComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (_countComponents == 4) {
        const CGFloat *_components = CGColorGetComponents(colorRef);
        red     = _components[0];
        green = _components[1];
        blue   = _components[2];
        
        avg = (red + blue + green)/3.0;
        
        //NSLog(@"%f",avg);
        
    }
    [col release];
    
    CGImageRelease(newImage);
    CGImageRelease(cgimg);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    [pool drain];
    obj=nil;
    [obj release];
    return;
    
    
    
    
    
    //UIImage *image=[UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];

    //if(obj.ShowValues && obj.ShowColor){

    //- (UIColor *)averageColor:(CGImageRef)cgimg
    
    
}

-(UIColor *)getRGBAsFromImage:(CGImageRef)image atX:(int)xx andY:(int)yy
{
    /*
    if(CGSizeEqualToSize(image.size, CGSizeZero)){
        return [UIColor blueColor];
    }
    */
    
    //return [UIColor blueColor];
    
    //CGImageRef image = CIImage;
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    
    // Setup 1x1 pixel context to draw into
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rawData[4];
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the image
    CGContextDrawImage(context,
                       CGRectMake(xx, yy, width, height),
                       image);
    
    // Done
    CGContextRelease(context);
    
    // Get the pixel information
    unsigned char cred   = rawData[0];
    unsigned char cgreen = rawData[1];
    unsigned char cblue  = rawData[2];
    unsigned char calpha = rawData[3];
        
    UIColor *acolor = [UIColor colorWithRed:cred green:cgreen blue:cblue alpha:calpha];
    
    return acolor;
}

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
    if(self.session == nil)
        self.session=[[AVCaptureSession alloc]init];
    
    //Add input and output
    [self.session addInput:captureInput];
    [self.session addOutput:captureOutput];
    
    //Quality
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    
    [self.session startRunning];
}
- (AVCaptureDevice *)frontCamera {
    FVData *obj=[FVData getInstance];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([[device localizedName] isEqualToString:obj.useCamera]) {
            
            obj=nil;
            [obj release];
            return device;
        }
    }
    if(obj.useCamera.length == 0){
        
        obj=nil;
        [obj release];
        return devices[0];
    }
    
    
    obj=nil;
    [obj release];
    devices=nil;
    [devices release];
    return nil;
}


- (UIColor *)avgColor:(CGImageRef)thiscgimg
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), thiscgimg);
    //CGColorSpaceRelease(colorSpace);
    //CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

/*
-(NSUInteger)supportedInterfaceOrientations
{
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskLandscapeLeft;
}

*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidUnload{
    NSLog(@"unload");
    self.imageView=nil;
    self.customLayer=nil;
    self.prevLayer=nil;
    self.yawLabel =nil;
    self.pitchLabel =nil;
    self.colorLabel =nil;
    self.rLabel =nil;
    self.gLabel =nil;
    self.bLabel =nil;
    recognizer=nil;
    circles = nil;
    if(externalDisplayHandler)
    {
        [externalDisplayHandler denotify]; // removeconnect/disconnect notifications
        externalDisplayHandler = nil;
    }
    
}
-(void)dealloc{
    NSLog(@"dealloc");
    [self.rollLabel release];
    [self.yawLabel release];
    [self.pitchLabel release];
    [self.colorLabel release];
    [self.rLabel release];
    [self.gLabel release];
    [self.bLabel release];
    [recognizer release];
    [circles release];
    [super dealloc];
}

#pragma mark - TV Delegate methods
-(void)TVDidDisconnectNotification
{
    NSLog(@"TV was Disconnected");
    
    
}
-(void)refreshText
{
    /*refresh TV
    UILabel* sizeLabel = (UILabel*)[self.yellowBorder viewWithTag:1];
    if(sizeLabel)
        sizeLabel.text = [NSString stringWithFormat:@"TV frame:%@, ContentInsets:%@", NSStringFromCGSize(self.externalDisplayHandler.contentView.frame.size),NSStringFromUIEdgeInsets(self.externalDisplayHandler.contentInset)];
    
    self.yellowBorder.frame = self.externalDisplayHandler.contentView.frame;
     */
    
}
-(void)TVDidConnectNotification:(NSNotification *)notification
{
    NSLog(@"TV was Connected");
    
    
    
    if(self.externalDisplayHandler)
    {
        NSLog(@"external screen of size:%@ ",NSStringFromCGRect(self.externalDisplayHandler.contentView.frame));
        
        //[self.externalDisplayHandler.contentView addSubview:self.redSquareTV];
        //[self.externalDisplayHandler.contentView insertSubview:self.yellowBorder belowSubview:self.redSquareTV];
        
        
        [self refreshText];
        
        
    }
}

@end
