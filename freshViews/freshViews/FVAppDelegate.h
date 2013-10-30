//
//  FVAppDelegate.h
//  freshViews
//
//  Created by collider on 2/22/13.
//  Copyright (c) 2013 collider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class FVViewController;

@interface FVAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FVViewController *viewController;

@property(strong,nonatomic,readonly)PdAudioController *audioController;

@end
