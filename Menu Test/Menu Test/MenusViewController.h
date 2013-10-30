//
//  MenusViewController.h
//  Menu Test
//
//  Created by collider on 8/31/13.
//  Copyright (c) 2013 collider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenusViewController : UIViewController <UIGestureRecognizerDelegate>{
    UIButton *burgerButton;
    UIButton *gearButton;
    UIButton *eyeButton;
    
    UIButton *filterNone;
    UIButton *filterSepia;
    UIButton *filterInvert;
    UIButton *filterSuper;
    UIButton *filterCrystal;
    UILabel *filterLabel;
    UILabel *infoLabel;
    
    UIImageView *testImages;
    UIImageView *bottomBar;
}

@property(nonatomic,retain)IBOutlet UIButton *burgerButton;
@property(nonatomic,retain)IBOutlet UIButton *gearButton;
@property(nonatomic,retain)IBOutlet UIButton *eyeButton;

@property(nonatomic,retain)IBOutlet UIButton *filterNone;
@property(nonatomic,retain)IBOutlet UIButton *filterSepia;
@property(nonatomic,retain)IBOutlet UIButton *filterInvert;
@property(nonatomic,retain)IBOutlet UIButton *filterSuper;
@property(nonatomic,retain)IBOutlet UIButton *filterCrystal;

@property(nonatomic,retain)IBOutlet UILabel *filterLabel;
@property(nonatomic,retain)IBOutlet UILabel *infoLabel;

@property(nonatomic,retain)IBOutlet UIImageView *testImages;
@property(nonatomic,retain)IBOutlet UIImageView *bottomBar;

//Menu functions
-(IBAction)openFilterList:(id)sender;
-(IBAction)selectFilter:(id)sender;

-(IBAction)showImage:(id)sender;

-(IBAction)showGroupInformation:(id)sender;

@end
