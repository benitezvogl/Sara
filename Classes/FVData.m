//
//  FVData.m
//  freshViews
//
//  Created by Chris Yanc on 1/27/14.
//  Copyright (c) 2014 collider. All rights reserved.
//

#import "FVData.h"

@implementation FVData

@synthesize settings;

@synthesize pd;
@synthesize sepia;
@synthesize line;
@synthesize invert, posterize;
@synthesize pixl, dot;
@synthesize pixlSize;
@synthesize orientation;
@synthesize ShowValues, ShowColor, showAlert, showAlertHeadphones;
@synthesize useCamera;
static FVData *instance =nil;

+(FVData *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [FVData new];
            
            //instance.path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
            //instance.settings = [[NSMutableDictionary alloc] initWithContentsOfFile:instance.path];
            
            instance.settings = [NSUserDefaults standardUserDefaults];
            
            NSLog(@"ShowData: %@", [instance.settings objectForKey:@"ShowValues"]);
            
            instance.sepia  = [[instance.settings objectForKey:@"Sepia"] boolValue];
            instance.line   = [[instance.settings objectForKey:@"Line"] boolValue];
            instance.invert = [[instance.settings objectForKey:@"Invert"] boolValue];
            
            instance.posterize = [[instance.settings objectForKey:@"Posterize"] boolValue];
            
            instance.pixl       = [[instance.settings objectForKey:@"SquarePixels"] boolValue];
            NSLog(@"SquarePixels: %d", instance.pixl);
            
            instance.dot        = [[instance.settings objectForKey:@"RoundPixels"] boolValue];
            NSLog(@"RoundPixels: %d", instance.dot);
            
            instance.pixlSize   = [[instance.settings objectForKey:@"PixelSize"] intValue];
            NSLog(@"pixlSize: %i", instance.pixlSize);
            if(instance.pixlSize == 0){
                instance.pixlSize = 5;
            }
            
            instance.pd = [instance.settings stringForKey:@"PdFile"];
            NSLog(@"PdFile: %@", instance.pd);
            
            instance.orientation = [[instance.settings objectForKey:@"Orientation"] intValue];
            NSLog(@"Orientation: %i", instance.orientation);
            
            instance.ShowValues = [[instance.settings objectForKey:@"ShowValues"] boolValue];
            instance.ShowColor = [[instance.settings objectForKey:@"ShowColor"] boolValue];
            
            instance.useCamera = [instance.settings stringForKey:@"UseCamera"];
            NSLog(@"UseCamera: %@", instance.useCamera);
            
            instance.showAlert = [[instance.settings objectForKey:@"ShowAlert"] boolValue];
            instance.showAlertHeadphones = [[instance.settings objectForKey:@"ShowAlertHeadphones"] boolValue];
         }
    }
    return instance;
}

-(void)SetSettingsBoolValue:(NSString*)thisKey value:(bool)val {
    NSLog(@"%@: %d", thisKey, val);
    [settings setBool:val forKey:thisKey];
    [settings synchronize];
}
-(void)SetSettingsStringValue:(NSString*)thisKey value:(NSString*)val {
    NSLog(@"%@: %@", thisKey, val);
    [settings setObject:val forKey:thisKey];
    [settings synchronize];
}
-(void)SetSettingsIntValue:(NSString*)thisKey value:(int)val {
    NSLog(@"%@: %i", thisKey, val);
    [instance.settings setInteger:val forKey:thisKey];
    [settings synchronize];
}


-(void)Posterize:(bool)val {
    instance.posterize = val;
    NSString *key = @"Posterize";
    [self SetSettingsBoolValue:key value:val];
}
-(void)UseCamera:(NSString*)val{
    instance.useCamera = val;
    NSString *key = @"UseCamera";
    NSLog(@"%@",val);
    [self SetSettingsStringValue:key value:val];
}
-(void)Orientation:(int)val{
    instance.orientation = val;
    NSString *key = @"Orientation";
    [self SetSettingsIntValue:key value:val];
}
-(void)ShowPdValues:(bool)val{
    instance.ShowValues = val;
    NSString *key = @"ShowValues";
    [self SetSettingsBoolValue:key value:val];
}
-(void)SendColorValues:(bool)val{
    instance.ShowColor = val;
    NSString *key = @"ShowColor";
    [self SetSettingsBoolValue:key value:val];
}

-(void)SetPixelate:(bool)val{
    instance.pixl = val;
    NSString *key = @"SquarePixels";
    [self SetSettingsBoolValue:key value:val];
}
-(void)SetDots:(bool)val{
    instance.dot = val;
    NSString *key = @"RoundPixels";
    [self SetSettingsBoolValue:key value:val];
}

-(void)SetPixelAmt:(int)val{
    instance.pixlSize = (int)val;
    NSString *key = @"PixelSize";
    [self SetSettingsIntValue:key value:val];
}

-(void)Invert:(bool)val{
    instance.invert = (int)val;
    NSString *key = @"Invert";
    [self SetSettingsBoolValue:key value:val];
}
-(void)Line:(bool)val{
    instance.line = (int)val;
    NSString *key = @"Line";
    [self SetSettingsBoolValue:key value:val];
}
-(void)Sepia:(bool)val{
    instance.sepia = (int)val;
    NSString *key = @"Sepia";
    [self SetSettingsBoolValue:key value:val];
}

-(void)PDFile:(NSString*)val{
    instance.pd = val;
    NSString *key = @"PdFile";
    [self SetSettingsStringValue:key value:val];
}

-(void)NeverShowAlert:(bool)val{
    instance.showAlert = (bool)val;
    NSString *key = @"ShowAlert";
    [self SetSettingsBoolValue:key value:val];
}
-(void)NeverShowAlertHeadphones:(bool)val{
    instance.showAlertHeadphones = (bool)val;
    NSString *key = @"ShowAlertHeadphones";
    [self SetSettingsBoolValue:key value:val];
}

/*

-(void)SendColorPd:(int)val{
    send = (int)val;
    string node = "video:send";
    [self SetXMLValue:node value:(int)val];
}
-(void)Blur:(int)val{
    blur = (int)val;
    string node = "video:blur";
    [self SetXMLValue:node value:(int)val];
}
-(void)BlurLevel:(int)val{
    blurLevel = (int)val;
    string node = "video:blurLevel";
    [self SetXMLValue:node value:(int)val];
}


-(void)SampleRate:(int)val{
    sampleRate = (int)val;
    string node = "sampleRate";
    [self SetXMLValue:node value:(int)val];
}
-(void)BufferSize:(int)val{
    bufferSize = (int)val;
    string node = "bufferSize";
    [self SetXMLValue:node value:(int)val];
}

-(void)UseCamera:(int)val{
    useCamera = (int)val;
    string node = "useCamera";
    [self SetXMLValue:node value:(int)val];
}
 */




@end
