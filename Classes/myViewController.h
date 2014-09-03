//
//  myViewController.h
//  iosNativeExample
//
//  Created by Chris Yanc on 3/18/14.
//
//
#import <UIKit/UIKit.h>

#import "PdTest01ViewController.h"
#import "VideoSettingsViewController.h"
#import "PdSettingsViewController.h"
#import "AppSettingsViewController.h"
#import "AboutViewController.h"

@interface myViewController : UIViewController{
    PdTest01ViewController *app;
    PdSettingsViewController *pd;
    VideoSettingsViewController *vid;
    AppSettingsViewController *appSet;
    AboutViewController *about;
}

@property(strong, nonatomic)PdTest01ViewController *app;
@property(strong, nonatomic)PdSettingsViewController *pd;
@property(strong, nonatomic)VideoSettingsViewController *vid;
@property(strong, nonatomic)AppSettingsViewController *appSet;
@property(strong, nonatomic)AboutViewController *about;

- (void)Return;


@end
