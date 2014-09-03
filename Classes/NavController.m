//
//  NavController.m
//  SARA
//
//  Created by Chris Yanc on 4/26/14.
//
//

#import "NavController.h"
#import "FVData.h"

@interface NavController ()

@end

@implementation NavController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"supportedInterfaceOrientations NavController");
    
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
