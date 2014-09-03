//
//  VideoSettingsViewController.h
//  SARA
//
//  Created by Chris Yanc on 3/27/14.
//
//

#import <UIKit/UIKit.h>

@interface VideoSettingsViewController : UIViewController{
    
    IBOutlet UISlider *PixelAmtSlider;
}
//@property (retain, nonatomic) IBOutlet UISwitch *SendColorsPdSwitch;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UISwitch *InvertSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *SepiaSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *LinesSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *PosterSwitch;
@property (retain, nonatomic) IBOutlet UISegmentedControl *pixelateSegment;
@property (retain, nonatomic) IBOutlet UISlider *PixelAmtSlider;


@end
