#import "PdTest01AppDelegate.h"
#import "myViewController.h"
#import "NavController.h"
#import "FVData.h"

@interface PdTest01AppDelegate()
@end

@implementation PdTest01AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	//self.window.rootViewController = [[[PdTest01ViewController alloc] init] autorelease];
    
    self.audioController = [[[PdAudioController alloc] init] autorelease];
    [self.audioController configurePlaybackWithSampleRate:44100 numberChannels:2 inputEnabled:YES mixingEnabled:NO];
    [self.audioController setActive:YES];
    
    self.navigationController = [[[UINavigationController alloc] initWithNibName:@"NavController" bundle:nil] autorelease];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [window setRootViewController:self.navigationController];
    
    [self.navigationController pushViewController:[[[myViewController alloc] init] autorelease] animated:NO];
    self.navigationController.navigationBarHidden = YES;
    
    [window setBackgroundColor:[UIColor blackColor]];
    [window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
    else
        return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft);
    
    return NO;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)dealloc {
	self.window = nil;
    [super dealloc];
}

@end
