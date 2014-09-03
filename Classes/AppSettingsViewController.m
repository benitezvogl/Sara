//
//  AppSettingsViewController.m
//  SARA
//
//  Created by Chris Yanc on 3/18/14.
//
//

#import "AppSettingsViewController.h"
#import "FVData.h"
#import <AVFoundation/AVFoundation.h>

@interface AppSettingsViewController ()

@end

@implementation AppSettingsViewController
@synthesize PickCamera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FVData *obj=[FVData getInstance];
    
    [PickCamera removeAllSegments];
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    int index = 0;
    for (AVCaptureDevice *device in devices) {
        //if ([device position] == AVCaptureDevicePositionFront) {
         //   return device;
        //}
        NSLog(@"%@", [device localizedName]);
        NSLog(@"%@", [device description]);
        NSLog(@"%@", [device uniqueID]);
        NSLog(@"%lu", (unsigned long)[device retainCount]);
        NSLog(@"-------------");
        [PickCamera insertSegmentWithTitle:[device localizedName] atIndex:index animated:NO];
        if([obj.useCamera isEqualToString:[device localizedName]])
            PickCamera.selectedSegmentIndex = index;
        index++;
    }
    if(obj.useCamera.length == 0)
        PickCamera.selectedSegmentIndex = 0;
    
    [PickCamera updateConstraintsIfNeeded];
    
    if(obj.orientation == 1)
        FlipOrientationSwitch.on = YES;
    else
        FlipOrientationSwitch.on = NO;
    
    if(obj.ShowValues)
        ShowValuesSwitch.on = YES;
    else
        ShowValuesSwitch.on = NO;
    
    
}

- (IBAction)CameraChange:(id)sender {
    FVData *obj=[FVData getInstance];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *val = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    NSLog(@"%@",val);
    [obj UseCamera: val];
}

- (IBAction)ShowValues:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    bool val;
    if(sender.on)
        val = YES;
    else
        val = NO;
    [obj ShowPdValues:val];
}
- (IBAction)FlipOrientation:(UISwitch* )sender {
    FVData *obj=[FVData getInstance];
    int val;
    
    if(sender.on)
        val = 1;
    else
        val = 0;
    [obj Orientation:val];
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [PickCamera release];
    [FlipHorizontalSwitch release];
    [ShowValuesSwitch release];
    [FlipOrientationSwitch release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPickCamera:nil];
    [FlipHorizontalSwitch release];
    FlipHorizontalSwitch = nil;
    [ShowValuesSwitch release];
    ShowValuesSwitch = nil;
    [FlipOrientationSwitch release];
    FlipOrientationSwitch = nil;
    [super viewDidUnload];
}
@end
