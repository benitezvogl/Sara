//
//  MenusViewController.m
//  Menu Test
//
//  Created by collider on 8/31/13.
//  Copyright (c) 2013 collider. All rights reserved.
//

#import "MenusViewController.h"

@interface MenusViewController ()

@end

@implementation MenusViewController
@synthesize burgerButton,gearButton,eyeButton;
@synthesize filterNone,filterSepia,filterInvert,filterSuper,filterCrystal;
@synthesize filterLabel,infoLabel;
@synthesize testImages,bottomBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    filterNone.hidden=true;
    filterSepia.hidden=true;
    filterInvert.hidden=true;
    filterSuper.hidden=true;
    filterCrystal.hidden=true;
    infoLabel.hidden=true;
    
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
    [recognizer setDelegate:self];
    [recognizer setNumberOfTapsRequired:2];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)openFilterList:(id)sender{
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    filterInvert.hidden=!filterInvert.hidden;
    filterSuper.hidden=!filterSuper.hidden;
    filterCrystal.hidden=!filterCrystal.hidden;
    testImages.image=[UIImage imageNamed:@"eye.png"];
}

-(IBAction)selectFilter:(id)sender{
    filterLabel.text=[sender currentTitle];
    if(infoLabel.hidden!=true){
        infoLabel.hidden=!infoLabel.hidden;
        filterLabel.hidden=!filterLabel.hidden;
    }
    filterNone.hidden=!filterNone.hidden;
    filterSepia.hidden=!filterSepia.hidden;
    filterInvert.hidden=!filterInvert.hidden;
    filterSuper.hidden=!filterSuper.hidden;
    filterCrystal.hidden=!filterCrystal.hidden;
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    
}

-(IBAction)showImage:(id)sender{
    if([[sender currentTitle] isEqualToString:@"burger"]){
        testImages.image=[UIImage imageNamed:@"burger.png"];
    }
}

-(IBAction)showGroupInformation:(id)sender{
    infoLabel.hidden=!infoLabel.hidden;
    filterLabel.hidden=!filterLabel.hidden;
    if(filterNone.hidden!=true){
        filterNone.hidden=!filterNone.hidden;
        filterSepia.hidden=!filterSepia.hidden;
        filterInvert.hidden=!filterInvert.hidden;
        filterSuper.hidden=!filterSuper.hidden;
        filterCrystal.hidden=!filterCrystal.hidden;
    }
    testImages.image=[UIImage imageNamed:@"gear.png"];
}

-(void)doubleTap{
    if(infoLabel.hidden!=true){
        infoLabel.hidden=!infoLabel.hidden;
    }
    gearButton.hidden=!gearButton.hidden;
    eyeButton.hidden=!eyeButton.hidden;
    burgerButton.hidden=!burgerButton.hidden;
    bottomBar.hidden=!bottomBar.hidden;
    
}

@end
