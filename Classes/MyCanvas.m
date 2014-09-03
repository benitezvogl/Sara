//
//  MyCanvas.m
//  SARA
//
//  Created by Chris Yanc on 4/27/14.
//
//

#import "MyCanvas.h"
#import "FVData.h"

@implementation MyCanvas
@synthesize col;
@synthesize colors;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init with frame MyCanvas");
        
        FVData *obj=[FVData getInstance];
        
        colors = [[NSMutableArray alloc] init];
        
        for(int _x =0; _x < self.frame.size.width; _x += obj.pixlSize){
            for(int _y =0; _y < self.frame.size.height; _y += obj.pixlSize){
                UIColor *colr = [UIColor blackColor];
                [colors addObject:colr];
            }
        }
        
        obj=nil;
        [obj release];
    }
    return self;
}

-(void)UpdateArray:(NSMutableArray *)arr {
    
    [colors removeAllObjects];
    for(int i = 0; i < arr.count; i++){
        [colors addObject:arr[i]];
    }
    //[colors arrayByAddingObjectsFromArray:arr];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(colors == nil){
        return;
    }
    // Get the current graphics context
    // (ie. where the drawing should appear)
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [UIColor blackColor].CGColor );
    CGContextFillRect( context, rect );
    
    // Set the width of the line
    CGContextSetLineWidth(context, 2.0);
    FVData *obj=[FVData getInstance];
    
    int cnt = 0;
    //NSLog(@"colors: %lu", (unsigned long)colors.count);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, 0, 0, (obj.pixlSize/2), 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
    CGContextDrawPath(context, kCGPathFill);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    
    //Fill/Stroke the path
    CGContextDrawPath(context, kCGPathFillStroke);
    
    for(int _x =0; _x < self.frame.size.width; _x += obj.pixlSize){
        for(int _y =0; _y < self.frame.size.height; _y += obj.pixlSize){
            //Make the circle
            // 150 = x coordinate
            // 150 = y coordinate
            // 100 = radius of circle
            // 0   = starting angle
            // 2*M_PI = end angle
            // YES = draw clockwise
            CGContextBeginPath(context);
            CGContextAddArc(context, _x+(obj.pixlSize/2), _y+(obj.pixlSize/2), (obj.pixlSize/2), 0, 2*M_PI, YES);
            CGContextClosePath(context);
            
            // Set colour using RGB intensity values
            // 1.0 = 100% red, green or blue
            // the last value is alpha
            CGColorRef colorRef = [[colors objectAtIndex:cnt] CGColor];
            CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 1.0;
            
            int numComponents = CGColorGetNumberOfComponents(colorRef);
            
            if (numComponents == 4)
            {
                const CGFloat *components = CGColorGetComponents(colorRef);
                red = components[0];
                green = components[1];
                blue = components[2];
                alpha = components[3];
            }
            
            //NSLog(@"colors: %f %f %f", red, green, blue);
            //CGContextSetRGBFillColor(context, red, green, blue, 0.1); //blue
            
            //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); //red
            
            // Note: If I wanted to only stroke the path, use:
            // CGContextDrawPath(context, kCGPathStroke);
            // or to only fill it, use:
            CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
            CGContextDrawPath(context, kCGPathFill);
            CGContextSetBlendMode(context, kCGBlendModeClear);
            
            //Fill/Stroke the path
            CGContextDrawPath(context, kCGPathFillStroke);
            
            cnt++;
        }
    }
    obj=nil;
    [obj release];
}


-(void)DrawCircle:(CGRect)rect color:(UIColor*)color {
    col = color;
    [self drawRect:rect];
}

@end
