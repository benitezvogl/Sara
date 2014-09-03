//
//  myViewController.m
//  iosNativeExample
//
//  Created by Chris Yanc on 3/18/14.
//
//

#import "myViewController.h"
#import "FVData.h"

#import <AVFoundation/AVFoundation.h>

@interface myViewController ()

@end

@implementation myViewController

@synthesize pd;
@synthesize app;
@synthesize appSet;
@synthesize vid;
@synthesize about;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //FVData *obj=[FVData getInstance];
        NSLog(@"Using myViewController");
        
        FVData *obj=[FVData getInstance];
        if(obj.useCamera.length == 0){
            NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            [obj UseCamera: [devices[0] localizedName]];
        }
        NSLog(@"%@", obj.useCamera);
        
        pd = nil;
        app = nil;
        appSet = nil;
        vid = nil;
        about = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
}


-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{    
    self.navigationController.navigationBarHidden = YES;
}

- (void)Return {
    [self.navigationController.navigationController popViewControllerAnimated:NO];
}

- (IBAction)Play:(id)sender {
    
    if(app == nil){
        app = [[PdTest01ViewController alloc] initWithNibName:@"PdTest01ViewController" bundle:nil];
    }
    [self.navigationController pushViewController:app animated:YES];
    self.navigationController.navigationBarHidden = YES;
    //self.navigationController.navigationBar.topItem.title = @"SquareApp";

}

- (IBAction)PdSettings:(id)sender {
    if(pd == nil){
        pd = [[PdSettingsViewController alloc] initWithNibName:@"PdSettingsViewController" bundle:nil];
    }
    [self.navigationController pushViewController:pd animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.topItem.title = @"Pd Settings";
    
}


- (IBAction)VideoSettings:(id)sender {
    if(vid == nil){
        vid = [[VideoSettingsViewController alloc] initWithNibName:@"VideoSettingsViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:vid animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.topItem.title = @"Video Filter Settings";
}




- (IBAction)AppSettings:(id)sender {
    if(appSet == nil){
        appSet= [[AppSettingsViewController alloc] initWithNibName:@"AppSettingsViewController" bundle:nil];
    }
    [self.navigationController pushViewController:appSet animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.topItem.title = @"App Settings";

}


- (IBAction)AboutSARA:(id)sender {
    if(about == nil){
        about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] ;
    }
    [self.navigationController pushViewController:about animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.topItem.title = @"About SARA";
}

-(NSUInteger)supportedInterfaceOrientations
{
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskLandscapeLeft;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
