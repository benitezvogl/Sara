//
//  VideoSettingsViewController.m
//  SARA
//
//  Created by Chris Yanc on 3/27/14.
//
//

#import "VideoSettingsViewController.h"
#import "FVData.h"

@interface VideoSettingsViewController ()

@end

@implementation VideoSettingsViewController
@synthesize pixelateSegment;
@synthesize PixelAmtSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)PixelateChange:(UISegmentedControl *)sender {
    FVData *obj=[FVData getInstance];
    
    if([sender selectedSegmentIndex] == 0){
        [obj SetPixelate:NO];
        [obj SetDots:NO];
        
    }else if ([sender selectedSegmentIndex] == 1){
        [obj SetPixelate:YES];
        [obj SetDots:NO];
        //[obj SetPixelAmt:self.PixelAmtSlider.value];
        
    }else {
        [obj SetPixelate:NO];
        [obj SetDots:YES];
        //[obj SetPixelAmt:self.PixelAmtSlider.value];
        
    }
    
    obj=nil;
    [obj release];
}
/*
- (IBAction)ChangeGhostLevel:(id)sender {
    FVData *obj=[FVData getInstance];
    [obj BlurLevel:255-(int)self.GhostingSlider.value];
}
*/

- (IBAction)ChangeValue:(id)sender {
    FVData *obj=[FVData getInstance];
    [obj SetPixelAmt:(int)self.PixelAmtSlider.value];
    obj=nil;
    [obj release];
}

- (IBAction)SwitchPoster:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    int val;
    sender.on ? val = 1 : val = 0;
    [obj Posterize:val];
    obj=nil;
    [obj release];
}


- (IBAction)SwitchColorSend:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    int val;
    sender.on ? val = 1 : val = 0;
    [obj SendColorValues:val];
    obj=nil;
    [obj release];
}
/*
- (IBAction)SwitchGhosting:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    int val;
    sender.on ? val = 1 : val = 0;
    [obj Blur:val];
 }
 */
- (IBAction)SwitchInvert:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    bool val;
    sender.on ? val = YES : val = NO;
    [obj Invert:val];
    obj=nil;
    [obj release];
}
- (IBAction)SwitchSepia:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    bool val;
    sender.on ? val = YES : val = NO;
    [obj Sepia:val];
    obj=nil;
    [obj release];
    
}
- (IBAction)SwitchLines:(UISwitch *)sender {
    FVData *obj=[FVData getInstance];
    bool val;
    sender.on ? val = YES : val = NO;
    [obj Line:val];
    obj=nil;
    [obj release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    FVData *obj=[FVData getInstance];
    
    obj.invert ? self.InvertSwitch.on = YES : self.InvertSwitch.on = NO;
    obj.sepia ? self.SepiaSwitch.on = YES : self.SepiaSwitch.on = NO;
    obj.line ? self.LinesSwitch.on = YES : self.LinesSwitch.on = NO;
    obj.posterize ? self.PosterSwitch.on = YES : self.PosterSwitch.on = NO;
    
    //obj.blur == 1 ? self.GhostingBtn.on = YES : self.GhostingBtn.on = NO;
    //obj.ShowColor == YES ? self.SendColorsPdSwitch.on = YES : self.SendColorsPdSwitch.on = NO;
    
    if(obj.pixl == NO && obj.dot == NO)
        [self.pixelateSegment setSelectedSegmentIndex:0];
    if(obj.pixl)
        [self.pixelateSegment setSelectedSegmentIndex:1];
    if(obj.dot)
        [self.pixelateSegment setSelectedSegmentIndex:2];
    
   // float num = obj.pixlSize;
    //NSLog(@"pixlSize: %f", num);
    self.PixelAmtSlider.value = obj.pixlSize;
    
    //self.GhostingSlider.value = 255-(float)obj.blurLevel;
    /*
    for(int i = 0; i < self.GhostLvlArray.count; i++){
        if([[self.GhostLvlArray objectAtIndex:i]intValue] == obj.blurLevel)
            [self.GhostingPicker selectRow:i inComponent:0 animated:NO];
    }
     */
    
    self.scrollView.pagingEnabled = false;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.25);
    obj=nil;
    [obj release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_InvertSwitch release];
    [_scrollView release];
    //[_SendColorsPdSwitch release];
    [pixelateSegment release];
    [PixelAmtSlider release];
    [_SepiaSwitch release];
    [_LinesSwitch release];
    [_PosterSwitch release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setInvertSwitch:nil];
    [self setScrollView:nil];
    //[self setSendColorsPdSwitch:nil];
    [pixelateSegment release];
    pixelateSegment = nil;
    [PixelAmtSlider release];
    PixelAmtSlider = nil;
    [super viewDidUnload];
}
@end
