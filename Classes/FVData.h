//
//  FVData.h
//  freshViews
//
//  Created by Chris Yanc on 1/27/14.
//  Copyright (c) 2014 collider. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FVData : NSObject {
    NSUserDefaults *settings;
    
    bool ShowValues;
    bool ShowColor;
    
    NSString *pd;
    bool sepia;
    bool line;
    bool invert;
    bool posterize;
    
    bool pixl;
    bool dot;
    int pixlSize;
    
    int orientation;
    NSString *useCamera;
    
    bool showAlert;
    bool showAlertHeadphones;
}
@property(readwrite, assign)NSUserDefaults *settings;

@property(readwrite, assign)NSString *pd;

@property(readwrite)bool ShowValues;
@property(readwrite)bool ShowColor;
@property(readwrite)bool showAlert;
@property(readwrite)bool showAlertHeadphones;

@property(readwrite)bool posterize;
@property(readwrite)bool sepia;
@property(readwrite)bool line;
@property(readwrite)bool invert;

@property(readwrite)bool pixl;
@property(readwrite)bool dot;
@property(readwrite)int pixlSize;

@property(readwrite)int orientation;
@property(readwrite, assign)NSString *useCamera;

+(FVData*)getInstance;

-(void)PDFile:(NSString*)val;
-(void)UseCamera:(NSString*)val;
-(void)Orientation:(int)val;

-(void)ShowPdValues:(bool)val;
-(void)SendColorValues:(bool)val;
-(void)NeverShowAlert:(bool)val;
-(void)NeverShowAlertHeadphones:(bool)val;

-(void)SetPixelate:(bool)val;
-(void)SetDots:(bool)val;
-(void)SetPixelAmt:(int)val;


-(void)Invert:(bool)val;
-(void)Sepia:(bool)val;
-(void)Line:(bool)val;
-(void)Posterize:(bool)val;
/*
-(void)Blur:(bool)val;
-(void)BlurLevel:(int)val;
*/

@end
