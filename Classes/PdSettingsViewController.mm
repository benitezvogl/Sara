//
//  PdSettingsViewController.m
//  SARA
//
//  Created by Chris Yanc on 3/20/14.
//
//

#import "PdSettingsViewController.h"
#import "PdTableListViewController.h"
#import "FVData.h"

@interface PdSettingsViewController ()

@end

@implementation PdSettingsViewController

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
    
    //self.SampleRateArray = [[NSArray alloc] initWithObjects:@48000,@44100,@32000,@22050,@16000,@11025,@8000, nil];
    //self.BufferSizeArray = [[NSArray alloc] initWithObjects: @64,@32,@16,@8,@4, nil];
    
}

- (void) viewWillAppear:(BOOL)animated{
    FVData *obj=[FVData getInstance];
    NSString *str = obj.pd;
    
    if([obj.pd class] == [NSNull class] || [str isEqualToString:@""] || str.length == 0 || [str isEqualToString:@"Gyro"]){
        NSLog(@"is nil");
        _PDLabel.text = @"Gyro";
    }
    else if([str isEqualToString:@"Color"])
    {
        _PDLabel.text = @"Color";
    }
    else if([str isEqualToString:@"Synth Gyro"])
    {
        _PDLabel.text = @"Synth Gyro";
    }
    else if([str isEqualToString:@"Synth Color"])
    {
        _PDLabel.text = @"Synth Color";
    }
    else if([str isEqualToString:@"Arpeggo Synth Gyro and Color"])
    {
        _PDLabel.text = @"Arpeggo Synth Gyro and Color";
    }
    else
    {
        _PDLabel.text = str;
    }
    
    /*
    for(int i = 0; i < self.SampleRateArray.count; i++){
        //cout<<[[self.SampleRateArray objectAtIndex:i]intValue]<< " : " << obj.sampleRate << endl;
        if([[self.SampleRateArray objectAtIndex:i]intValue] == obj.sampleRate)
            [self.SampleRatePicker selectRow:i inComponent:0 animated:NO];
    }
    for(int i = 0; i < self.BufferSizeArray.count; i++){
        if([[self.BufferSizeArray objectAtIndex:i]intValue] == obj.bufferSize)
            [self.SampleRatePicker selectRow:i inComponent:1 animated:NO];
    }
    */
    
    //self.scrollView.pagingEnabled = false;
    //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*1.25);
}

- (IBAction)ToPdTable:(id)sender {
    PdTableListViewController *viewController= [[[PdTableListViewController alloc] initWithNibName:@"PdTableListViewController" bundle:nil] autorelease];
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.topItem.title = @"Select Pd File";
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 1){
        return [self.BufferSizeArray count];
    }
    return [self.SampleRateArray count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 1){
        return [[self.BufferSizeArray objectAtIndex:row] stringValue];
    }
    return [[self.SampleRateArray objectAtIndex:row] stringValue];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    FVData *obj=[FVData getInstance];
    /*
    if(component == 1){
        NSLog(@"BufferSizeArray %d", row);
        NSLog(@"%d",[[self.BufferSizeArray objectAtIndex:row] intValue]);
        int val = [[self.BufferSizeArray objectAtIndex:row] intValue];
        [obj BufferSize:val];
    }
    else{
        NSLog(@"SampleRateArray %d", row);
        NSLog(@"%d",[[self.SampleRateArray objectAtIndex:row] intValue]);
        int val = [[self.SampleRateArray objectAtIndex:row] intValue];
        [obj SampleRate:val];
    }
    */
}


-(BOOL)shouldAutorotate
{
    //return [[self.navigationController navigationController] shouldAutorotate];
    return NO;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    // Return YES for supported orientations
    if(toInterfaceOrientation == UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        return YES;
    else
        return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return UIInterfaceOrientationMaskLandscapeRight;
    else
        return UIInterfaceOrientationMaskLandscapeLeft;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    FVData *obj=[FVData getInstance];
    if(obj.orientation == 0)
        return UIInterfaceOrientationLandscapeRight;
    else
        return UIInterfaceOrientationLandscapeLeft;
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
    [_scrollView release];
    [_PDLabel release];
    [_SelectNewBtn release];
   // [_SampleRatePicker release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPDLabel:nil];
    [self setSelectNewBtn:nil];
  //  [self setSampleRatePicker:nil];
    [super viewDidUnload];
}
@end
