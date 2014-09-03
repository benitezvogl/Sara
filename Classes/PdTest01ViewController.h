#import <UIKit/UIKit.h>
#import "PdBase.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <CoreMotion/CoreMotion.h>
#import "MyCanvas.h"
#import "ExternalDisplayHandler.h"

@interface PdTest01ViewController : UIViewController<ExternalDisplayHandlerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate> {
    
    ExternalDisplayHandler *externalDisplayHandler;
    CMMotionManager *motionManager;
    void *patch;
    NSTimer *time;
    
    //Views
    CALayer *_customLayer;
    AVCaptureSession *_session;
    UIImageView *_imageView;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    CGImageRef cgimg;
    UITapGestureRecognizer *recognizer;
    
    MyCanvas *circles;
    CGFloat avg;
    
    float red;
    float green;
    float blue;
}

@property(nonatomic,retain)IBOutlet UIImageView *cameraView;
@property(nonatomic,retain)IBOutlet UIImageView *testView;
@property(strong, nonatomic)IBOutlet UIView *circles;

//Views
@property(nonatomic,retain)CALayer *customLayer;
@property(nonatomic,retain)AVCaptureSession *session;
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)AVCaptureVideoPreviewLayer *prevLayer;

//Labels
@property(nonatomic,retain)IBOutlet UILabel *yawLabel;
@property(nonatomic,retain)IBOutlet UILabel *rollLabel;
@property(nonatomic,retain)IBOutlet UILabel *pitchLabel;
@property(nonatomic,retain)IBOutlet UILabel *colorLabel;
@property(nonatomic,retain)IBOutlet UILabel *rLabel;
@property(nonatomic,retain)IBOutlet UILabel *gLabel;
@property(nonatomic,retain)IBOutlet UILabel *bLabel;

@property(nonatomic,retain)ExternalDisplayHandler *externalDisplayHandler;

-(UIColor *)avgColor:(CGImageRef)cgimg;

@end

