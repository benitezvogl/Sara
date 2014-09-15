//
//  AppSettingsViewController.h
//  SARA
//
//  Created by Chris Yanc on 3/18/14.
//
//

#import <UIKit/UIKit.h>

@interface AppSettingsViewController : UIViewController{
    UISegmentedControl *PickCamera;
    IBOutlet UISwitch *ExternalDeviceSwitch;
    IBOutlet UISwitch *FlipHorizontalSwitch;
    IBOutlet UISwitch *FlipVerticalSwitch;
    IBOutlet UISwitch *ShowValuesSwitch;
    IBOutlet UISwitch *FlipOrientationSwitch;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *PickCamera;

@end
